// Verstro billing backend HTTP client (dio)
//
// 职责:
// - 封装全部 /api/billing/v1/* endpoint
// - 自动注入 Authorization: Bearer <token> header
// - 把 dio 原始异常翻成 BackendException 子类型 (UI 层 catch 时不用关心 dio)
// - 401 自动清 token + 抛 UnauthorizedException, 上层判断后跳登录页
//
// 不负责:
// - active backend URL 解析 (那是 MultiDomainRace 的事)
// - Token 持久化 (那是 TokenStorage 的事)
// - UI 状态 (那是 Riverpod provider 的事, 阶段 2.3 接)

import 'dart:io';

import 'package:dio/dio.dart';
// 注意: dio 5.x 默认 BackgroundTransformer 在 macOS release build 上 isolate
// 通信卡死 (Apple Silicon + Dart 3.10 + Flutter 3.38 known issue). 强制
// SyncTransformer 跳过 isolate, JSON 在 main isolate parse.
import 'package:dio/io.dart';

import 'api_exceptions.dart';
import 'api_models.dart';
import 'token_storage.dart';

class BackendApi {
  final Dio _dio;
  final TokenStorage _token;

  BackendApi({
    required String baseUrl,
    required TokenStorage token,
    Dio? dio,
  })  : _token = token,
        _dio = dio ??
            Dio(BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 30),
              sendTimeout: const Duration(seconds: 30),
              headers: {'Accept': 'application/json'},
              validateStatus: (s) => s != null && s < 500,
            )) {
    // 绕开 dio 5.x BackgroundTransformer (isolate parse) 在 macOS release 卡死 bug
    _dio.transformer = SyncTransformer();
    // 用 IOHttpClientAdapter 替代默认 (默认在某些 release build 不发包).
    // createHttpClient: 强制 backend 直连 — 绕过 FlClashHttpOverrides.global.
    // 原因 1: VerstroGate 在 Application.attach() 前调 backend, 此时
    //   appController 未初始化, FlClashHttpOverrides.handleFindProxy 会抛.
    // 原因 2: 即使 Mihomo 启动, backend 调用走 VPN 形成循环依赖 (VPN 死则
    //   续费/登录全部不可用). backend 必须永远直连.
    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.findProxy = (_) => 'DIRECT';
        return client;
      },
    );
    _installAuthInterceptor();
  }

  String get baseUrl => _dio.options.baseUrl;

  /// 更新 base URL (MultiDomainRace 重 race 后调用)
  set baseUrl(String url) => _dio.options.baseUrl = url;

  // ============================================================
  // === Auth ===
  // ============================================================

  Future<AuthResult> register({
    required String email,
    required String password,
    String? referralCode,
  }) async {
    final body = <String, dynamic>{'email': email, 'password': password};
    if (referralCode != null && referralCode.isNotEmpty) {
      body['referral_code'] = referralCode;
    }
    final resp = await _post('/v1/auth/register', body);
    final auth = AuthResult.fromJson(resp);
    await _token.setToken(auth.accessToken);
    await _token.setEmail(email);
    return auth;
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final resp = await _post('/v1/auth/login', {
      'email': email,
      'password': password,
    });
    final auth = AuthResult.fromJson(resp);
    await _token.setToken(auth.accessToken);
    await _token.setEmail(email);
    return auth;
  }

  Future<UserDto> me() async {
    final resp = await _get('/v1/me');
    return UserDto.fromJson(resp);
  }

  /// 验证邮箱 — 旧链接 token 路径 (兼容邮件里已发出的链接).
  Future<void> verifyEmail(String emailToken) async {
    await _post('/v1/auth/verify-email', {'token': emailToken});
  }

  /// 验证邮箱 — 6 位验证码路径 (App 内验证, plan 1-2 阶段D). email 取登录态/注册输入.
  Future<void> verifyEmailWithCode(String email, String code) async {
    await _post('/v1/auth/verify-email', {'email': email, 'code': code});
  }

  Future<void> resendVerification() async {
    // resend-verification 是公开端点(无 JWT), 须 body 带 email; 取登录时存的邮箱.
    final email = await _token.getEmail();
    await _post('/v1/auth/resend-verification', {'email': email ?? ''});
  }

  Future<void> forgotPassword(String email) async {
    await _post('/v1/auth/forgot-password', {'email': email});
  }

  /// 重置密码 — 旧链接 token 路径 (兼容). 字段是 new_password (对齐后端 resetPasswordReq).
  Future<void> resetPassword(String resetToken, String newPassword) async {
    await _post('/v1/auth/reset-password', {
      'token': resetToken,
      'new_password': newPassword,
    });
  }

  /// 重置密码 — 6 位验证码路径 (plan 1-2 阶段D). forgot 发码后用此提交.
  Future<void> resetPasswordWithCode(String email, String code, String newPassword) async {
    await _post('/v1/auth/reset-password', {
      'email': email,
      'code': code,
      'new_password': newPassword,
    });
  }

  /// 清本机 token, 不调 backend (无 logout endpoint, JWT 失效靠 TTL)
  Future<void> logout() => _token.logout();

  // ============================================================
  // === Plans / Orders ===
  // ============================================================

  Future<List<PlanDto>> listPlans() async {
    final resp = await _get('/v1/plans');
    final list = (resp['plans'] as List).cast<Map<String, dynamic>>();
    return list.map(PlanDto.fromJson).toList();
  }

  /// 创建订单, 返回 final_amount (含 cents 尾数) + Tron deposit address
  /// 用户拿这两个去 imToken 转账. couponCode 非空时带入 coupon_code 字段.
  Future<OrderDto> createOrder(String planId, {String? couponCode}) async {
    final body = <String, dynamic>{'plan_id': planId};
    if (couponCode != null && couponCode.isNotEmpty) {
      body['coupon_code'] = couponCode;
    }
    final resp = await _post('/v1/orders', body);
    return OrderDto.fromJson(resp);
  }

  Future<List<OrderDto>> listOrders() async {
    final resp = await _get('/v1/orders');
    final list = (resp['orders'] as List).cast<Map<String, dynamic>>();
    return list.map(OrderDto.fromJson).toList();
  }

  Future<OrderDto> getOrder(int orderId) async {
    final resp = await _get('/v1/orders/$orderId');
    return OrderDto.fromJson(resp);
  }

  /// 用户主动认领 tx hash. backend 立即查 TronGrid + 入观察表 + 尝试匹配.
  /// 比等 30s 轮询快, UI 用 "我已付款" 按钮触发.
  Future<ClaimTxResult> claimTx(int orderId, String txHash) async {
    final resp =
        await _post('/v1/orders/$orderId/claim-tx', {'tx_hash': txHash});
    return ClaimTxResult.fromJson(resp);
  }

  // ============================================================
  // === Subscription ===
  // ============================================================

  Future<SubscriptionDto> getSubscription() async {
    final resp = await _get('/v1/subscription');
    return SubscriptionDto.fromJson(resp);
  }

  // ============================================================
  // === Credit ===
  // ============================================================

  /// 拉用户 credit 钱包余额 + 明细 (M1). JWT.
  Future<CreditDto> getCredit() async {
    final resp = await _get('/v1/me/credit');
    return CreditDto.fromJson(resp);
  }

  /// 拉试用资格 (C4, surface M4). JWT.
  Future<TrialStatusDto> getTrialStatus() async {
    final resp = await _get('/v1/trial/status');
    return TrialStatusDto.fromJson(resp);
  }

  /// 领取试用. 成功无返回(调用方刷新订阅); 失败抛 BackendException
  /// (code: trial_disabled/email_unverified/has_subscription/trial_claimed).
  Future<void> claimTrial() async {
    await _post('/v1/trial/claim', <String, dynamic>{});
  }

  /// 拉用户邀请码/推荐视图 (C2). JWT.
  Future<AgentDto> getAgent() async {
    final resp = await _get('/v1/agent');
    return AgentDto.fromJson(resp);
  }

  /// 拉代理各套餐价格范围+当前售价 (Task 1). JWT.
  Future<AgentPricesDto> getAgentPrices() async {
    final resp = await _get('/v1/agent/prices');
    return AgentPricesDto.fromJson(resp);
  }

  /// 设置指定套餐自定义售价 (reseller/master). JWT.
  Future<void> setAgentPrice(String planId, int priceCents) async {
    await _put('/v1/agent/prices', {'plan_id': planId, 'price_cents': priceCents});
  }

  /// 提现全部可提现余额到 dest(TRC20). 返实际提现额 cents. 失败抛 BackendException(invalid_dest/below_min_payout).
  Future<int> requestPayout(String dest) async {
    final resp = await _post('/v1/agent/payout', {'dest': dest});
    return (resp['amount_cents'] as num?)?.toInt() ?? 0;
  }

  // ============================================================
  // === Devices (T4.1/T4.2, 设备数上限 / 防账号共享) ===
  // ============================================================

  /// 登记当前设备 (登录/启动时调). 后端 upsert + 超每用户上限时踢最早活跃的.
  /// 失败不应阻塞登录/启动 — 调用方 fire-and-forget + catch.
  Future<void> registerDevice({
    required String deviceId,
    required String deviceName,
    required String platform,
  }) async {
    await _post('/v1/devices/register', {
      'device_id': deviceId,
      'device_name': deviceName,
      'platform': platform,
    });
  }

  /// 列出当前用户已登记设备 + 套餐设备上限 (account 页"我的设备"用).
  Future<DevicesInfo> listDevices() async {
    final resp = await _get('/v1/devices');
    return DevicesInfo.fromJson(resp);
  }

  /// 登出指定设备 (account 页手动踢).
  Future<void> deleteDevice(String deviceId) async {
    await _request('DELETE', '/v1/devices/$deviceId');
  }

  // ============================================================
  // === Bootstrap (域名列表更新, 阶段 2.6 用) ===
  // ============================================================

  Future<BootstrapDto> bootstrap() async {
    final resp = await _get('/v1/bootstrap');
    return BootstrapDto.fromJson(resp);
  }

  // ============================================================
  // === 内部: 统一 GET/POST + 错误翻译 ===
  // ============================================================

  void _installAuthInterceptor() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final tok = await _token.getToken();
        if (tok != null && tok.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $tok';
        }
        handler.next(options);
      },
    ));
  }

  Future<Map<String, dynamic>> _get(String path) async {
    return _request('GET', path);
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body,
  ) async {
    return _request('POST', path, body: body);
  }

  Future<Map<String, dynamic>> _put(String path, Map<String, dynamic> body) async {
    return _request('PUT', path, body: body);
  }

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
  }) async {
    Response<dynamic> resp;
    try {
      resp = await _dio.request(
        path,
        data: body,
        options: Options(
          method: method,
          contentType: body != null ? Headers.jsonContentType : null,
        ),
      );
    } on DioException catch (e) {
      throw _translateDioException(e);
    }

    final code = resp.statusCode ?? 0;
    final data = resp.data;

    if (code >= 200 && code < 300) {
      if (data is Map<String, dynamic>) return data;
      if (data == null) return <String, dynamic>{};
      throw ServerException('意料外的响应类型: ${data.runtimeType}', code);
    }

    // 业务错误 (4xx) — 翻译成具体 BackendException
    throw _translateBusinessError(code, data);
  }

  BackendException _translateDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException('请求超时, 检查网络或 VPN');
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return NetworkException('连不上后端: ${e.message ?? "unknown"}');
      case DioExceptionType.badCertificate:
        return NetworkException('TLS 证书错误: ${e.message ?? "unknown"}');
      case DioExceptionType.cancel:
        return const NetworkException('请求已取消');
      case DioExceptionType.badResponse:
        // 不该到这里 (我们 validateStatus < 500), 兜底
        return ServerException(
          e.response?.statusMessage ?? 'bad response',
          e.response?.statusCode,
        );
    }
  }

  BackendException _translateBusinessError(int code, dynamic data) {
    String errCode = 'unknown';
    String errMsg = '';
    if (data is Map<String, dynamic>) {
      errCode = (data['code'] as String?) ?? 'unknown';
      errMsg = (data['message'] as String?) ?? '';
    }

    switch (code) {
      case 401:
        // 401 时清本机 token (server 已经认定凭据无效)
        // 注意: 不要 await — 让调用方拿到异常先
        _token.clearToken();
        switch (errCode) {
          case 'invalid_credentials':
            return InvalidCredentialsException(errMsg.isEmpty ? '邮箱或密码错误' : errMsg);
          case 'token_expired':
            return const TokenExpiredException();
          case 'invalid_token':
            return const TokenInvalidException();
          default:
            return UnauthorizedException(errMsg.isEmpty ? '未授权' : errMsg);
        }
      case 409:
        // email_taken → 注册重复(保既有 register 流的 EmailConflictException catch); 其余携后端 message
        if (errCode == 'email_taken') {
          return const EmailConflictException();
        }
        return ConflictException(errCode, errMsg.isEmpty ? '操作冲突' : errMsg);
      case 403:
        return ForbiddenException(errCode, errMsg.isEmpty ? '无权限' : errMsg);
      case 400:
        return BadRequestException(errCode, errMsg.isEmpty ? '请求参数错误' : errMsg);
      case 404:
        return NotFoundException(errMsg.isEmpty ? '资源不存在' : errMsg);
      default:
        if (code >= 500) {
          return ServerException(
            errMsg.isEmpty ? '服务端错误 ($code)' : errMsg,
            code,
          );
        }
        return ServerException('意料外状态码 $code', code);
    }
  }
}
