import 'package:expense_manager/data/models/common/meta.dart';
import 'package:expense_manager/data/models/transactions/user_transaction.dart';

class DashboardTransactionsListState {
  final List<UserTransaction> transactions;
  final int? subCategoryId;
  final Map<String, dynamic> dateRange;
  final Meta meta;

  DashboardTransactionsListState({
    required this.transactions,
    required this.dateRange,
    required this.subCategoryId,
    required this.meta,
  });
}
