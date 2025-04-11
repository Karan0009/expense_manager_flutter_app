// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HttpFailure {
  final String message;
  final int statusCode;
  final StackTrace stackTrace;

  HttpFailure({
    required this.message,
    this.statusCode = 500,
    this.stackTrace = StackTrace.empty,
  });

  HttpFailure copyWith({
    String? message,
    int? statusCode,
    StackTrace? stackTrace,
  }) {
    return HttpFailure(
      message: message ?? this.message,
      statusCode: statusCode ?? this.statusCode,
      stackTrace: stackTrace ?? this.stackTrace,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'statusCode': statusCode,
      'stackTrace': jsonDecode(stackTrace.toString()),
    };
  }

  factory HttpFailure.fromMap(Map<String, dynamic> map) {
    return HttpFailure(
      message: map['message'] as String,
      statusCode: map['statusCode'] as int,
      stackTrace: StackTrace.fromString(map['stackTrace'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory HttpFailure.fromJson(String source) =>
      HttpFailure.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'HttpFailure(message: $message, statusCode: $statusCode, stackTrace: ${stackTrace.toString()})';

  @override
  bool operator ==(covariant HttpFailure other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.statusCode == statusCode &&
        other.stackTrace == stackTrace;
  }

  @override
  int get hashCode =>
      message.hashCode ^ statusCode.hashCode ^ stackTrace.hashCode;
}
