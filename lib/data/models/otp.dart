// ignore_for_file: non_constant_identifier_names

import 'package:expense_manager/core/base/base_model.dart';

class Otp implements BaseModel {
  final String id;

  Otp({
    required this.id,
  });

  @override
  factory Otp.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null) {
      throw Exception("Id is required");
    }
    return Otp(
      id: json['id'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }

  @override
  String toString() {
    return 'User{id: $id}';
  }

  @override
  Otp clone() {
    return Otp(
      id: id,
    );
  }
}
