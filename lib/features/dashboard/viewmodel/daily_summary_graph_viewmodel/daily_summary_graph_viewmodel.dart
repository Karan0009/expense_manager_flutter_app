import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:expense_manager/config/app_config.dart';
import 'package:expense_manager/core/helpers/utils.dart';
import 'package:expense_manager/core/http/http_type_def.dart';
import 'package:expense_manager/data/models/transactions/summarized_transaction_group_by_summary_start.dart';
import 'package:expense_manager/data/models/transactions/user_transaction.dart';
import 'package:expense_manager/data/repositories/transaction_summary/transaction_summary_remote_repository.dart';
import 'package:expense_manager/features/dashboard/models/dashboard_daily_summary_graph_state.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'daily_summary_graph_viewmodel.g.dart';

@riverpod
class DailySummaryGraphViewModel extends _$DailySummaryGraphViewModel {
  @override
  Future<DashboardDailySummaryGraphState?> build() async {
    final summary = await getCurrentWeeksDayWiseSummary();
    return summary.fold(
      (error) {
        log(error.message);
        throw Exception(error.message);
        // return Left(
        //     AppFailure(message: error.message, stackTrace: StackTrace.current));
      },
      (summary) {
        log(summary.toString());
        return summary;
      },
    );
  }

  FutureEither<DashboardDailySummaryGraphState>
      getCurrentWeeksDayWiseSummary() async {
    final curDate = DateTime.now();
    // if (curDate == null) {
    //   return Left(
    //       HttpFailure(message: 'invalid current date', statusCode: 500));
    // }
    final dateRange =
        AppUtils.getFormattedDateRange(curDate, DateRangeType.week);
    final res = await ref
        .read(transactionSummaryRemoteRepositoryProvider)
        .getSummarizedTransactions<SummarizedTransactionGroupBySummaryStart>(
          fromDate: DateFormat('yyyy-MM-dd').format(dateRange['start']),
          toDate: DateFormat('yyyy-MM-dd').format(dateRange['end']),
          summaryType: AppConfig.summaryTypeDaily,
          sortBy: 'transaction_datetime',
          orderBy: AppConfig.sortByAsc,
          fromMapFn: SummarizedTransactionGroupBySummaryStart.fromMap,
          groupBy: 'summary_start',
        );

    return res.fold(
      (error) {
        return Left(error);
      },
      (data) {
        BigInt totalAmount = BigInt.from(0);
        if (data.data.isNotEmpty) {
          totalAmount = data.data
              .map((e) => e.totalAmount)
              .reduce((value, element) => value + element);
        }

        return Right(DashboardDailySummaryGraphState(
          dailySummarizedTransactions: data.data,
          totalSummarizedAmount: totalAmount,
          dateRange: dateRange['dates'],
        ));
      },
    );
  }

  FutureVoid addNewTransaction(UserTransaction t) async {
    int? transactionAmount = int.tryParse(t.amount);

    if (transactionAmount == null) {
      return;
    }

    final transactionDate = DateFormat('yyyy-MM-dd')
        .format(t.transactionDatetime ?? DateTime.now());
    final currentTransactions = state.value?.dailySummarizedTransactions ?? [];

    int existingIndex = currentTransactions
        .indexWhere((element) => element.summaryStart == transactionDate);

    if (existingIndex != -1) {
      final existingTransaction = currentTransactions[existingIndex];
      currentTransactions[existingIndex] = existingTransaction.copyWith(
        totalAmount:
            existingTransaction.totalAmount + BigInt.from(transactionAmount),
      );
    } else {
      // ➕ If it doesn't exist, add a new summarized transaction
      currentTransactions.add(SummarizedTransactionGroupBySummaryStart(
        userId: t.userId,
        // todo: fix later
        summaryStart: transactionDate,
        totalAmount: BigInt.from(transactionAmount),
      ));
    }

    final newTotalAmount = (state.value?.totalSummarizedAmount ?? BigInt.zero) +
        BigInt.from(transactionAmount);

    state = AsyncValue.data(state.value?.copyWith(
      dailySummarizedTransactions: currentTransactions,
      totalSummarizedAmount: newTotalAmount,
    ));
  }

  FutureVoid editTransaction(
    UserTransaction updatedTransaction,
    UserTransaction originalTransaction,
  ) async {
    int? transactionAmount = int.tryParse(updatedTransaction.amount);
    int? originalTransactionAmount = int.tryParse(originalTransaction.amount);

    if (transactionAmount == null ||
        originalTransactionAmount == null ||
        updatedTransaction.id != originalTransaction.id) {
      return;
    }

    final transactionDate = DateFormat('yyyy-MM-dd')
        .format(updatedTransaction.transactionDatetime ?? DateTime.now());
    final currentTransactions = state.value?.dailySummarizedTransactions ?? [];

    int existingIndex = currentTransactions
        .indexWhere((element) => element.summaryStart == transactionDate);

    if (existingIndex != -1) {
      final existingTransaction = currentTransactions[existingIndex];
      currentTransactions[existingIndex] = existingTransaction.copyWith(
        totalAmount: existingTransaction.totalAmount -
            BigInt.from(originalTransactionAmount) +
            BigInt.from(transactionAmount),
      );
    } else {
      // ➕ If it doesn't exist, add a new summarized transaction
      currentTransactions.add(SummarizedTransactionGroupBySummaryStart(
        userId: updatedTransaction.userId,
        // todo: fix later
        summaryStart: transactionDate,
        totalAmount: BigInt.from(transactionAmount),
      ));
    }

    final newTotalAmount = (state.value?.totalSummarizedAmount ?? BigInt.zero) -
        BigInt.from(originalTransactionAmount) +
        BigInt.from(transactionAmount);

    state = AsyncValue.data(state.value?.copyWith(
      dailySummarizedTransactions: currentTransactions,
      totalSummarizedAmount: newTotalAmount,
    ));
  }

  FutureVoid removeTransaction(UserTransaction transaction) async {
    int? transactionAmount = int.tryParse(transaction.amount);

    if (transactionAmount == null) {
      return;
    }

    final transactionDate = DateFormat('yyyy-MM-dd')
        .format(transaction.transactionDatetime ?? DateTime.now());
    final currentTransactions = state.value?.dailySummarizedTransactions ?? [];

    int existingIndex = currentTransactions
        .indexWhere((element) => element.summaryStart == transactionDate);

    if (existingIndex != -1) {
      final existingTransaction = currentTransactions[existingIndex];
      currentTransactions[existingIndex] = existingTransaction.copyWith(
        totalAmount:
            existingTransaction.totalAmount - BigInt.from(transactionAmount),
      );
    }

    BigInt newTotalAmount =
        (state.value?.totalSummarizedAmount ?? BigInt.zero) -
            BigInt.from(transactionAmount);

    if (newTotalAmount < BigInt.zero) {
      newTotalAmount = BigInt.zero;
    }

    state = AsyncValue.data(state.value?.copyWith(
      dailySummarizedTransactions: currentTransactions,
      totalSummarizedAmount: newTotalAmount,
    ));
  }
}
