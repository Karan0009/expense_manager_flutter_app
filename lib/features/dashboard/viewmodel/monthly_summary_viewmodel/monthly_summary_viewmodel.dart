import 'package:dartz/dartz.dart';
import 'package:expense_manager/config/app_config.dart';
import 'package:expense_manager/core/http/http_type_def.dart';
import 'package:expense_manager/data/models/transactions/summarized_transaction.dart';
import 'package:expense_manager/data/models/transactions/user_transaction.dart';
import 'package:expense_manager/features/dashboard/models/dashboard_monthly_summary_state.dart';
import 'package:expense_manager/data/repositories/transaction_summary/transaction_summary_remote_repository.dart';
import 'package:intl/intl.dart';
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
        .getSummarizedTransactions<SummarizedTransaction>(
          onDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          summaryType: 'monthly',
          sortBy: 'transaction_datetime',
          orderBy: AppConfig.sortByDesc,
          groupBy: 'sub_cat_id',
          fromMapFn: SummarizedTransaction.fromMap,
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

        return Right(DashboardMonthlySummaryState(
          categorySummarizedTransactions: data.data,
          totalSummarizedAmount: totalAmount,
        ));
      },
    );
  }

  FutureVoid addNewTransaction(UserTransaction t) async {
    int? transactionAmount = int.tryParse(t.amount);

    if (transactionAmount == null) {
      return;
    }

    final currentTransactions = List<SummarizedTransaction>.from(
        state.value?.categorySummarizedTransactions ?? []);

    int existingIndex = currentTransactions
        .indexWhere((element) => element.subCatId == t.subCatId);

    if (existingIndex != -1) {
      final existingTransaction = currentTransactions[existingIndex];
      currentTransactions[existingIndex] = existingTransaction.copyWith(
        totalAmount:
            existingTransaction.totalAmount + BigInt.from(transactionAmount),
      );
    } else {
      final transactionDate = DateFormat('yyyy-MM-dd')
          .format(t.transactionDatetime ?? DateTime.now());
      currentTransactions.add(SummarizedTransaction(
        userId: t.userId,
        summaryStart: transactionDate,
        subCategory: t.subCategory!,
        subCatId: t.subCatId,
        totalAmount: BigInt.from(transactionAmount),
      ));
    }

    final newTotalAmount = (state.value?.totalSummarizedAmount ?? BigInt.zero) +
        BigInt.from(transactionAmount);

    state = AsyncValue.data(DashboardMonthlySummaryState(
      categorySummarizedTransactions: currentTransactions,
      totalSummarizedAmount: newTotalAmount,
    ));
  }

  FutureVoid removeTransaction(UserTransaction transaction) async {
    int? transactionAmount = int.tryParse(transaction.amount);

    if (transactionAmount == null) {
      return;
    }
    final currentTransactions = List<SummarizedTransaction>.from(
        state.value?.categorySummarizedTransactions ?? []);

    int existingIndex = currentTransactions
        .indexWhere((element) => element.subCatId == transaction.subCatId);

    if (existingIndex != -1) {
      final existingTransaction = currentTransactions[existingIndex];
      currentTransactions[existingIndex] = existingTransaction.copyWith(
        totalAmount:
            existingTransaction.totalAmount - BigInt.from(transactionAmount),
      );
    }

    final newTotalAmount = (state.value?.totalSummarizedAmount ?? BigInt.zero) -
        BigInt.from(transactionAmount);

    state = AsyncValue.data(DashboardMonthlySummaryState(
      categorySummarizedTransactions: currentTransactions,
      totalSummarizedAmount: newTotalAmount,
    ));
  }

  FutureVoid editTransaction(
    UserTransaction updatedTransaction,
    UserTransaction prevData,
  ) async {
    removeTransaction(prevData);
    addNewTransaction(updatedTransaction);
  }
}
