import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:expense_manager/config/app_config.dart';
import 'package:expense_manager/core/helpers/utils.dart';
import 'package:expense_manager/core/http/http_failure.dart';
import 'package:expense_manager/core/http/http_type_def.dart';
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
    final curDate = DateTime.tryParse('2025-02-04');
    if (curDate == null) {
      return Left(
          HttpFailure(message: 'invalid current date', statusCode: 500));
    }
    final dateRange =
        AppUtils.getFormattedDateRange(curDate, DateRangeType.week);
    final res = await ref
        .read(transactionSummaryRemoteRepositoryProvider)
        .getSummarizedTransactions(
          fromDate: DateFormat('yyyy-MM-dd').format(dateRange['start']),
          toDate: DateFormat('yyyy-MM-dd').format(dateRange['end']),
          summaryType: AppConfig.summaryTypeDaily,
          sortBy: 'transaction_datetime',
          orderBy: AppConfig.sortByDesc,
        );

    return res.fold(
      (error) {
        return Left(error);
      },
      (data) {
        BigInt totalAmount = data.data
            .map((e) => e.totalAmount)
            .reduce((value, element) => value + element);
        return Right(DashboardDailySummaryGraphState(
          dailySummarizedTransactions: data.data,
          totalSummarizedAmount: totalAmount,
          dateRange: dateRange['dates'],
        ));
      },
    );
  }
}
