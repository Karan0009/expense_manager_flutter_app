// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:expense_manager/core/helpers/utils.dart';
import 'package:expense_manager/data/models/category/sub_category.dart';

class SummarizedTransaction {
  final String userId;
  final BigInt totalAmount;
  final String summaryStart;
  final int subCatId;
  final SubCategory subCategory;

  SummarizedTransaction({
    required this.userId,
    required this.totalAmount,
    required this.summaryStart,
    required this.subCatId,
    required this.subCategory,
  });

  SummarizedTransaction copyWith({
    String? userId,
    BigInt? totalAmount,
    String? summaryStart,
    int? subCatId,
    SubCategory? subCategory,
  }) {
    return SummarizedTransaction(
      userId: userId ?? this.userId,
      totalAmount: totalAmount ?? this.totalAmount,
      summaryStart: summaryStart ?? this.summaryStart,
      subCatId: subCatId ?? this.subCatId,
      subCategory: subCategory ?? this.subCategory,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'totalAmount': totalAmount,
      'summaryStart': summaryStart,
      'subCatId': subCatId,
      'subCategory': subCategory.toMap(),
    };
  }

  factory SummarizedTransaction.fromMap(Map<String, dynamic> map) {
    BigInt totalAmount = AppUtils.safeParseBigInt(map['total_amount']);
    int? subCatIdInt = AppUtils.safeParseInt(map['sub_cat_id']);

    return SummarizedTransaction(
      userId: map['user_id'] as String,
      totalAmount: totalAmount,
      summaryStart: map['summary_start'] as String,
      subCatId: subCatIdInt ?? 0,
      subCategory:
          SubCategory.fromMap(map['sub_category'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory SummarizedTransaction.fromJson(String source) =>
      SummarizedTransaction.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SummarizedTransaction(userId: $userId, totalAmount: $totalAmount, summaryStart: $summaryStart, subCatId: $subCatId, subCategory: $subCategory)';
  }

  @override
  bool operator ==(covariant SummarizedTransaction other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.totalAmount == totalAmount &&
        other.summaryStart == summaryStart &&
        other.subCatId == subCatId &&
        other.subCategory == subCategory;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        totalAmount.hashCode ^
        summaryStart.hashCode ^
        subCatId.hashCode ^
        subCategory.hashCode;
  }
}
