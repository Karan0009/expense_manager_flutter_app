// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:expense_manager/data/models/transactions/summarized_transaction.dart';

class DashboardMonthlySummaryState {
  final List<SummarizedTransaction> categorySummarizedTransactions;
  final BigInt totalSummarizedAmount;

  DashboardMonthlySummaryState({
    required this.categorySummarizedTransactions,
    required this.totalSummarizedAmount,
  });

  DashboardMonthlySummaryState copyWith({
    List<SummarizedTransaction>? categorySummarizedTransactions,
    BigInt? totalSummarizedAmount,
  }) {
    return DashboardMonthlySummaryState(
      categorySummarizedTransactions:
          categorySummarizedTransactions ?? this.categorySummarizedTransactions,
      totalSummarizedAmount:
          totalSummarizedAmount ?? this.totalSummarizedAmount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'categorySummarizedTransactions':
          categorySummarizedTransactions.map((x) => x.toMap()).toList(),
      'totalSummarizedAmount': totalSummarizedAmount,
    };
  }

  factory DashboardMonthlySummaryState.fromMap(Map<String, dynamic> map) {
    return DashboardMonthlySummaryState(
      categorySummarizedTransactions: List<SummarizedTransaction>.from(
        (map['categorySummarizedTransactions'] as List<int>)
            .map<SummarizedTransaction>(
          (x) => SummarizedTransaction.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalSummarizedAmount: BigInt.from(map['totalSummarizedAmount']),
    );
  }

  String toJson() => json.encode(toMap());

  factory DashboardMonthlySummaryState.fromJson(String source) =>
      DashboardMonthlySummaryState.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DashboardMonthlySummaryState(categorySummarizedTransactions: $categorySummarizedTransactions, totalSummarizedAmount: $totalSummarizedAmount)';

  @override
  bool operator ==(covariant DashboardMonthlySummaryState other) {
    if (identical(this, other)) return true;

    return listEquals(other.categorySummarizedTransactions,
            categorySummarizedTransactions) &&
        other.totalSummarizedAmount == totalSummarizedAmount;
  }

  @override
  int get hashCode =>
      categorySummarizedTransactions.hashCode ^ totalSummarizedAmount.hashCode;
}
