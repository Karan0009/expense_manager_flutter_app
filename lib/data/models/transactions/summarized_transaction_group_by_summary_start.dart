// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:expense_manager/core/helpers/utils.dart';

class SummarizedTransactionGroupBySummaryStart {
  final String userId;
  final BigInt totalAmount;
  final String summaryStart;

  SummarizedTransactionGroupBySummaryStart({
    required this.userId,
    required this.totalAmount,
    required this.summaryStart,
  });

  SummarizedTransactionGroupBySummaryStart copyWith({
    String? userId,
    BigInt? totalAmount,
    String? summaryStart,
  }) {
    return SummarizedTransactionGroupBySummaryStart(
      userId: userId ?? this.userId,
      totalAmount: totalAmount ?? this.totalAmount,
      summaryStart: summaryStart ?? this.summaryStart,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'totalAmount': totalAmount,
      'summaryStart': summaryStart,
    };
  }

  factory SummarizedTransactionGroupBySummaryStart.fromMap(
      Map<String, dynamic> map) {
    BigInt totalAmount = AppUtils.safeParseBigInt(map['total_amount']);

    return SummarizedTransactionGroupBySummaryStart(
      userId: map['user_id'] as String,
      totalAmount: totalAmount,
      summaryStart: map['summary_start'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SummarizedTransactionGroupBySummaryStart.fromJson(String source) =>
      SummarizedTransactionGroupBySummaryStart.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SummarizedTransactionGroupBySummaryStart(userId: $userId, totalAmount: $totalAmount, summaryStart: $summaryStart)';

  @override
  bool operator ==(covariant SummarizedTransactionGroupBySummaryStart other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.totalAmount == totalAmount &&
        other.summaryStart == summaryStart;
  }

  @override
  int get hashCode =>
      userId.hashCode ^ totalAmount.hashCode ^ summaryStart.hashCode;
}
