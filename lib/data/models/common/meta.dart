// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Meta {
  final int totalCount;
  final int? totalPages;
  final int? lastPage;
  final int? nextPageNumber;
  final Map<String, dynamic>? filters;

  Meta({
    required this.totalCount,
    this.totalPages,
    this.lastPage,
    this.nextPageNumber,
    this.filters,
  });

  Meta copyWith({
    int? totalCount,
    int? totalPages,
    int? lastPage,
    int? nextPageNumber,
    Map<String, dynamic>? filters,
  }) {
    return Meta(
      totalCount: totalCount ?? this.totalCount,
      totalPages: totalPages ?? this.totalPages,
      lastPage: lastPage ?? this.lastPage,
      nextPageNumber: nextPageNumber ?? this.nextPageNumber,
      filters: filters ?? this.filters,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'total_count': totalCount,
      'total_pages': totalPages,
      'last_page': lastPage,
      'next_page_number': nextPageNumber,
      'filters': filters,
    };
  }

  factory Meta.fromMap(Map<String, dynamic> map) {
    return Meta(
      totalCount: map['total_count'] as int,
      totalPages: map['total_pages'] != null ? map['total_pages'] as int : null,
      lastPage: map['last_page'] != null ? map['last_page'] as int : null,
      nextPageNumber: map['next_page_number'] != null
          ? map['next_page_number'] as int
          : null,
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
    return 'Meta(totalCount: $totalCount, totalPages: $totalPages, lastPage: $lastPage, nextPageNumber: $nextPageNumber, filters: $filters)';
  }

  @override
  bool operator ==(covariant Meta other) {
    if (identical(this, other)) return true;

    return other.totalCount == totalCount &&
        other.totalPages == totalPages &&
        other.lastPage == lastPage &&
        other.nextPageNumber == nextPageNumber &&
        mapEquals(other.filters, filters);
  }

  @override
  int get hashCode {
    return totalCount.hashCode ^
        totalPages.hashCode ^
        lastPage.hashCode ^
        nextPageNumber.hashCode ^
        filters.hashCode;
  }
}
