// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MainCategory {
  final int id;
  final String name;
  final String description;
  final String? icon;

  MainCategory({
    required this.id,
    required this.name,
    required this.description,
    this.icon,
  });

  MainCategory copyWith({
    int? id,
    String? name,
    String? description,
    String? icon,
  }) {
    return MainCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
    };
  }

  factory MainCategory.fromMap(Map<String, dynamic> map) {
    final parsedId = int.tryParse(map['id']);
    if (parsedId == null) {
      throw FormatException('Invalid id format');
    }
    return MainCategory(
      id: parsedId,
      name: map['name'] as String,
      description: map['description'] as String,
      icon: map['icon'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory MainCategory.fromJson(String source) =>
      MainCategory.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'MainCategory(id: $id, name: $name, description: $description, icon: $icon)';

  @override
  bool operator ==(covariant MainCategory other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.icon == icon;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      (icon?.hashCode ?? 0);
}
