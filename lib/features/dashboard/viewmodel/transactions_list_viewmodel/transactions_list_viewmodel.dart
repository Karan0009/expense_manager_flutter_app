import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:expense_manager/config/app_config.dart';
import 'package:expense_manager/core/app_failure.dart';
import 'package:expense_manager/core/app_failure_type_def.dart';
import 'package:expense_manager/core/helpers/utils.dart';
import 'package:expense_manager/core/http/http_type_def.dart';
import 'package:expense_manager/data/models/common/meta.dart';
import 'package:expense_manager/data/models/transactions/user_transaction.dart';
import 'package:expense_manager/data/repositories/transaction/transaction_remote_repository.dart';
import 'package:expense_manager/features/dashboard/models/dashboard_transactions_list_state.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_list_viewmodel.g.dart';

@riverpod
class TransactionsListViewModel extends _$TransactionsListViewModel {
  late TransactionRemoteRepository _transactionRemoteRepository;

  @override
  Future<DashboardTransactionsListState?> build() async {
    _transactionRemoteRepository =
        ref.watch(transactionRemoteRepositoryProvider);
    return null;
  }

  FutureEither<DashboardTransactionsListState?> loadTransctions(
    int page,
    int subCatId,
  ) async {
    state = const AsyncValue.loading();

    final dateRange =
        AppUtils.getFormattedDateRange(DateTime.now(), DateRangeType.month);

    final result = await _transactionRemoteRepository.getTransactions(
      fromDate: DateFormat('yyyy-MM-dd').format(dateRange['start']),
      toDate: DateFormat('yyyy-MM-dd').format(dateRange['end']),
      orderBy: AppConfig.sortByDesc,
      sortBy: 'transaction_datetime',
      limit: AppConfig.restClientGetMaxLimit,
      page: page,
      subCatId: subCatId,
    );
    return result.fold(
      (error) {
        state = AsyncValue.error(error, StackTrace.current);
        return Left(error);
      },
      (apiResponse) {
        final newState = DashboardTransactionsListState(
          dateRange: dateRange,
          subCategoryId: subCatId,
          transactions: (state.value?.transactions ?? []) + apiResponse.data,
          meta: apiResponse.meta,
        );
        state = AsyncValue.data(newState);
        return Right(newState);
      },
    );
  }

  FutureAppFailureEitherVoid loadMoreTransactions() async {
    if (state.value == null && state.value?.meta == null) {
      return Left(
        AppFailure(
          message: 'No transactions to load',
          stackTrace: StackTrace.current,
        ),
      );
    }
    if (state.value?.meta.nextPage == null || state.value?.meta.nextPage == 0) {
      return Left(
        AppFailure(
          message: 'No more transactions to load',
          stackTrace: StackTrace.current,
        ),
      );
    }
    final result = await _transactionRemoteRepository.getTransactions(
      fromDate: state.value!.dateRange['start'],
      toDate: state.value!.dateRange['end'],
      subCatId: state.value!.subCategoryId,
      page: state.value!.meta.nextPage!,
      orderBy: AppConfig.sortByDesc,
      sortBy: 'transaction_datetime',
      limit: AppConfig.restClientGetMaxLimit,
    );
    return result.fold(
      (error) {
        return Left(AppFailure(
          message: error.message,
          stackTrace: StackTrace.current,
        ));
      },
      (apiResponse) {
        state = AsyncValue.data(
          DashboardTransactionsListState(
            dateRange: state.value!.dateRange,
            subCategoryId: state.value!.subCategoryId,
            transactions: (state.value?.transactions ?? []) + apiResponse.data,
            meta: apiResponse.meta,
          ),
        );

        return Right(null);
        // return Right(DashboardTransactionsListState(
        //   transactions:
        //       (state.value?.transactions ?? []) + apiResponse.data,
        //   meta: apiResponse.meta,
        // ));
      },
    );
  }

  FutureVoid editTransaction(
    UserTransaction updatedTransaction,
  ) async {
    // Make a copy of the current list
    final currentTransactions =
        List<UserTransaction>.from(state.value?.transactions ?? []);

    // Insert the new transaction at the beginning
    final existingIndex =
        currentTransactions.indexWhere((t) => t.id == updatedTransaction.id);

    // If the transaction does not exist, do nothing
    if (existingIndex == -1) {
      return;
    }

    if (updatedTransaction.subCategory == null ||
        updatedTransaction.subCategory!.id !=
            state.value?.transactions[existingIndex].subCategory?.id) {
      // * if category got is categorized now then do following
      currentTransactions.removeAt(existingIndex);
      // if sub category is uncategorized, remove the transaction

      state = AsyncValue.data(DashboardTransactionsListState(
        dateRange: state.value!.dateRange,
        subCategoryId: state.value!.subCategoryId,
        transactions: currentTransactions,
        meta: state.value?.meta.copyWith(
              totalCount: max((state.value?.meta.totalCount ?? 0) - 1, 0),
            ) ??
            Meta(totalCount: 1),
      ));
    } else {
      // * if category got is still uncategorized then do following
      // Update the existing transaction
      currentTransactions[existingIndex] = updatedTransaction;

      // Update the state with the modified list
      state = AsyncValue.data(DashboardTransactionsListState(
        dateRange: state.value!.dateRange,
        subCategoryId: state.value!.subCategoryId,
        transactions: currentTransactions,
        meta: state.value?.meta.copyWith(
              totalCount: (state.value?.meta.totalCount ?? 0),
            ) ??
            Meta(totalCount: 1),
      ));
    }
  }

  FutureVoid removeTransaction(int id) async {
    final currentTransactions =
        List<UserTransaction>.from(state.value?.transactions ?? []);

    currentTransactions.removeWhere((t) => t.id == id);

    state = AsyncValue.data(DashboardTransactionsListState(
      dateRange: state.value!.dateRange,
      subCategoryId: state.value!.subCategoryId,
      transactions: currentTransactions,
      meta: state.value?.meta.copyWith(
            totalCount: (state.value?.meta.totalCount ?? 0) - 1,
          ) ??
          Meta(
            totalCount: 0,
          ),
    ));
  }
}
