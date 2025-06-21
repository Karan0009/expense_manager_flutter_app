// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Meta {
  final int totalCount;
  final int? totalPages;
  final int? lastPage;
  final int? nextPage;
  final Map<String, dynamic>? filters;

  Meta({
    required this.totalCount,
    this.totalPages,
    this.lastPage,
    this.nextPage,
    this.filters,
  });

  Meta copyWith({
    int? totalCount,
    int? totalPages,
    int? lastPage,
    int? nextPage,
    Map<String, dynamic>? filters,
  }) {
    return Meta(
      totalCount: totalCount ?? this.totalCount,
      totalPages: totalPages ?? this.totalPages,
      lastPage: lastPage ?? this.lastPage,
      nextPage: nextPage ?? this.nextPage,
      filters: filters ?? this.filters,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'total_count': totalCount,
      'total_pages': totalPages,
      'last_page': lastPage,
      'next_page': nextPage,
      'filters': filters,
    };
  }

  factory Meta.fromMap(Map<String, dynamic> map) {
    return Meta(
      totalCount: map['total_count'] as int,
      totalPages: map['total_pages'] != null ? map['total_pages'] as int : null,
      lastPage: map['last_page'] != null ? map['last_page'] as int : null,
      nextPage: map['next_page'] != null ? map['next_page'] as int : null,
      filters: map['filters'] != null
          ? Map<String, dynamic>.from(map['filters'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Meta.fromJson(String source) =>
      Meta.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Meta(totalCount: $totalCount, totalPages: $totalPages, lastPage: $lastPage, nextPage: $nextPage, filters: $filters)';
  }

  @override
  bool operator ==(covariant Meta other) {
    if (identical(this, other)) return true;

    return other.totalCount == totalCount &&
        other.totalPages == totalPages &&
        other.lastPage == lastPage &&
        other.nextPage == nextPage &&
        mapEquals(other.filters, filters);
  }

  @override
  int get hashCode {
    return totalCount.hashCode ^
        totalPages.hashCode ^
        lastPage.hashCode ^
        nextPage.hashCode ^
        filters.hashCode;
  }
}
