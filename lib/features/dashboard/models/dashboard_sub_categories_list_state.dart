// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:expense_manager/data/models/category/sub_category.dart';
import 'package:expense_manager/data/models/common/meta.dart';

class DashboardSubCategoriesListState {
  final List<SubCategory> subCategories;
  final Meta meta;

  DashboardSubCategoriesListState({
    required this.subCategories,
    required this.meta,
  });

  DashboardSubCategoriesListState copyWith({
    List<SubCategory>? subCategories,
    Meta? meta,
  }) {
    return DashboardSubCategoriesListState(
      subCategories: subCategories ?? this.subCategories,
      meta: meta ?? this.meta,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'subCategories': subCategories.map((x) => x.toMap()).toList(),
      'meta': meta.toMap(),
    };
  }

  factory DashboardSubCategoriesListState.fromMap(Map<String, dynamic> map) {
    return DashboardSubCategoriesListState(
      subCategories: List<SubCategory>.from(
        (map['subCategories'] as List<int>).map<SubCategory>(
          (x) => SubCategory.fromMap(x as Map<String, dynamic>),
        ),
      ),
      meta: Meta.fromMap(map['meta'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory DashboardSubCategoriesListState.fromJson(String source) =>
      DashboardSubCategoriesListState.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DashboardSubCategoriesListState(subCategories: $subCategories, meta: $meta)';

  @override
  bool operator ==(covariant DashboardSubCategoriesListState other) {
    if (identical(this, other)) return true;

    return listEquals(other.subCategories, subCategories) && other.meta == meta;
  }

  @override
  int get hashCode => subCategories.hashCode ^ meta.hashCode;
}
