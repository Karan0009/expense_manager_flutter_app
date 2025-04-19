import 'package:expense_manager/data/models/common/meta.dart';
import 'package:expense_manager/data/models/transactions/user_transaction.dart';

class DashboardUncategorizedTransactionsState {
  final List<UserTransaction> uncategorizedTransactions;
  final Meta meta;

  DashboardUncategorizedTransactionsState({
    required this.uncategorizedTransactions,
    required this.meta,
  });
}
