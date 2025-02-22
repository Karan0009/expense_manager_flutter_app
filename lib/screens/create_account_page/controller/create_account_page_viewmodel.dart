import 'package:expense_manager/data/models/login_state.dart';
import 'package:expense_manager/data/repositories/auth_repository.dart';
import 'package:expense_manager/globals/components/glassmorphic_snackbar.dart';
import 'package:expense_manager/screens/enter_otp_page/view/enter_otp_page_view.dart';
import 'package:expense_manager/screens/login_page/view/login_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final createAccountPageViewModelProvider =
    StateNotifierProvider<CreateAccountPageViewModel, LoginState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return CreateAccountPageViewModel(repo);
});

class CreateAccountPageViewModel extends StateNotifier<LoginState> {
  final AuthRepository _authRepository;

  CreateAccountPageViewModel(this._authRepository) : super(LoginState());

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

  Future<void> onCreateAccountClicked(BuildContext context) async {
    if (!state.isTermsAccepted) {
      _showSnackBar(context, 'Please accept Terms & Conditions');
      return;
    }

    final validationError = validatePhoneNumber(state.phoneNumber);
    if (validationError != null) {
      _showSnackBar(context, validationError);
      return;
    }

    state = state.copyWith(isLoading: true);
    try {
      final otp = await _authRepository.getOtp(
          state.phoneNumber, state.isTermsAccepted);
      // {
      //   'phone': ,
      //   'is_terms_accepted': state.isTermsAccepted,
      //   'is_register': true,
      // }
      state = state.copyWith(otpInfo: otp);

      state = state.copyWith(isLoading: false);
      if (otp != null && context.mounted) {
        context.go(EnterOtpPageView.routePath);
        // context.goNamed(AppRoutes.loginOtpPage);
      } else if (otp == null && context.mounted) {
        _showSnackBar(context, 'Failed to get OTP');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      if (context.mounted) {
        _showSnackBar(context, 'Failed to get OTP');
      }
    }
  }

  // Login Button Click Handler
  void onLoginClicked(BuildContext context) {
    context.pushReplacement(LoginPageView.routePath);
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
