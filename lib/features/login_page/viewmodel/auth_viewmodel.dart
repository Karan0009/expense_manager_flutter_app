import 'package:dartz/dartz.dart';
import 'package:expense_manager/core/app_failure_type_def.dart';
import 'package:expense_manager/core/http/http_failure.dart';
import 'package:expense_manager/core/http/http_type_def.dart';
import 'package:expense_manager/data/models/login_state.dart';
import 'package:expense_manager/data/models/otp.dart';
import 'package:expense_manager/data/models/token.dart';
import 'package:expense_manager/data/repositories/auth/auth_local_repository.dart';
import 'package:expense_manager/data/repositories/auth/auth_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  @override
  AsyncValue<LoginState>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);

    return AsyncValue.data(LoginState(
      isTermsAccepted: false,
      otpInfo: null,
      phoneNumber: "",
    ));
  }

  Future<Either<HttpFailure, Otp>> getOtp(
      String phoneNumber, bool isTermsAndConditionsAccepted) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.getOtp(
        phoneNumber, isTermsAndConditionsAccepted);

    final val = res.fold(
      (error) {
        state = AsyncValue.error(
          error.message,
          StackTrace.current,
        );
        return error.toString();
      },
      (otpInfo) {
        state = AsyncValue.data(LoginState(
          isTermsAccepted: isTermsAndConditionsAccepted,
          otpInfo: otpInfo,
          phoneNumber: phoneNumber,
        ));
        return otpInfo.toString();
      },
    );

    print(val);
    return res;
  }

  Future<Either<HttpFailure, Otp>> resendOtp(String phoneNumber) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.getOtp(phoneNumber, true);

    final val = res.fold(
      (error) {
        return error.toString();
      },
      (otpInfo) => state = state?.value == null
          ? AsyncValue.data(LoginState(
              isTermsAccepted: true,
              otpInfo: otpInfo,
              phoneNumber: phoneNumber,
            ))
          : AsyncData(state!.value!.copyWith(
              otpInfo: otpInfo,
              phoneNumber: phoneNumber,
              isTermsAccepted: true,
            )),
      // AsyncValue.data(LoginState(
      //   isTermsAccepted: true,
      //   otpInfo: otpInfo,
      //   phoneNumber: phoneNumber,
      // ))
      // return otpInfo.toString();
    );

    print(val);
    return res;
  }

  Future<Either<HttpFailure, Token?>> verifyOtp(
    String phoneNumber,
    String otp,
    String code,
  ) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.verifyOtp(
      phoneNumber,
      otp,
      code,
    );

    final val = res.fold(
      (error) {
        state = AsyncValue.error(
          error.message,
          StackTrace.current,
        );
        return error.toString();
      },
      (token) async {
        await saveAccessToken(token.access_token);
        await saveRefreshToken(token.refresh_token);

        return token;
      },
    );

    print(val);
    return res;
  }

  FutureAppFailureEither<bool> saveAccessToken(String? accessToken) async {
    final setAccessTokenRes =
        await _authLocalRepository.setAccessToken(accessToken);

    return setAccessTokenRes.fold(
      (error) {
        return Left(error);
      },
      (isSaved) {
        return Right(isSaved);
      },
    );
  }

  FutureAppFailureEither<bool> saveRefreshToken(String? refreshToken) async {
    final setRefreshTokenRes =
        await _authLocalRepository.setRefreshToken(refreshToken);

    return setRefreshTokenRes.fold(
      (error) {
        return Left(error);
      },
      (isSaved) {
        return Right(isSaved);
      },
    );
  }

  String? validateAuthForm(
    String? phoneNumber,
    bool isTermsAndConditionsAccepted,
  ) {
    if (phoneNumber == null || phoneNumber.trim().isEmpty) {
      return "Phone number cannot be empty";
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(phoneNumber)) {
      return "Phone number must contain only digits";
    }

    if (phoneNumber.length != 10) {
      return "Phone number must be exactly 10 digits long";
    }

    if (!isTermsAndConditionsAccepted) {
      return "You must accept the Terms and Conditions";
    }

    return null;
  }

  Future<bool> logout(String logoutType) async {
    try {
      final result = await _authRemoteRepository.logout(logoutType);
      if (result) {
        offlineLogout();
      }
      return result;
    } catch (e) {
      return false;
    }
  }

  FutureVoid offlineLogout() async {
    await _authLocalRepository.clearAccessToken();
    await _authLocalRepository.clearRefreshToken();
  }
}
