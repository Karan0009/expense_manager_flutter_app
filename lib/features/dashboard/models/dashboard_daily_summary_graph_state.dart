import 'package:expense_manager/data/models/transactions/summarized_transaction.dart';

class DashboardDailySummaryGraphState {
  final List<SummarizedTransaction> dailySummarizedTransactions;
  final BigInt totalSummarizedAmount;
  final List<DateTime> dateRange;

  DashboardDailySummaryGraphState({
    required this.dailySummarizedTransactions,
    required this.totalSummarizedAmount,
    required this.dateRange,
  });

  Map<int, SummarizedTransaction> get dailySummarizedTransactionsMap {
    return {
      for (int i = 0; i < dailySummarizedTransactions.length; i++)
        i: dailySummarizedTransactions[i],
    };
  }
}
