// Verstro backend API 业务异常分类
//
// 设计原则:
// - 业务异常用具体子类 (Unauthorized / Conflict / etc.), UI 层 catch 时按类型分流
// - 网络层异常 (timeout / no route) 包成 NetworkException, 让 UI 提示 "网络问题, 检查 VPN/重试"
// - dio 原始 DioException 不要漏到 UI 层
// - i18n: 默认文案不再写死中文. const 构造只存空串哨兵, message getter 在被读取
//   (UI 展示边界) 时才解析 appLocalizations —— 这样 const 构造点 (backend_api /
//   multi_domain_race) 零改动, 上屏文字全部来自 arb.
//
// 跟 后端 billing 服务的 error code 一一对应:
// - 401 unauthorized       → UnauthorizedException
// - 401 invalid_credentials → InvalidCredentialsException
// - 401 invalid_signature   → 不会出现 (这是 webhook only, 阶段 2.0 已删)
// - 401 token_expired      → TokenExpiredException
// - 401 invalid_token      → TokenInvalidException
// - 409 email_taken        → EmailConflictException (注册重复)
// - 409 其余冲突           → ConflictException (如 has_subscription / trial_claimed)
// - 403 forbidden          → ForbiddenException (如 trial_disabled)
// - 400 invalid_*          → BadRequestException
// - 404 not_found          → NotFoundException
// - 5xx                    → ServerException

import 'package:fl_clash/common/app_localizations.dart';
import 'package:fl_clash/verstro/api/error_i18n.dart';

abstract class BackendException implements Exception {
  final String code;
  final String _message; // 构造时传入的原始文案; 空串 = 展示时用本地化默认文案
  final int? httpStatus;

  const BackendException(this.code, this._message, [this.httpStatus]);

  /// 上屏文案. 已知业务码优先本地化 (覆盖后端中文 message); 否则构造时带了
  /// message (通常是后端返回的人话) 就原样用; 再否则读取时才取本地化默认文案
  /// (const 构造无法直接持有 appLocalizations).
  String get message {
    final localized = localizedBusinessError(code);
    if (localized != null) return localized;
    return _message.isNotEmpty ? _message : _fallbackMessage;
  }

  /// 各子类的本地化默认文案, 在 UI 读 message 时才解析.
  String get _fallbackMessage => appLocalizations.vApiServerError;

  @override
  String toString() => 'BackendException($code, $httpStatus): $message';
}

class NetworkException extends BackendException {
  const NetworkException(String message) : super('network', message);
}

class UnauthorizedException extends BackendException {
  const UnauthorizedException([String message = ''])
      : super('unauthorized', message, 401);

  @override
  String get _fallbackMessage => appLocalizations.vApiNotLoggedIn;
}

class InvalidCredentialsException extends BackendException {
  const InvalidCredentialsException([String message = ''])
      : super('invalid_credentials', message, 401);

  @override
  String get _fallbackMessage => appLocalizations.vApiInvalidCredentials;
}

class TokenExpiredException extends BackendException {
  const TokenExpiredException() : super('token_expired', '', 401);

  @override
  String get _fallbackMessage => appLocalizations.vApiTokenExpired;
}

class TokenInvalidException extends BackendException {
  const TokenInvalidException() : super('invalid_token', '', 401);

  @override
  String get _fallbackMessage => appLocalizations.vApiTokenInvalid;
}

class EmailConflictException extends BackendException {
  const EmailConflictException() : super('email_conflict', '', 409);

  @override
  String get _fallbackMessage => appLocalizations.vApiEmailTaken;
}

/// 403 — 无权限 / 被拒 (如 trial_disabled). 携带后端 code+message.
class ForbiddenException extends BackendException {
  const ForbiddenException(String code, String message) : super(code, message, 403);
}

/// 409 — 资源冲突 (如 has_subscription / trial_claimed, 非邮箱重复). 携带后端 code+message.
class ConflictException extends BackendException {
  const ConflictException(String code, String message) : super(code, message, 409);
}

class BadRequestException extends BackendException {
  const BadRequestException(String code, String message) : super(code, message, 400);
}

class NotFoundException extends BackendException {
  const NotFoundException([String message = '']) : super('not_found', message, 404);

  @override
  String get _fallbackMessage => appLocalizations.vApiNotFound;
}

class ServerException extends BackendException {
  const ServerException([String message = '', int? status])
      : super('server_error', message, status);

  @override
  String get _fallbackMessage => appLocalizations.vApiServerError;
}

class NoActiveBackendException extends BackendException {
  const NoActiveBackendException() : super('no_active_backend', '');

  @override
  String get _fallbackMessage => appLocalizations.vApiNoActiveBackend;
}
