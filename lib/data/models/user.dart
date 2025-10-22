// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class User {
  final String? id;
  final String? name;
  final String? city;
  final String? occupation;

  /// Default country code is set to +91
  final String? country_code;
  final String phone_number;
  final String? email;
  final String? token;
  final String? created_at;

  User({
    this.id,
    this.name,
    this.city,
    this.occupation,
    this.country_code = '+91',
    required this.phone_number,
    this.email,
    this.token,
    this.created_at,
  });

  User copyWith({
    String? id,
    String? name,
    String? city,
    String? occupation,
    String? country_code,
    String? phone_number,
    String? email,
    String? token,
    String? created_at,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      occupation: occupation ?? this.occupation,
      country_code: country_code ?? this.country_code,
      phone_number: phone_number ?? this.phone_number,
      email: email ?? this.email,
      token: token ?? this.token,
      created_at: created_at ?? this.created_at,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'city': city,
      'occupation': occupation,
      'country_code': country_code,
      'phone_number': phone_number,
      'email': email,
      'token': token,
      'created_at': created_at,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      occupation:
          map['occupation'] != null ? map['occupation'] as String : null,
      country_code:
          map['country_code'] != null ? map['country_code'] as String : null,
      phone_number: map['phone_number'] as String,
      email: map['email'] != null ? map['email'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
      created_at:
          map['created_at'] != null ? map['created_at'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, name: $name, city: $city, occupation: $occupation, country_code: $country_code, phone_number: $phone_number, email: $email, token: $token, created_at: $created_at)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.city == city &&
        other.occupation == occupation &&
        other.country_code == country_code &&
        other.phone_number == phone_number &&
        other.email == email &&
        other.token == token &&
        other.created_at == created_at;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        city.hashCode ^
        occupation.hashCode ^
        country_code.hashCode ^
        phone_number.hashCode ^
        email.hashCode ^
        token.hashCode ^
        created_at.hashCode;
  }
}
