class LoginState {
  final String phoneNumber;
  final bool isTermsAccepted;
  final bool isLoading;

  LoginState({
    this.phoneNumber = '',
    this.isTermsAccepted = false,
    this.isLoading = false,
  });

  LoginState copyWith({
    String? phoneNumber,
    bool? isTermsAccepted,
    bool? isLoading,
  }) {
    return LoginState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
