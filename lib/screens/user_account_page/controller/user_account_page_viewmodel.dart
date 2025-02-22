import 'package:expense_manager/data/models/user.dart';
import 'package:expense_manager/data/models/user_account_page_state.dart';
import 'package:expense_manager/data/repositories/auth_repository.dart';
import 'package:expense_manager/globals/components/glassmorphic_snackbar.dart';
import 'package:expense_manager/globals/providers/common_providers.dart';
import 'package:expense_manager/screens/login_page/view/login_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// You need to override the dispose method if your StateNotifier or other providers
/// manage resources like:
///     Streams
///     Timers
///     Listeners (e.g., EventListeners or ValueNotifiers)
///     Controllers (e.g., TextEditingController, ScrollController)

final userAccountPageViewModelProvider =
    StateNotifierProvider<UserAccountPageViewmodel, UserAccountPageState>(
        (ref) {
  final repo = ref.watch(authRepositoryProvider);
  final currentUserRepo = ref.watch(currentUserProvider);
  return UserAccountPageViewmodel(repo, currentUserRepo);
});

class UserAccountPageViewmodel extends StateNotifier<UserAccountPageState> {
  final AuthRepository _authRepository;
  final User? currentUser;

  UserAccountPageViewmodel(this._authRepository, this.currentUser)
      : super(UserAccountPageState()) {
    state = state.copyWith(userInfo: currentUser);
  }

  void logoutButtonOnClick(BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true);
      final result = await _authRepository.logout();

      state = state.copyWith(isLoading: false);

      if (result && context.mounted) {
        context.go(LoginPageView.routePath);
      } else {
        if (context.mounted) {
          _showSnackBar(context, 'Logout failed. Please try again.');
        }
      }
    } catch (error) {
      if (context.mounted) _showSnackBar(context, 'Some error occured');
    }
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
