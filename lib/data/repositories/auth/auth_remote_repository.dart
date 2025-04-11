import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:expense_manager/core/http/rest_client.dart';
import 'package:expense_manager/core/http/http_failure.dart';
import 'package:expense_manager/core/http/http_type_def.dart';
import 'package:expense_manager/data/models/otp.dart';
import 'package:expense_manager/data/models/token.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(Ref ref) {
  final restClient = ref.watch(restClientProvider);
  return AuthRemoteRepository(restClient);
}

class AuthRemoteRepository {
  final RestClient _restClient;

  AuthRemoteRepository(this._restClient);

  Future<Either<HttpFailure, Otp>> getOtp(
      String phoneNumber, bool isTermsAccepted) async {
    try {
      final endpoint = 'v1/auth/otp';
      final body = {
        "phone_number": phoneNumber,
        "are_terms_accepted": isTermsAccepted ? 'Y' : 'N'
      };
      final response = await _restClient.postRequest(
          url: endpoint, body: body, requireAuth: false);

      return response.fold((l) {
        return Left(l);
      }, (r) {
        try {
          final res = Otp.fromJson(r.data["data"] ?? {});
          return Right(res);
        } catch (e) {
          return Left(
            HttpFailure(
              message: "Failed to parse response",
              statusCode: r.statusCode ?? 500,
            ),
          );
        }
      });
    } catch (e) {
      log("Error during OTP request: $e");
      return Left(HttpFailure(
        message: "An error occurred while requesting OTP",
        statusCode: 500,
      ));
    }
  }

  FutureEither<Token> verifyOtp(
      String phoneNumber, String otp, String code) async {
    try {
      final endpoint = 'v1/auth/otp/verify';
      final body = {
        "phone_number": phoneNumber,
        "otp": otp,
        "code": code,
      };
      final response = await _restClient.postRequest(
        url: endpoint,
        body: body,
        requireAuth: false,
      );

      return response.fold((l) {
        if (l.statusCode == 401) {
          return Left(HttpFailure(
            message: "Invalid OTP",
            statusCode: l.statusCode,
          ));
        }

        return Left(l);
      }, (r) {
        try {
          final token = Token.fromMap(r.data["data"] ?? {});
          if (token.access_token != null && token.refresh_token != null) {
            return Right(token);
          }
          return Left(HttpFailure(
            message: "Failed to verify OTP",
            statusCode: r.statusCode ?? 500,
          ));
        } catch (e) {
          return Left(
            HttpFailure(
              message: "Failed to parse response",
              statusCode: r.statusCode ?? 500,
            ),
          );
        }
      });
    } catch (e) {
      log("Error during OTP verification: $e");
      return Left(HttpFailure(
        message: "An error occurred while requesting OTP",
        statusCode: 500,
      ));
    }
  }

  Future<bool> logout() async {
    try {
      // TODO: USE LOCAL STORAGE
      // final refreshToken = await _sharedPrefsRepo.getRefreshToken();

      final endpoint = 'v1/auth/logout';
      final body = {
        // "refresh_token": refreshToken,
      };
      final response = await _restClient.postRequest(
        url: endpoint,
        body: body,
        requireAuth: false,
      );

      if (response.isLeft()) {
        // await _sharedPrefsRepo.clear();
        return false;
      }
      final responseData = response.fold((_) => null, (r) => r.data);

      if (responseData != null) {
        // await _sharedPrefsRepo.clear();

        return true;
      }

      return false;
    } catch (e) {
      log("Error during logout: $e");
      // await _sharedPrefsRepo.clear();
      rethrow;
    }
  }
}
