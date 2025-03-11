import 'dart:developer';

import 'package:expense_manager/config/app_config.dart';
import 'package:expense_manager/data/models/expenses_dashboard_state.dart';
import 'package:expense_manager/data/providers/transactions_provider.dart';
import 'package:expense_manager/data/repositories/transaction_repository.dart';
import 'package:expense_manager/globals/components/glassmorphic_snackbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// You need to override the dispose method if your StateNotifier or other providers
/// manage resources like:
///     Streams
///     Timers
///     Listeners (e.g., EventListeners or ValueNotifiers)
///     Controllers (e.g., TextEditingController, ScrollController)

final expensesDashboardPageViewModelProvider = StateNotifierProvider<
    ExpensesDashboardPageViewModel, ExpensesDashboardState>((ref) {
  final repo = ref.watch(transactionRepositoryProvider);
  return ExpensesDashboardPageViewModel(repo);
});

class ExpensesDashboardPageViewModel
    extends StateNotifier<ExpensesDashboardState> {
  final TransactionRepository _transactionRepository;
  ExpensesDashboardPageViewModel(this._transactionRepository)
      : super(ExpensesDashboardState(expenses: [
          {
            "amount": 12345,
            "transaction_datetime": DateTime.now().toIso8601String(),
            "recipient_name": "Grocery Shopping",
            "category_id": null,
            "user_id": "12342-asdf"
          }
        ]));

  Future<void> getCurrentMonthSummarizedTransactions(
      BuildContext context) async {
    state = state.copyWith(isLoading: true);
    try {
      final data = _transactionRepository.getSummarizedTransactions(
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
          AppConfig.summaryTypeDaily);

      log(data.toString());
    } catch (e) {
      state = state.copyWith(isLoading: false);
      if (context.mounted) {
        _showSnackBar(context, 'Failed to get OTP');
      }
    }
  }

  // Helper method to show a SnackBar
  void _showSnackBar(BuildContext context, String message) {
    // if (context.mounted) {
    //   final overlay = Overlay.of(context);
    //   final overlayEntry = OverlayEntry(
    //     builder: (context) => GlassmorphicSnackBar(message: message),
    //   );
    //   overlay.insert(overlayEntry);
    //   Future.delayed(const Duration(seconds: 3), () => overlayEntry.remove());
    // }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        GlassmorphicSnackBar(message: message),
      );
    }
  }

  void resetState() {
    state = ExpensesDashboardState();
  }
}
