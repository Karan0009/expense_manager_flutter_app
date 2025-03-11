import 'package:expense_manager/core/base/base_repository.dart';
import 'package:expense_manager/data/repositories/shared_prefs_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_manager/data/repositories/transaction_repository.dart';

final transactionRepositoryProvider = Provider((ref) {
  final baseRepo = ref.watch(baseRepositoryProvider);
  final sharedPrefsRepo = ref.read(sharedPrefsRepoProvider);

  return TransactionRepository(
      baseRepository: baseRepo, sharedPrefsRepo: sharedPrefsRepo);
});

// FutureProvider for fetching transactions
final summarizedTransactionsProvider =
    FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) async {
  final repository = ref.watch(transactionRepositoryProvider);
  return await repository.getSummarizedTransactions(
      params["onDate"]!, params["summaryType"]);
});
