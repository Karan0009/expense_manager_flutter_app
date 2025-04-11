import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:expense_manager/core/app_failure.dart';
import 'package:expense_manager/core/app_failure_type_def.dart';
import 'package:expense_manager/data/models/token.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_local_repository.g.dart';

@riverpod
AuthLocalRepository authLocalRepository(Ref ref) {
  return AuthLocalRepository();
}

class AuthLocalRepository {
  final String _accessTokenKey = "x-auth-access-token";
  final String _refreshTokenKey = "x-auth-refresh-token";

  AuthLocalRepository();

  // FutureAppFailureEitherVoid init() async {
  //   try {
  //     _prefs = await SharedPreferences.getInstance();
  //     return Right(null);
  //   } catch (e) {
  //     log("Error initializing SharedPreferences: $e");
  //     return Left(AppFailure(message: "Error initializing SharedPreferences"));
  //   }
  // }

  FutureAppFailureEither<bool> setAccessToken(String? token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (token == null) {
        return Left(AppFailure(message: "Token cannot be null"));
      }
      await prefs.setString(_accessTokenKey, token);
      return Right(true);
    } catch (e) {
      return Left(AppFailure(
        message: "Error setting access token",
        stackTrace: StackTrace.current,
      ));
    }
  }

  FutureAppFailureEither<String> getAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedAccessToken = prefs.getString(_accessTokenKey);
      if (savedAccessToken == null || savedAccessToken.isEmpty) {
        log("No access token found");
        return Left(AppFailure(message: "No access token found"));
      }
      return Right(savedAccessToken);
    } catch (e) {
      return Left(AppFailure(
        message: "Error getting access token",
        stackTrace: StackTrace.current,
      ));
    }
  }

  FutureAppFailureEitherVoid clearAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove(_accessTokenKey);
      return Right(null);
    } catch (e) {
      return Left(AppFailure(
        message: "Error clearing access token",
        stackTrace: StackTrace.current,
      ));
    }
  }

  FutureAppFailureEither<bool> setRefreshToken(String? token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (token == null) {
        return Left(AppFailure(message: "Token cannot be null"));
      }
      await prefs.setString(_refreshTokenKey, token);
      return Right(true);
    } catch (e) {
      return Left(AppFailure(
        message: "Error setting refresh token",
        stackTrace: StackTrace.current,
      ));
    }
  }

  FutureAppFailureEither<String> getRefreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedRefreshToken = prefs.getString(_refreshTokenKey);
      if (savedRefreshToken == null || savedRefreshToken.isEmpty) {
        log("No refresh token found");
        return Left(AppFailure(message: "No refresh token found"));
      }
      return Right(savedRefreshToken);
    } catch (e) {
      return Left(AppFailure(
        message: "Error getting refresh token",
        stackTrace: StackTrace.current,
      ));
    }
  }

  FutureAppFailureEither<Token> getAccessAndRefreshTokens() async {
    final savedRefreshToken = await getRefreshToken();
    final savedAccessToken = await getAccessToken();

    if (savedRefreshToken.isLeft() || savedAccessToken.isLeft()) {
      return Left(AppFailure(message: "No tokens found"));
    }

    return Right(
      Token(
        access_token: savedAccessToken.getOrElse(() => ""),
        refresh_token: savedRefreshToken.getOrElse(() => ""),
      ),
    );
  }

  FutureAppFailureEitherVoid clearRefreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_refreshTokenKey);
      return Right(null);
    } catch (e) {
      return Left(AppFailure(
        message: "Error clearing refresh token",
        stackTrace: StackTrace.current,
      ));
    }
  }

  FutureAppFailureEitherVoid clearAllTokens() async {
    await clearAccessToken();
    await clearRefreshToken();
    return Right(null);
  }
}
