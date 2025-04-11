import 'package:dartz/dartz.dart';
import 'package:expense_manager/config/app_config.dart';
import 'package:expense_manager/core/http/http_type_def.dart';
import 'package:expense_manager/features/dashboard/models/dashboard_monthly_summary_state.dart';
import 'package:expense_manager/data/repositories/transaction_summary/transaction_summary_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'monthly_summary_viewmodel.g.dart';

@riverpod
class MonthlySummaryViewModel extends _$MonthlySummaryViewModel {
  @override
  Future<DashboardMonthlySummaryState?> build() async {
    final summary = await getMonthlySummary();
    return summary.fold(
      (error) {
        print(error.message);
        throw Exception(error.message);
        // return Left(
        //     AppFailure(message: error.message, stackTrace: StackTrace.current));
      },
      (summary) {
        print(summary);
        return summary;
      },
    );
  }

  FutureEither<DashboardMonthlySummaryState> getMonthlySummary() async {
    final res = await ref
        .read(transactionSummaryRemoteRepositoryProvider)
        .getSummarizedTransactions(
          onDate: '2025-02-18',
          summaryType: 'monthly',
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
        return Right(DashboardMonthlySummaryState(
          categorySummarizedTransactions: data.data,
          totalSummarizedAmount: totalAmount,
        ));
      },
    );
  }
}
