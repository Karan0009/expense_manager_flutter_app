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
    final summary = await getWeeksDayWiseSummary(DateTime.now());
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

  FutureVoid refresh() async {
    state = const AsyncValue.loading();
    final summary = await getWeeksDayWiseSummary(DateTime.now());

    summary.fold(
      (error) => state = AsyncValue.error(error.message, StackTrace.current),
      (summary) => state = AsyncValue.data(summary),
    );
  }

  FutureVoid getPreviousWeekSummary() async {
    state = const AsyncValue.loading();
    final currentStartDate = state.value?.dateRange.first;
    if (currentStartDate == null) {
      state =
          AsyncValue.error('No current date range found', StackTrace.current);
      return;
    }
    final previousWeekStartDate =
        currentStartDate.subtract(const Duration(days: 1));
    final summary = await getWeeksDayWiseSummary(previousWeekStartDate);

    summary.fold(
      (error) => state = AsyncValue.error(error.message, StackTrace.current),
      (summary) => state = AsyncValue.data(summary),
    );
  }

  FutureVoid getNextWeekSummary() async {
    state = const AsyncValue.loading();
    final currentLastDate = state.value?.dateRange.last;
    if (currentLastDate == null) {
      state =
          AsyncValue.error('No current date range found', StackTrace.current);
      return;
    }
    final nextWeekStartDate = currentLastDate.add(const Duration(days: 7));
    final summary = await getWeeksDayWiseSummary(nextWeekStartDate);

    summary.fold(
      (error) => state = AsyncValue.error(error.message, StackTrace.current),
      (summary) => state = AsyncValue.data(summary),
    );
  }

  FutureEither<DashboardDailySummaryGraphState> getWeeksDayWiseSummary(
    DateTime startDate,
  ) async {
    final dateRange = AppUtils.getFormattedDateRange(
      startDate.subtract(const Duration(days: 6)),
      DateRangeType.week,
      isInputDateStartDate: true,
      orderAscending: true,
    );
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
    if (!isTransactionInCurrentWeek(t)) {
      // If the transaction is not in the current week, do not edit it
      return;
    }

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
    if (!isTransactionInCurrentWeek(updatedTransaction)) {
      // If the transaction is not in the current week, do not edit it
      return;
    }

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
    if (!isTransactionInCurrentWeek(transaction)) {
      // If the transaction is not in the current week, do not remove it
      return;
    }
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

  bool isTransactionInCurrentWeek(UserTransaction transaction) {
    final curDate = DateTime.now();
    final dateRange = AppUtils.getFormattedDateRange(
        curDate, DateRangeType.week,
        isInputDateStartDate: true);
    if (transaction.transactionDatetime == null) {
      // default date is current date
      return true;
    }

    return transaction.transactionDatetime!.day >= dateRange['start'].day &&
        transaction.transactionDatetime!.day <= dateRange['end'].day &&
        transaction.transactionDatetime!.month == dateRange['start'].month &&
        transaction.transactionDatetime!.year == dateRange['start'].year;
  }
}
