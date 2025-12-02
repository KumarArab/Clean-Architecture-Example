class AuthException implements Exception {
  final String message;
  final String? errorCode;

  AuthException({required this.message, this.errorCode});
}
