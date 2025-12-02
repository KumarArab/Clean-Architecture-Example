class NetworkException implements Exception {
  final String message;
  final int? errorCode;

  NetworkException({required this.message, this.errorCode});
}
