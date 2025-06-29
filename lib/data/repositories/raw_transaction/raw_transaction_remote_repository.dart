import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:expense_manager/config/app_config.dart';
import 'package:expense_manager/core/http/http_failure.dart';
import 'package:expense_manager/core/http/http_type_def.dart';
import 'package:expense_manager/core/http/rest_client.dart';
import 'package:expense_manager/data/models/common/api_response.dart';
import 'package:expense_manager/data/models/transactions/raw_transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'raw_transaction_remote_repository.g.dart';

@riverpod
RawTransactionRemoteRepository rawTransactionRemoteRepository(Ref ref) {
  final restClient = ref.watch(restClientProvider);
  return RawTransactionRemoteRepository(restClient: restClient);
}

class RawTransactionRemoteRepository {
  final RestClient _restClient;

  RawTransactionRemoteRepository({required RestClient restClient})
      : _restClient = restClient;

  FutureEither<ApiResponse<RawTransaction, RawTransaction>> create({
    required String type,
    required dynamic data,
  }) async {
    try {
      final endpoint = 'v1/raw-transaction';

      Map<String, dynamic> params = {
        'type': type,
      };

      if (type == AppConfig.rawTransactionTypeWAText) {
        params['data'] = data.toString();
      } else if (type == AppConfig.rawTransactionTypeWAImage) {
        final file = File(data);
        final exists = await file.exists();
        if (!exists) {
          return Left(
            HttpFailure(
              message: "File does not exist at the provided path",
              statusCode: 400,
            ),
          );
        }
        params['image'] = await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last.toLowerCase(),
        );
      }

      FormData formData = FormData.fromMap(params);

      final response = await _restClient.postRequest(
        url: endpoint,
        requireAuth: true,
        body: formData,
        formData: true,
      );

      return response.fold(
        (l) {
          return Left(l);
        },
        (r) {
          try {
            if (r.statusCode != 201 && r.data["data"] != null) {
              return Left(
                HttpFailure(
                  message: r.data["meta"]["message"] ?? "Failed to create data",
                  statusCode: r.statusCode ?? 500,
                ),
              );
            }

            final val = ApiResponse<RawTransaction, RawTransaction>.fromMap(
              r.data,
              RawTransaction.fromMap,
              isDataList: false,
            );

            return Right(val);
          } catch (e) {
            return Left(
              HttpFailure(
                message: "Failed to parse response",
                statusCode: r.statusCode ?? 500,
              ),
            );
          }
        },
      );
    } catch (e) {
      return Left(HttpFailure(message: "Unexpected error occurred"));
    }
  }
}
