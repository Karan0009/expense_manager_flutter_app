import 'package:expense_manager/data/models/otp.dart';

class LoginState {
  final String phoneNumber;
  final bool isTermsAccepted;
  final Otp? otpInfo;

  LoginState({
    this.phoneNumber = '',
    this.isTermsAccepted = false,
    this.otpInfo,
  });

  LoginState copyWith({
    String? phoneNumber,
    bool? isTermsAccepted,
    Otp? otpInfo,
  }) {
    return LoginState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
      otpInfo: otpInfo ?? this.otpInfo,
    );
  }
}
