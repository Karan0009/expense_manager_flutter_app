import 'dart:async';
import 'dart:developer';

import 'package:expense_manager/config/app_config.dart';
import 'package:expense_manager/data/models/enter_otp_state.dart';
import 'package:expense_manager/data/models/login_state.dart';
import 'package:expense_manager/data/repositories/auth_repository.dart';
import 'package:expense_manager/globals/components/glassmorphic_snackbar.dart';
import 'package:expense_manager/screens/expenses_dashboard_page/view/expenses_dashboard_page_view.dart';
import 'package:expense_manager/screens/login_page/controller/login_page_viewmodel.dart';
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

final enterOtpPageViewModelProvider =
    StateNotifierProvider<EnterOtpPageViewModel, EnterOtpState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return EnterOtpPageViewModel(
    repo,
    ref,
  );
});

class EnterOtpPageViewModel extends StateNotifier<EnterOtpState> {
  final AuthRepository _authRepository;
  Timer? _timer;
  final Ref _ref;

  EnterOtpPageViewModel(this._authRepository, this._ref)
      : super(EnterOtpState()) {
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    state = state.copyWith(
      remainingResendTime: int.parse(state.resendOtp != null
          ? state.resendOtp!.retry_after
          : _ref.read(loginPageViewModelProvider).otpInfo?.retry_after ??
              AppConfig.initialOtpResendTime.toString()),
      isResendEnabled: false,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingResendTime > 0) {
        state =
            state.copyWith(remainingResendTime: state.remainingResendTime - 1);
      } else {
        state = state.copyWith(isResendEnabled: true);
        timer.cancel();
      }
    });
  }

  void resendOtp(BuildContext context) async {
    log("Resending OTP...");
    state = state.copyWith(isLoading: true, otp: null);

    try {
      final loginState = _ref.read(loginPageViewModelProvider);
      final otp = await _authRepository.getOtp(loginState.phoneNumber, true);
      // {
      //   'phone': ,
      //   'is_terms_accepted': state.isTermsAccepted,
      //   'is_register': true,
      // }
      if (otp == null) {
        state = state.copyWith(isLoading: false);
        if (context.mounted) {
          _showSnackBar(context, 'Failed to get OTP');
        }
        return;
      }
      state = state.copyWith(
        isLoading: false,
        resendOtp: otp,
        isResendEnabled: false,
        otp: "",
        remainingResendTime: int.parse(otp.retry_after),
      );
      _startTimer(); // Restart the timer
    } catch (e) {
      state = state.copyWith(isLoading: false);
      if (context.mounted) {
        _showSnackBar(context, 'Failed to get OTP');
      }
    }
  }

  void changePhoneNumberClickHandler(BuildContext context) {
    _ref.read(loginPageViewModelProvider.notifier).resetState();
    if (context.canPop()) {
      context.pop();
    } else {
      context.pushReplacement(LoginPageView.routePath);
    }
  }

  void onOtpFilled(BuildContext context, String? pin) {
    log(pin ?? 'no pin');
    state = state.copyWith(otp: pin);
    onOtpSubmit(context);
  }

  void backToLogin(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.pushReplacement(LoginPageView.routePath);
    }
  }

  void onOtpSubmit(BuildContext context) async {
    final LoginState? loginState = _ref.read(loginPageViewModelProvider);
    if (loginState == null || loginState.otpInfo == null) {
      backToLogin(context);
    }
    if (state.isLoading) {
      return;
    }
    if (state.otp == null || state.otp?.length != 6) {
      _showSnackBar(context, 'Please enter a valid OTP');
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      final result = await _authRepository.verifyOtp(
        loginState!.phoneNumber,
        state.otp ?? "",
        state.resendOtp == null
            ? loginState.otpInfo!.code
            : state.resendOtp!.code,
      );

      state = state.copyWith(isLoading: false);

      if (context.mounted) {
        if (result) {
          _ref.read(loginPageViewModelProvider.notifier).resetState();
          context.go(ExpensesDashboardPageView.routePath);
        } else {
          _showSnackBar(context, 'Invalid OTP');
        }
      }
    } catch (e) {
      log('Error during OTP verification: $e');
      state = state.copyWith(isLoading: false);
      if (context.mounted) {
        _showSnackBar(context, 'An error occurred. Please try again later.');
      }
    }
  }

  String getResendTimeString() {
    final minutes = (state.remainingResendTime / 60).floor();
    final seconds = (state.remainingResendTime % 60).floor();
    return '${minutes < 10 ? '0$minutes' : minutes}:${seconds < 10 ? '0$seconds' : seconds}';
  }

  // Helper method to show a SnackBar
  void _showSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        GlassmorphicSnackBar(message: message),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
