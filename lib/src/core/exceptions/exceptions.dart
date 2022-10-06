class TetaException implements Exception {
  TetaException({
    required this.cause,
    required this.stackTrace,
  });

  final String cause;
  final String stackTrace;
}

class TetaCmsServerRequestException extends TetaException {
  TetaCmsServerRequestException({
    required this.httpCode,
    required this.serverErrorResponse,
    required String cause,
    required String stackTrace,
  }) : super(cause: cause, stackTrace: stackTrace);
  final int httpCode;
  final dynamic serverErrorResponse;
}
