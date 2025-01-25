import 'dart:developer';

import 'package:expense_manager/core/base/base_repository.dart';
import 'package:expense_manager/data/models/otp.dart';
import 'package:expense_manager/data/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider((ref) {
  final baseRepo = ref.watch(baseRepositoryProvider);
  return AuthRepository(baseRepository: baseRepo);
});

class AuthRepository {
  final BaseRepository _baseRepository;
  AuthRepository({required BaseRepository baseRepository})
      : _baseRepository = baseRepository;

  Future<Otp?> getOtp(Map<String, dynamic> data) async {
    try {
      await Future.delayed(Duration(seconds: 2));
      return Otp.fromJson({'id': '232323-23232'});
      // final response = await _baseRepositry.post(
      //   "/auth/otp",
      //   data: data,
      // );

      // if (response.statusCode == 200) {
      //   // User.fromJson(response.data);
      // }

      // return null;

      // if (response.statusCode == 200) {
      //   return User.fromJson(response.data);
      // }
    } catch (e) {
      log("Error during login: $e");
      rethrow;
    }
  }

  Future<User?> verifyOtp(Map<String, dynamic> data) async {
    try {
      final response = await _baseRepository.postRequest(
        url: "/auth/otp/verify",
        body: data,
        requireAuth: false,
      );

      if (response.isLeft()) {
        return null;
      }
      return null;
    } catch (e) {
      log("Error during OTP verification: $e");
      rethrow;
    }
  }
}
