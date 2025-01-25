class HttpFailure {
  final String message;
  final StackTrace stackTrace;

  HttpFailure({
    required this.message,
    this.stackTrace = StackTrace.empty,
  });
}
