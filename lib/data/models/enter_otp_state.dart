import 'package:expense_manager/data/models/otp.dart';

class EnterOtpState {
  final String? otp;
  final bool isLoading;
  final bool isResendEnabled;
  final int remainingResendTime;
  final Otp? resendOtp;

  EnterOtpState({
    this.otp,
    this.isLoading = false,
    this.isResendEnabled = false,
    this.remainingResendTime = 0,
    this.resendOtp,
  });

  EnterOtpState copyWith(
      {String? otp,
      bool? isLoading,
      bool? isResendEnabled,
      int? remainingResendTime,
      Otp? resendOtp}) {
    return EnterOtpState(
      otp: otp ?? this.otp,
      isLoading: isLoading ?? this.isLoading,
      isResendEnabled: isResendEnabled ?? this.isResendEnabled,
      remainingResendTime: remainingResendTime ?? this.remainingResendTime,
      resendOtp: resendOtp ?? this.resendOtp,
    );
  }
}
