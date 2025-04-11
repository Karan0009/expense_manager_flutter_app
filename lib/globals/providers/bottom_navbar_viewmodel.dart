// ignore_for_file: unused_element, unused_field

import 'package:expense_manager/data/models/bottom_navbar_state.dart';
// import 'package:expense_manager/data/repositories/auth_repository.dart';
import 'package:expense_manager/globals/components/glassmorphic_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// You need to override the dispose method if your StateNotifier or other providers
/// manage resources like:
///     Streams
///     Timers
///     Listeners (e.g., EventListeners or ValueNotifiers)
///     Controllers (e.g., TextEditingController, ScrollController)

final bottomNavbarViewModelProvider =
    StateNotifierProvider<BottomNavbarViewModel, BottomNavbarState>((ref) {
  // final repo = ref.watch(authRepositoryProvider);
  return BottomNavbarViewModel(
    ref,
  );
});

class BottomNavbarViewModel extends StateNotifier<BottomNavbarState> {
  // final AuthRepository _authRepository;
  final Ref _ref;
  BottomNavbarViewModel(this._ref) : super(BottomNavbarState());

  void changeBottomNavbarIndex(int newIndex) {
    state = state.copyWith(curIndex: newIndex);
  }

  // Helper method to show a SnackBar
  void _showSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        GlassmorphicSnackBar(message: message),
      );
    }
  }
}
