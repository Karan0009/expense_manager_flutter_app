import 'package:dartz/dartz.dart';
import 'package:expense_manager/core/http/http_type_def.dart';
import 'package:expense_manager/data/models/transactions/raw_transaction.dart';
import 'package:expense_manager/data/repositories/raw_transaction/raw_transaction_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shared_raw_transaction_viewmodel.g.dart';

@riverpod
class SharedRawTransactionViewModel extends _$SharedRawTransactionViewModel {
  late RawTransactionRemoteRepository _rawTransactionRemoteRepository;

  @override
  AsyncValue<RawTransaction>? build() {
    _rawTransactionRemoteRepository =
        ref.watch(rawTransactionRemoteRepositoryProvider);

    return null;
  }

  FutureEither<AsyncValue<RawTransaction>?> createRawUserTransaction({
    required String type,
    required dynamic data,
  }) async {
    state = const AsyncValue.loading();

    final response =
        await _rawTransactionRemoteRepository.create(type: type, data: data);

    return response.fold(
      (error) {
        state = AsyncValue.error(error, StackTrace.current);

        return Left(error);
      },
      (apiResponse) {
        state = AsyncValue.data(apiResponse.data);

        return Right(AsyncValue.data(apiResponse.data));
      },
    );
  }
}
