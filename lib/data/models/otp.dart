// ignore_for_file: non_constant_identifier_names

import 'package:expense_manager/core/base/base_model.dart';

class Otp implements BaseModel {
  final String otp_code;
  final String retry_after;
  final String valid_till;

  Otp(
      {required this.otp_code,
      required this.retry_after,
      required this.valid_till});

  @override
  factory Otp.fromJson(Map<String, dynamic> json) {
    if (json['otp_code'] == null ||
        json['retry_after'] == '' ||
        json['valid_till'] == null ||
        json['valid_till'].toString() == '') {
      throw Exception("invalid values");
    }
    return Otp(
      otp_code: (json['otp_code'] ?? '').toString(),
      retry_after: (json['retry_after'] ?? '').toString(),
      valid_till: (json['valid_till'] ?? '').toString(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'otp_code': otp_code,
      'retry_after': retry_after,
      'valid_till': valid_till,
    };
  }

  @override
  String toString() {
    return 'Otp{id: $otp_code , retry_after: $retry_after, valid_till: $valid_till}';
  }

  @override
  Otp clone() {
    return Otp(
      otp_code: otp_code,
      retry_after: retry_after,
      valid_till: valid_till,
    );
  }
}
