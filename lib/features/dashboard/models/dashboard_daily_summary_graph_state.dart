// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:expense_manager/data/models/transactions/summarized_transaction_group_by_summary_start.dart';

class DashboardDailySummaryGraphState {
  final List<SummarizedTransactionGroupBySummaryStart>
      dailySummarizedTransactions;
  final BigInt totalSummarizedAmount;
  final List<DateTime> dateRange;

  DashboardDailySummaryGraphState({
    required this.dailySummarizedTransactions,
    required this.totalSummarizedAmount,
    required this.dateRange,
  });

  Map<int, SummarizedTransactionGroupBySummaryStart>
      get dailySummarizedTransactionsMap {
    Map<int, SummarizedTransactionGroupBySummaryStart> map = {};
    for (int i = 0; i < dailySummarizedTransactions.length; i++) {
      final dateRelativeIndex = DateTime.now().day -
          DateTime.parse(dailySummarizedTransactions[i].summaryStart).day;
      map[dateRelativeIndex] = dailySummarizedTransactions[i];
    }
    return map;
  }

  DashboardDailySummaryGraphState copyWith({
    List<SummarizedTransactionGroupBySummaryStart>? dailySummarizedTransactions,
    BigInt? totalSummarizedAmount,
    List<DateTime>? dateRange,
  }) {
    return DashboardDailySummaryGraphState(
      dailySummarizedTransactions:
          dailySummarizedTransactions ?? this.dailySummarizedTransactions,
      totalSummarizedAmount:
          totalSummarizedAmount ?? this.totalSummarizedAmount,
      dateRange: dateRange ?? this.dateRange,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dailySummarizedTransactions':
          dailySummarizedTransactions.map((x) => x.toMap()).toList(),
      'totalSummarizedAmount': totalSummarizedAmount.toString(),
      'dateRange': dateRange.map((x) => x.millisecondsSinceEpoch).toList(),
    };
  }

  factory DashboardDailySummaryGraphState.fromMap(Map<String, dynamic> map) {
    return DashboardDailySummaryGraphState(
      dailySummarizedTransactions:
          List<SummarizedTransactionGroupBySummaryStart>.from(
        (map['dailySummarizedTransactions'] as List<int>)
            .map<SummarizedTransactionGroupBySummaryStart>(
          (x) => SummarizedTransactionGroupBySummaryStart.fromMap(
              x as Map<String, dynamic>),
        ),
      ),
      totalSummarizedAmount: BigInt.from(map['totalSummarizedAmount'] as num),
      dateRange: List<DateTime>.from(
        (map['dateRange'] as List<int>).map<DateTime>(
          (x) => DateTime.fromMillisecondsSinceEpoch(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory DashboardDailySummaryGraphState.fromJson(String source) =>
      DashboardDailySummaryGraphState.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DashboardDailySummaryGraphState(dailySummarizedTransactions: $dailySummarizedTransactions, totalSummarizedAmount: $totalSummarizedAmount, dateRange: $dateRange)';

  @override
  bool operator ==(covariant DashboardDailySummaryGraphState other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return listEquals(
            other.dailySummarizedTransactions, dailySummarizedTransactions) &&
        other.totalSummarizedAmount == totalSummarizedAmount &&
        listEquals(other.dateRange, dateRange);
  }

  @override
  int get hashCode =>
      dailySummarizedTransactions.hashCode ^
      totalSummarizedAmount.hashCode ^
      dateRange.hashCode;
}
