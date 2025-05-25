import 'package:dartz/dartz.dart';
import 'package:expense_manager/core/http/http_failure.dart';
import 'package:expense_manager/core/http/http_type_def.dart';
import 'package:expense_manager/data/models/category/sub_category.dart';
import 'package:expense_manager/data/repositories/transaction/transaction_remote_repository.dart';
import 'package:expense_manager/features/dashboard/models/add_expense_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_expense_viewmodel.g.dart';

@riverpod
class AddExpenseViewModel extends _$AddExpenseViewModel {
  @override
  AsyncValue<AddExpenseState>? build() {
    return null;
  }

  FutureEither<AddExpenseState> create(
    String amount,
    String? recipientName,
    SubCategory? subCat,
    DateTime? transactionDatetime,
  ) async {
    double? parsedDecimalAmount = double.tryParse(amount);

    if (parsedDecimalAmount == null) {
      return Left(HttpFailure(message: 'Invalid amount provided'));
    }
    int parsedAmount = (parsedDecimalAmount * 100).toInt();

    final res = await ref.read(transactionRemoteRepositoryProvider).create(
          parsedAmount,
          recipientName: recipientName,
          subCatId: subCat?.id,
          transactionDatetime: transactionDatetime?.toIso8601String(),
        );

    return res.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(AddExpenseState(
          userTransaction: data.data,
        ));
      },
    );
  }

  FutureEither<AddExpenseState> edit(
    int id,
    String? amount,
    String? recipientName,
    SubCategory? subCat,
    DateTime? transactionDatetime,
  ) async {
    double? parsedDecimalAmount;
    int? parsedAmount;
    if (amount != null) {
      parsedDecimalAmount = double.tryParse(amount);
      if (parsedDecimalAmount != null) {
        parsedAmount = (parsedDecimalAmount * 100).toInt();
      }
    }

    final res = await ref.read(transactionRemoteRepositoryProvider).edit(
          id,
          amount: parsedAmount,
          recipientName: recipientName,
          subCatId: subCat?.id,
          transactionDatetime: transactionDatetime?.toIso8601String(),
        );

    return res.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(AddExpenseState(
          userTransaction: data.data,
        ));
      },
    );
  }

  FutureEither<void> delete(
    int id,
  ) async {
    final res = await ref.read(transactionRemoteRepositoryProvider).delete(id);

    return res.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }
}
