// ignore_for_file: non_constant_identifier_names

import 'package:expense_manager/core/base/base_model.dart';

class User implements BaseModel {
  final String id;
  final String name;
  final String phone_number;
  final String email;
  final String? token;

  User({
    required this.id,
    required this.name,
    required this.phone_number,
    required this.email,
    this.token,
  });

  /// Factory method to create a User instance from JSON.
  @override
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      phone_number: json['phone_number'] as String,
      email: json['email'] as String,
      token: json['token'] as String?,
    );
  }

  /// Convert the User instance to JSON.
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phone_number,
      'email': email,
      'token': token,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, phone_number: $phone_number, email: $email, token: $token}';
  }

  @override
  User clone() {
    return User(
      id: id,
      name: name,
      phone_number: phone_number,
      email: email,
      token: token,
    );
  }
}
