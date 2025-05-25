// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:expense_manager/data/models/category/main_category.dart';
import 'package:expense_manager/data/models/common/meta.dart';

class DashboardMainCategoriesListState {
  final List<MainCategory> categories;
  final Meta meta;

  DashboardMainCategoriesListState({
    required this.categories,
    required this.meta,
  });

  DashboardMainCategoriesListState copyWith({
    List<MainCategory>? categories,
    Meta? meta,
  }) {
    return DashboardMainCategoriesListState(
      categories: categories ?? this.categories,
      meta: meta ?? this.meta,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'categories': categories.map((x) => x.toMap()).toList(),
      'meta': meta.toMap(),
    };
  }

  factory DashboardMainCategoriesListState.fromMap(Map<String, dynamic> map) {
    return DashboardMainCategoriesListState(
      categories: List<MainCategory>.from(
        (map['categories'] as List<int>).map<MainCategory>(
          (x) => MainCategory.fromMap(x as Map<String, dynamic>),
        ),
      ),
      meta: Meta.fromMap(map['meta'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory DashboardMainCategoriesListState.fromJson(String source) =>
      DashboardMainCategoriesListState.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DashboardMainCategoriesListState(categories: $categories, meta: $meta)';

  @override
  bool operator ==(covariant DashboardMainCategoriesListState other) {
    if (identical(this, other)) return true;

    return listEquals(other.categories, categories) && other.meta == meta;
  }

  @override
  int get hashCode => categories.hashCode ^ meta.hashCode;
}
