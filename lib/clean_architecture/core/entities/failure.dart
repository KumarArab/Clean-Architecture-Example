class Failure {
  final String message;

  Failure({required this.message});
}

class NetworkFailure extends Failure {
  final int? errorCode;
  NetworkFailure({
    required super.message,
    this.errorCode,
  });
}
