// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:expense_manager/core/helpers/utils.dart';

class SubCategory {
  final int id;
  final String name;
  final String? icon;
  final String description;
  final String? userId;
  final int? categoryId;

  SubCategory({
    required this.id,
    required this.name,
    this.icon,
    required this.description,
    this.userId,
    this.categoryId,
  });

  SubCategory copyWith({
    int? id,
    String? name,
    String? icon,
    String? description,
    String? userId,
    int? categoryId,
  }) {
    return SubCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'icon': icon,
      'description': description,
      'userId': userId,
      'categoryId': categoryId,
    };
  }

  factory SubCategory.fromMap(Map<String, dynamic> map) {
    int? subCatIdInt = AppUtils.safeParseInt(map['id']);
    int? categoryId = AppUtils.safeParseInt(map['category_id']);
    return SubCategory(
      id: subCatIdInt ?? 0,
      name: map['name'] as String,
      icon: map['icon'] != null ? map['icon'] as String : null,
      description: map['description'] as String,
      userId: map['user_id'] != null ? map['user_id'] as String : null,
      categoryId: categoryId,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubCategory.fromJson(String source) =>
      SubCategory.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SubCategory(id: $id, name: $name, icon: $icon, description: $description, userId: $userId, categoryId: $categoryId)';
  }

  @override
  bool operator ==(covariant SubCategory other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.icon == icon &&
        other.description == description &&
        other.userId == userId &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        icon.hashCode ^
        description.hashCode ^
        userId.hashCode ^
        categoryId.hashCode;
  }
}
