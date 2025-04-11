import 'dart:convert';

class AppFailure {
  final String message;
  final StackTrace stackTrace;

  AppFailure({
    required this.message,
    this.stackTrace = StackTrace.empty,
  });

  AppFailure copyWith({
    String? message,
    StackTrace? stackTrace,
  }) {
    return AppFailure(
      message: message ?? this.message,
      stackTrace: stackTrace ?? this.stackTrace,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'stackTrace': jsonDecode(stackTrace.toString()),
    };
  }

  factory AppFailure.fromMap(Map<String, dynamic> map) {
    return AppFailure(
      message: map['message'] as String,
      stackTrace: StackTrace.fromString(map['stackTrace'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppFailure.fromJson(String source) =>
      AppFailure.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AppFailure(message: $message, stackTrace: $stackTrace)';

  @override
  bool operator ==(covariant AppFailure other) {
    if (identical(this, other)) return true;

    return other.message == message && other.stackTrace == stackTrace;
  }

  @override
  int get hashCode => message.hashCode ^ stackTrace.hashCode;
}
