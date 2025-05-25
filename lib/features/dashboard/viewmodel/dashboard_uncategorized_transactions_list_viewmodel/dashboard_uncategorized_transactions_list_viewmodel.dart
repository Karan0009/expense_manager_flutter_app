import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:expense_manager/config/app_config.dart';
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
    final data = await loadTransctions(state.value?.meta.nextPageNumber ?? 1);
    return data.fold(
      (error) {
        log(error.message);
        throw Exception(error.message);
        // return Left(
        //     AppFailure(message: error.message, stackTrace: StackTrace.current));
      },
      (data) {
        log(data.toString());
        return data;
      },
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

    if (existingIndex != -1) {
      currentTransactions[existingIndex] = updatedTransaction;
// Create a new state with updated transactions and metadata
      state = AsyncValue.data(DashboardUncategorizedTransactionsState(
        uncategorizedTransactions: currentTransactions,
        meta: state.value?.meta.copyWith(
              totalCount: (state.value?.meta.totalCount ?? 0) + 1,
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
