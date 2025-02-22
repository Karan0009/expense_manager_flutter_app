import 'package:expense_manager/data/models/otp.dart';

class LoginState {
  final String phoneNumber;
  final bool isTermsAccepted;
  final bool isLoading;
  final Otp? otpInfo;

  LoginState({
    this.phoneNumber = '',
    this.isTermsAccepted = false,
    this.isLoading = false,
    this.otpInfo,
  });

  LoginState copyWith({
    String? phoneNumber,
    bool? isTermsAccepted,
    bool? isLoading,
    Otp? otpInfo,
  }) {
    return LoginState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
      isLoading: isLoading ?? this.isLoading,
      otpInfo: otpInfo ?? this.otpInfo,
    );
  }
}
