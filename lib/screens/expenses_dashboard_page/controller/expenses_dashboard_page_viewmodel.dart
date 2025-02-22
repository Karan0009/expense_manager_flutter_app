import 'package:expense_manager/data/models/expenses_dashboard_state.dart';
import 'package:expense_manager/globals/components/glassmorphic_snackbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// You need to override the dispose method if your StateNotifier or other providers
/// manage resources like:
///     Streams
///     Timers
///     Listeners (e.g., EventListeners or ValueNotifiers)
///     Controllers (e.g., TextEditingController, ScrollController)

final expensesDashboardPageViewModelProvider = StateNotifierProvider<
    ExpensesDashboardPageViewModel, ExpensesDashboardState>((ref) {
  // final repo = ref.watch(authRepositoryProvider);
  return ExpensesDashboardPageViewModel();
});

class ExpensesDashboardPageViewModel
    extends StateNotifier<ExpensesDashboardState> {
  ExpensesDashboardPageViewModel() : super(ExpensesDashboardState());

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
