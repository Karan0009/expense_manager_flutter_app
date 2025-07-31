import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:expense_manager/core/http/http_failure.dart';
import 'package:expense_manager/core/http/rest_client.dart';
import 'package:expense_manager/data/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_remote_repository.g.dart';

@riverpod
UserRemoteRepository userRemoteRepository(Ref ref) {
  final restClient = ref.watch(restClientProvider);
  return UserRemoteRepository(restClient);
}

class UserRemoteRepository {
  final RestClient _restClient;

  UserRemoteRepository(this._restClient);

  Future<Either<HttpFailure, User>> getUserDetails() async {
    try {
      final endpoint = 'v1/user/details';
      final response = await _restClient.getRequest(
        url: endpoint,
        requireAuth: true,
      );

      return response.fold((l) {
        return Left(l);
      }, (r) {
        try {
          final res = User.fromMap(r.data["data"] ?? {});

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
}
