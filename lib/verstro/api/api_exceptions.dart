// Verstro backend API 业务异常分类
//
// 设计原则:
// - 业务异常用具体子类 (Unauthorized / Conflict / etc.), UI 层 catch 时按类型分流
// - 网络层异常 (timeout / no route) 包成 NetworkException, 让 UI 提示 "网络问题, 检查 VPN/重试"
// - dio 原始 DioException 不要漏到 UI 层
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

abstract class BackendException implements Exception {
  final String code;
  final String message;
  final int? httpStatus;

  const BackendException(this.code, this.message, [this.httpStatus]);

  @override
  String toString() => 'BackendException($code, $httpStatus): $message';
}

class NetworkException extends BackendException {
  const NetworkException(String message) : super('network', message);
}

class UnauthorizedException extends BackendException {
  const UnauthorizedException([String message = '未登录或会话过期'])
      : super('unauthorized', message, 401);
}

class InvalidCredentialsException extends BackendException {
  const InvalidCredentialsException([String message = '邮箱或密码错误'])
      : super('invalid_credentials', message, 401);
}

class TokenExpiredException extends BackendException {
  const TokenExpiredException() : super('token_expired', '登录会话已过期, 请重新登录', 401);
}

class TokenInvalidException extends BackendException {
  const TokenInvalidException() : super('invalid_token', '登录凭证无效', 401);
}

class EmailConflictException extends BackendException {
  const EmailConflictException() : super('email_conflict', '该邮箱已注册', 409);
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
  const NotFoundException([String message = '资源不存在']) : super('not_found', message, 404);
}

class ServerException extends BackendException {
  const ServerException([String message = '服务端错误, 请稍后重试', int? status])
      : super('server_error', message, status);
}

class NoActiveBackendException extends BackendException {
  const NoActiveBackendException()
      : super('no_active_backend', '所有备用域名都无法连接, 检查网络');
}
