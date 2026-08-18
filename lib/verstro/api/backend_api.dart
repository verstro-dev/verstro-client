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
import 'dart:math';

import 'package:dio/dio.dart';
// 注意: dio 5.x 默认 BackgroundTransformer 在 macOS release build 上 isolate
// 通信卡死 (Apple Silicon + Dart 3.10 + Flutter 3.38 known issue). 强制
// SyncTransformer 跳过 isolate, JSON 在 main isolate parse.
import 'package:dio/io.dart';
import 'package:fl_clash/common/app_localizations.dart';
import 'package:fl_clash/verstro/api/error_i18n.dart';

import 'api_exceptions.dart';
import 'api_models.dart';
import 'membership_card_models.dart';
import 'token_storage.dart';

Map<String, dynamic> buildCreateOrderBody(
  String planId, {
  String? couponCode,
  String? promotionQuoteToken,
  required int expectedPlanVersionId,
  required int expectedBasePriceCents,
}) {
  final body = <String, dynamic>{
    'plan_id': planId,
    'expected_plan_version_id': expectedPlanVersionId,
    'expected_base_price_cents': expectedBasePriceCents,
  };
  if (couponCode != null && couponCode.isNotEmpty) {
    body['coupon_code'] = couponCode;
  }
  if (promotionQuoteToken != null && promotionQuoteToken.isNotEmpty) {
    body['promotion_quote_token'] = promotionQuoteToken;
  }
  return body;
}

Map<String, dynamic> buildPromotionQuoteBody(
  String planId, {
  String? couponCode,
  required int expectedPlanVersionId,
  required int expectedBasePriceCents,
}) {
  final body = <String, dynamic>{
    'plan_id': planId,
    'expected_plan_version_id': expectedPlanVersionId,
    'expected_base_price_cents': expectedBasePriceCents,
  };
  if (couponCode != null && couponCode.trim().isNotEmpty) {
    body['coupon_code'] = couponCode.trim();
  }
  return body;
}

class BackendApi {
  final Dio _dio;
  final TokenStorage _token;

  BackendApi({required String baseUrl, required TokenStorage token, Dio? dio})
    : _token = token,
      _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 30),
              sendTimeout: const Duration(seconds: 30),
              headers: {'Accept': 'application/json'},
              validateStatus: (s) => s != null && s < 500,
            ),
          ) {
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
  Future<void> resetPasswordWithCode(
    String email,
    String code,
    String newPassword,
  ) async {
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
    // 购买页只在登录后出现，必须取账号绑定代理后的有效价；公开 /v1/plans 仅供未登录营销展示。
    final resp = await _get('/v1/me/plans');
    final list = (resp['plans'] as List).cast<Map<String, dynamic>>();
    return list.map(PlanDto.fromJson).toList();
  }

  Future<List<PromotionSummaryDto>> listActivePromotions() async {
    final resp = await _get(
      '/v1/promotions/active',
      headers: const {'Cache-Control': 'no-store'},
    );
    return ((resp['promotions'] as List?) ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(PromotionSummaryDto.fromJson)
        .toList(growable: false);
  }

  Future<MyPromotionsDto> listMyPromotions() async {
    final resp = await _get(
      '/v1/me/promotions',
      headers: const {'Cache-Control': 'no-store'},
    );
    return MyPromotionsDto.fromJson(resp);
  }

  Future<void> recordPromotionEvent({
    required String eventType,
    required String exposureToken,
    required String channel,
  }) async {
    if ((eventType != 'impression' && eventType != 'view') ||
        exposureToken.isEmpty ||
        channel.isEmpty) {
      return;
    }
    final random = Random.secure();
    final eventId = List<int>.generate(
      16,
      (_) => random.nextInt(256),
    ).map((value) => value.toRadixString(16).padLeft(2, '0')).join();
    await _post('/v1/me/promotions/events', {
      'event_type': eventType,
      'exposure_token': exposureToken,
      'event_id': eventId,
      'channel': channel,
    });
  }

  Future<PromotionQuoteDto> quoteOrder(
    String planId, {
    String? couponCode,
    required int expectedPlanVersionId,
    required int expectedBasePriceCents,
    CancelToken? cancelToken,
  }) async {
    final resp = await _post(
      '/v1/orders/quote',
      buildPromotionQuoteBody(
        planId,
        couponCode: couponCode,
        expectedPlanVersionId: expectedPlanVersionId,
        expectedBasePriceCents: expectedBasePriceCents,
      ),
      headers: const {'Cache-Control': 'no-store'},
      cancelToken: cancelToken,
    );
    return PromotionQuoteDto.fromJson(resp);
  }

  /// 创建订单, 返回 final_amount (含 cents 尾数) + Tron deposit address
  /// 用户拿这两个去 imToken 转账. couponCode 非空时带入 coupon_code 字段.
  Future<OrderDto> createOrder(
    String planId, {
    String? couponCode,
    String? promotionQuoteToken,
    required int expectedPlanVersionId,
    required int expectedBasePriceCents,
  }) async {
    final body = buildCreateOrderBody(
      planId,
      couponCode: couponCode,
      promotionQuoteToken: promotionQuoteToken,
      expectedPlanVersionId: expectedPlanVersionId,
      expectedBasePriceCents: expectedBasePriceCents,
    );
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
    final resp = await _post('/v1/orders/$orderId/claim-tx', {
      'tx_hash': txHash,
    });
    return ClaimTxResult.fromJson(resp);
  }

  // ============================================================
  // === Membership cards ===
  // ============================================================

  Future<MembershipCardQuote> quoteMembershipCards(
    List<MembershipCardCartItem> items, {
    required bool useCashBackedCredit,
  }) async {
    final response = await _post('/v1/membership-card-orders/quote', {
      'items': items.map((item) => item.toJson()).toList(growable: false),
      'use_cash_backed_credit': useCashBackedCredit,
    }, headers: _membershipCardHeaders);
    return MembershipCardQuote.fromJson(response);
  }

  Future<MembershipCardOrderResult> createMembershipCardOrder(
    List<MembershipCardCartItem> items, {
    required bool useCashBackedCredit,
    required String expectedQuoteHash,
    required String idempotencyKey,
  }) async {
    final response = await _post(
      '/v1/membership-card-orders',
      {
        'items': items.map((item) => item.toJson()).toList(growable: false),
        'use_cash_backed_credit': useCashBackedCredit,
        'expected_quote_hash': expectedQuoteHash,
      },
      headers: <String, dynamic>{
        ..._membershipCardHeaders,
        'Idempotency-Key': idempotencyKey,
      },
    );
    return MembershipCardOrderResult.fromJson(response);
  }

  Future<List<MembershipCardOrder>> listMembershipCardOrders() async {
    final response = await _get(
      '/v1/membership-card-orders',
      headers: _membershipCardHeaders,
    );
    return _jsonMaps(
      response['orders'],
    ).map(MembershipCardOrder.fromJson).toList(growable: false);
  }

  Future<MembershipCardOrder> getMembershipCardOrder(int orderId) async {
    final response = await _get(
      '/v1/membership-card-orders/$orderId',
      headers: _membershipCardHeaders,
    );
    return MembershipCardOrder.fromJson(response);
  }

  Future<ClaimTxResult> claimMembershipCardTx(
    int orderId,
    String txHash,
  ) async {
    final response = await _post(
      '/v1/membership-card-orders/$orderId/claim-tx',
      {'tx_hash': txHash},
      headers: _membershipCardHeaders,
    );
    return ClaimTxResult.fromJson(response);
  }

  Future<List<MembershipCardInventoryItem>> listMembershipCards() async {
    final response = await _get(
      '/v1/membership-cards',
      headers: _membershipCardHeaders,
    );
    return _jsonMaps(
      response['items'],
    ).map(MembershipCardInventoryItem.fromJson).toList(growable: false);
  }

  Future<void> issueMembershipCardRevealChallenge(String purpose) async {
    await _post('/v1/membership-cards/reveal/challenge', {
      'purpose': purpose,
    }, headers: _membershipCardHeaders);
  }

  Future<MembershipCardRevealGrant> verifyMembershipCardRevealChallenge({
    required String purpose,
    required String code,
  }) async {
    final response = await _post('/v1/membership-cards/reveal/verify', {
      'purpose': purpose,
      'code': code,
    }, headers: _membershipCardHeaders);
    return MembershipCardRevealGrant.fromJson(response);
  }

  Future<MembershipCardRevealResult> revealMembershipCard(
    String cardId,
    String grantToken,
  ) async {
    final response = await _post('/v1/membership-cards/$cardId/reveal', {
      'grant_token': grantToken,
    }, headers: _membershipCardHeaders);
    return MembershipCardRevealResult.fromJson(response);
  }

  Future<MembershipCardRedemptionPreview> previewMembershipCardRedemption(
    String code,
  ) async {
    final response = await _post('/v1/membership-card-redemptions/preview', {
      'code': code,
    }, headers: _membershipCardHeaders);
    return MembershipCardRedemptionPreview.fromJson(response);
  }

  Future<MembershipCardRedemptionResult> confirmMembershipCardRedemption(
    String previewToken, {
    required String idempotencyKey,
  }) async {
    final response = await _post(
      '/v1/membership-card-redemptions',
      buildMembershipCardConfirmBody(<String, dynamic>{
        'preview_token': previewToken,
      }),
      headers: <String, dynamic>{
        ..._membershipCardHeaders,
        'Idempotency-Key': idempotencyKey,
      },
    );
    return MembershipCardRedemptionResult.fromJson(response);
  }

  Future<MembershipEntitlementTimeline>
  getMembershipEntitlementTimeline() async {
    final response = await _get(
      '/v1/membership-entitlements',
      headers: _membershipCardHeaders,
    );
    return MembershipEntitlementTimeline.fromJson(response);
  }

  static const Map<String, dynamic> _membershipCardHeaders = <String, dynamic>{
    'Cache-Control': 'no-cache',
  };

  static List<Map<String, dynamic>> _jsonMaps(dynamic value) =>
      (value as List? ?? const [])
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList(growable: false);

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
    await _put('/v1/agent/prices', {
      'plan_id': planId,
      'price_cents': priceCents,
    });
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
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final tok = await _token.getToken();
          if (tok != null && tok.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $tok';
          }
          handler.next(options);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _get(
    String path, {
    Map<String, dynamic>? headers,
  }) async {
    return _request('GET', path, headers: headers);
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body, {
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async {
    return _request(
      'POST',
      path,
      body: body,
      headers: headers,
      cancelToken: cancelToken,
    );
  }

  Future<Map<String, dynamic>> _put(
    String path,
    Map<String, dynamic> body,
  ) async {
    return _request('PUT', path, body: body);
  }

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async {
    Response<dynamic> resp;
    try {
      resp = await _dio.request(
        path,
        data: body,
        options: Options(
          method: method,
          contentType: body != null ? Headers.jsonContentType : null,
          headers: headers,
        ),
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _translateDioException(e);
    }

    final code = resp.statusCode ?? 0;
    final data = resp.data;

    if (code >= 200 && code < 300) {
      if (data is Map<String, dynamic>) return data;
      if (data == null) return <String, dynamic>{};
      throw ServerException(
        appLocalizations.vApiUnexpectedResponseType(data.runtimeType),
        code,
      );
    }

    // 业务错误 (4xx) — 翻译成具体 BackendException
    throw _translateBusinessError(code, data);
  }

  BackendException _translateDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(appLocalizations.vApiRequestTimeout);
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return NetworkException(
          appLocalizations.vApiConnectFailed(e.message ?? 'unknown'),
        );
      case DioExceptionType.badCertificate:
        return NetworkException(
          appLocalizations.vApiTlsCertError(e.message ?? 'unknown'),
        );
      case DioExceptionType.cancel:
        return NetworkException(appLocalizations.vApiRequestCancelled);
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
    String? reasonCode;
    if (data is Map<String, dynamic>) {
      errCode = (data['code'] as String?) ?? 'unknown';
      errMsg = (data['message'] as String?) ?? '';
      reasonCode = data['reason_code'] as String?;
    }

    // i18n: 已知业务 code → 本地化文案覆盖后端中文 message; 未命中保留后端 message 作兜底。
    // 覆盖 errMsg 后, 下面各分支的 `errMsg.isEmpty ? 通用 : errMsg` 会用本地化串。
    // reason_code(如 coupon_sold_out) 优先于顶层 code 查本地化表; 二者都未命中则保留后端 message。
    final localizedMsg = businessErrorMessage(reasonCode ?? errCode, errMsg);
    if (localizedMsg != null) errMsg = localizedMsg;

    switch (code) {
      case 401:
        // 401 时清本机 token (server 已经认定凭据无效)
        // 注意: 不要 await — 让调用方拿到异常先
        _token.clearToken();
        switch (errCode) {
          case 'invalid_credentials':
            return InvalidCredentialsException(
              errMsg.isEmpty ? appLocalizations.vApiInvalidCredentials : errMsg,
            );
          case 'token_expired':
            return const TokenExpiredException();
          case 'invalid_token':
            return const TokenInvalidException();
          default:
            return UnauthorizedException(
              errMsg.isEmpty ? appLocalizations.vApiUnauthorized : errMsg,
            );
        }
      case 409:
        // email_taken → 注册重复(保既有 register 流的 EmailConflictException catch); 其余携后端 message
        if (errCode == 'email_taken') {
          return const EmailConflictException();
        }
        return ConflictException(
          errCode,
          errMsg.isEmpty ? appLocalizations.vApiConflict : errMsg,
        );
      case 403:
        return ForbiddenException(
          errCode,
          errMsg.isEmpty ? appLocalizations.vApiForbidden : errMsg,
        );
      case 400:
        return BadRequestException(
          errCode,
          errMsg.isEmpty ? appLocalizations.vApiBadRequest : errMsg,
        );
      case 404:
        return NotFoundException(
          errMsg.isEmpty ? appLocalizations.vApiNotFound : errMsg,
        );
      default:
        if (code >= 500) {
          return ServerException(
            errMsg.isEmpty
                ? appLocalizations.vApiServerErrorStatus(code)
                : errMsg,
            code,
          );
        }
        return ServerException(
          errMsg.isEmpty ? appLocalizations.vApiUnexpectedStatus(code) : errMsg,
          code,
        );
    }
  }
}
