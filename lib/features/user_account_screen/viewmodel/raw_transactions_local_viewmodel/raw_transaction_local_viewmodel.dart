import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:expense_manager/data/repositories/raw_transaction/raw_transaction_local_repository.dart';

part 'raw_transaction_local_viewmodel.g.dart';

@riverpod
class RawTransactionLocalViewModel extends _$RawTransactionLocalViewModel {
  final _syncingIds = <int>{};

  /// TODO: BAD PRACTICE
  /// ! Notifiers should not have public properties/getters.
  /// ! Instead, all their public API should be exposed through
  /// ! the `state` property
  Set<int> get syncingIds => _syncingIds;

  @override
  Future<List<dynamic>> build() async {
    final res = await ref.read(rawTransactionLocalRepositoryProvider).index();

    return res;
  }

  Future<void> syncTransaction(int id) async {
    _syncingIds.add(id);
    final repo = ref.read(rawTransactionLocalRepositoryProvider);
    final result = await repo.sync(id);
    result.fold(
      (l) => print("❌ Failed: ${l.message}"),
      (r) => print("✅ Synced: ${r.data}"),
    );

    _syncingIds.remove(id);
    // Re-fetch the list to refresh UI
    state = const AsyncLoading();
    state = AsyncValue.data(await repo.index());
  }

  Future<void> deleteTransaction(int id) async {
    final repo = ref.read(rawTransactionLocalRepositoryProvider);
    final result = await repo.delete(id);

    if (result != 0) {
      state = const AsyncLoading();
      state = AsyncValue.data(await repo.index());
    }
  }
}
