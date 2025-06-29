import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:expense_manager/config/app_config.dart';
import 'package:expense_manager/core/app_failure.dart';
import 'package:expense_manager/core/app_failure_type_def.dart';
import 'package:expense_manager/core/http/http_type_def.dart';
import 'package:expense_manager/data/models/common/meta.dart';
import 'package:expense_manager/data/models/transactions/user_transaction.dart';
import 'package:expense_manager/data/repositories/transaction/transaction_remote_repository.dart';
import 'package:expense_manager/features/dashboard/models/dashboard_uncategorized_transactions_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_uncategorized_transactions_list_viewmodel.g.dart';

@riverpod
class DashboardUncategorizedTransactionsListViewModel
    extends _$DashboardUncategorizedTransactionsListViewModel {
  late TransactionRemoteRepository _transactionRemoteRepository;

  @override
  Future<DashboardUncategorizedTransactionsState?> build() async {
    _transactionRemoteRepository =
        ref.watch(transactionRemoteRepositoryProvider);
    final data = await loadTransctions(state.value?.meta.nextPage ?? 1);
    return data.fold(
      (error) {
        throw Exception(error.message);
        // return Left(
        //     AppFailure(message: error.message, stackTrace: StackTrace.current));
      },
      (data) {
        return data;
      },
    );
  }

  void resetDateState() {
    state = AsyncValue.data(
      DashboardUncategorizedTransactionsState(
        uncategorizedTransactions: [],
        meta: Meta(
          totalCount: 0,
          filters: {},
          lastPage: 0,
          nextPage: 0,
          totalPages: 1,
        ),
      ),
    );
  }

  FutureVoid refresh() async {
    resetDateState();
    state = const AsyncValue.loading();
    final result = await loadTransctions(1);

    result.fold(
      (error) => state = AsyncValue.error(error.message, StackTrace.current),
      (data) => state = AsyncValue.data(data),
    );
  }

  FutureEither<DashboardUncategorizedTransactionsState?> loadTransctions(
    int page,
  ) async {
    final result = await _transactionRemoteRepository.getTransactions(
      orderBy: AppConfig.sortByDesc,
      sortBy: 'transaction_datetime',
      limit: AppConfig.restClientGetMaxLimit,
      page: page,
      subCatId: AppConfig.uncategorizedSubCatId,
    );
    return result.fold(
      (error) {
        return Left(error);
      },
      (apiResponse) {
        return Right(DashboardUncategorizedTransactionsState(
          uncategorizedTransactions:
              (state.value?.uncategorizedTransactions ?? []) + apiResponse.data,
          meta: apiResponse.meta,
        ));
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
      orderBy: AppConfig.sortByDesc,
      sortBy: 'transaction_datetime',
      limit: AppConfig.restClientGetMaxLimit,
      page: state.value!.meta.nextPage!,
      subCatId: AppConfig.uncategorizedSubCatId,
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
          DashboardUncategorizedTransactionsState(
            uncategorizedTransactions:
                (state.value?.uncategorizedTransactions ?? []) +
                    apiResponse.data,
            meta: apiResponse.meta,
          ),
        );

        return Right(null);
        // return Right(DashboardUncategorizedTransactionsState(
        //   uncategorizedTransactions:
        //       (state.value?.uncategorizedTransactions ?? []) + apiResponse.data,
        //   meta: apiResponse.meta,
        // ));
      },
    );
  }

  FutureVoid addNewTransaction(
    UserTransaction t,
  ) async {
    // Make a copy of the current list
    final currentTransactions = List<UserTransaction>.from(
        state.value?.uncategorizedTransactions ?? []);

    // Insert the new transaction at the beginning
    currentTransactions.insert(0, t);

    // Create a new state with updated transactions and metadata
    state = AsyncValue.data(DashboardUncategorizedTransactionsState(
      uncategorizedTransactions: currentTransactions,
      meta: state.value?.meta.copyWith(
            totalCount: (state.value?.meta.totalCount ?? 0) + 1,
          ) ??
          Meta(totalCount: 1),
    ));
  }

  FutureVoid editTransaction(
    UserTransaction updatedTransaction,
  ) async {
    // Make a copy of the current list
    final currentTransactions = List<UserTransaction>.from(
        state.value?.uncategorizedTransactions ?? []);

    // Insert the new transaction at the beginning
    final existingIndex =
        currentTransactions.indexWhere((t) => t.id == updatedTransaction.id);

    // If the transaction does not exist, do nothing
    if (existingIndex == -1) {
      return;
    }

    if (updatedTransaction.subCategory == null ||
        updatedTransaction.subCategory!.id != AppConfig.uncategorizedSubCatId) {
      // * if category got is categorized now then do following
      currentTransactions.removeAt(existingIndex);
      // if sub category is uncategorized, remove the transaction

      state = AsyncValue.data(DashboardUncategorizedTransactionsState(
        uncategorizedTransactions: currentTransactions,
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
      state = AsyncValue.data(DashboardUncategorizedTransactionsState(
        uncategorizedTransactions: currentTransactions,
        meta: state.value?.meta.copyWith(
              totalCount: (state.value?.meta.totalCount ?? 0),
            ) ??
            Meta(totalCount: 1),
      ));
    }
  }

  FutureVoid removeTransaction(int id) async {
    final currentTransactions = List<UserTransaction>.from(
        state.value?.uncategorizedTransactions ?? []);

    currentTransactions.removeWhere((t) => t.id == id);

    state = AsyncValue.data(DashboardUncategorizedTransactionsState(
      uncategorizedTransactions: currentTransactions,
      meta: state.value?.meta.copyWith(
            totalCount: (state.value?.meta.totalCount ?? 0) - 1,
          ) ??
          Meta(
            totalCount: 0,
          ),
    ));
  }
}
