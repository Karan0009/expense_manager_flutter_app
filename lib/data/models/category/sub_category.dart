// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:expense_manager/core/helpers/utils.dart';

class SubCategory {
  final int id;
  final String name;
  final String? icon;
  final String description;

  SubCategory({
    required this.id,
    required this.name,
    this.icon,
    required this.description,
  });

  SubCategory copyWith({
    int? id,
    String? name,
    String? icon,
    String? description,
  }) {
    return SubCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'icon': icon,
      'description': description,
    };
  }

  factory SubCategory.fromMap(Map<String, dynamic> map) {
    int? subCatIdInt = AppUtils.safeParseInt(map['sub_cat_id']);
    return SubCategory(
      id: subCatIdInt ?? 0,
      name: map['name'] as String,
      icon: map['icon'] != null ? map['icon'] as String : null,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubCategory.fromJson(String source) =>
      SubCategory.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SubCategory(id: $id, name: $name, icon: $icon, description: $description)';
  }

  @override
  bool operator ==(covariant SubCategory other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.icon == icon &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ icon.hashCode ^ description.hashCode;
  }
}
