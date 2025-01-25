import 'package:expense_manager/data/models/login_state.dart';
import 'package:expense_manager/data/repositories/auth_repository.dart';
import 'package:expense_manager/globals/components/glassmorphic_snackbar.dart';
import 'package:expense_manager/screens/create_account_page/view/create_account_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// You need to override the dispose method if your StateNotifier or other providers
/// manage resources like:
///     Streams
///     Timers
///     Listeners (e.g., EventListeners or ValueNotifiers)
///     Controllers (e.g., TextEditingController, ScrollController)

final enterOtpPageViewModelProvider =
    StateNotifierProvider<EnterOtpPageViewModel, LoginState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return EnterOtpPageViewModel(repo);
});

class EnterOtpPageViewModel extends StateNotifier<LoginState> {
  final AuthRepository _authRepository;

  EnterOtpPageViewModel(this._authRepository) : super(LoginState());

  void onPhoneNumberChanged(String value) {
    state = state.copyWith(phoneNumber: value);
  }

  void onCheckboxChanged(bool? value) {
    if (value != null) {
      state = state.copyWith(isTermsAccepted: value);
    }
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length != 10) {
      return 'Phone number must be 10 digits';
    }
    return null;
  }

  void onCreateAccountClicked(BuildContext context) {
    context.pushReplacement(CreateAccountPageView.routePath);
  }

  // Login Button Click Handler
  void onLoginClicked(BuildContext context) async {
    final validationError = validatePhoneNumber(state.phoneNumber);
    if (validationError != null) {
      _showSnackBar(context, validationError);
      return;
    }
    if (!state.isTermsAccepted) {
      _showSnackBar(context, 'Please accept Terms & Conditions');
      return;
    }

    state = state.copyWith(isLoading: true);

    final otp = await _authRepository.getOtp({
      'phone': state.phoneNumber,
      'is_terms_accepted': state.isTermsAccepted,
      'is_register': true,
    });

    state = state.copyWith(isLoading: true);

    if (otp != null && context.mounted) {
      // context.goNamed(AppRoutes.loginOtpPage);
    } else if (otp == null && context.mounted) {
      _showSnackBar(context, 'Failed to get OTP');
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
}
