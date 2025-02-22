// ignore_for_file: non_constant_identifier_names

import 'package:expense_manager/core/base/base_model.dart';

class Otp implements BaseModel {
  final String code;
  final String retry_after;
  final String valid_till;

  Otp(
      {required this.code,
      required this.retry_after,
      required this.valid_till});

  @override
  factory Otp.fromJson(Map<String, dynamic> json) {
    if (json['code'] == null ||
        json['retry_after'] == '' ||
        json['valid_till'] == '') {
      throw Exception("invalid values");
    }
    return Otp(
      code: json['code'] as String,
      retry_after: json['retry_after'] as String,
      valid_till: json['valid_till'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'retry_after': retry_after,
      'valid_till': valid_till,
    };
  }

  @override
  String toString() {
    return 'User{id: $code , retry_after: $retry_after, valid_till: $valid_till}';
  }

  @override
  Otp clone() {
    return Otp(
      code: code,
      retry_after: retry_after,
      valid_till: valid_till,
    );
  }
}
