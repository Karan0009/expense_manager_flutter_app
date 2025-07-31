import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:expense_manager/core/app_failure.dart';
import 'package:expense_manager/core/app_failure_type_def.dart';
import 'package:expense_manager/data/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_local_repository.g.dart';

@riverpod
UserLocalRepository userLocalRepository(Ref ref) {
  return UserLocalRepository();
}

class UserLocalRepository {
  final String _userDetailsKey = "USER_DETAILS";
  UserLocalRepository();

  FutureAppFailureEither<bool> setUserDetails(User? user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (user == null) {
        return Left(AppFailure(message: "Token cannot be null"));
      }
      await prefs.setString(_userDetailsKey, jsonEncode(user.toJson()));

      return Right(true);
    } catch (e) {
      return Left(AppFailure(
        message: "Error setting user details",
        stackTrace: StackTrace.current,
      ));
    }
  }

  FutureAppFailureEither<User> getUserDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUserDetails = prefs.getString(_userDetailsKey);
      if (savedUserDetails == null || savedUserDetails.isEmpty) {
        log("No access token found");
        return Left(AppFailure(message: "No access token found"));
      }

      return Right(User.fromJson(jsonDecode(savedUserDetails)));
    } catch (e) {
      return Left(AppFailure(
        message: "Error getting user details",
        stackTrace: StackTrace.current,
      ));
    }
  }
}
