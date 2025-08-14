import 'package:expense_manager/data/models/transactions/user_transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to manage pagination loading state for uncategorized transactions list
/// This provider helps to isolate the loading state from parent widget rebuilds
final paginationLoadingProvider = StateProvider<bool>((ref) => false);

/// Provider to manage the transaction details callback function
/// This helps to pass the callback function without causing widget rebuilds
final transactionDetailsCallbackProvider =
    Provider<Future<Map<String, dynamic>?> Function(String, UserTransaction?)?>(
        (ref) => null);
final showAddExpenseBottomSheetHandlerProvider =
    Provider<Future<UserTransaction?> Function(String buttonLabel)?>(
        (ref) => null);
