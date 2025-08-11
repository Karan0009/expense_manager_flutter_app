import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:expense_manager/config/app_config.dart';
import 'package:expense_manager/core/app_failure.dart';
import 'package:expense_manager/core/app_failure_type_def.dart';
import 'package:expense_manager/core/helpers/local_db_service.dart';
import 'package:expense_manager/core/http/http_failure.dart';
import 'package:expense_manager/core/http/http_type_def.dart';
import 'package:expense_manager/core/http/rest_client.dart';
import 'package:expense_manager/data/models/common/api_response.dart';
import 'package:expense_manager/data/models/transactions/raw_transaction.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'raw_transaction_local_repository.g.dart';

@riverpod
RawTransactionLocalRepository rawTransactionLocalRepository(Ref ref) {
  final restClient = ref.watch(restClientProvider);
  return RawTransactionLocalRepository(restClient: restClient);
}

class RawTransactionLocalRepository {
  final RestClient _restClient;
  final LocalDbService _dbService = LocalDbService();

  RawTransactionLocalRepository({required RestClient restClient})
      : _restClient = restClient;

  FutureAppFailureEitherVoid create({
    required String type,
    required dynamic data,
  }) async {
    try {
      Map<String, dynamic> params = {
        'type': type,
      };

      if (type == AppConfig.rawTransactionTypeWAText ||
          type == AppConfig.rawTransactionTypeSMS) {
        params['data'] = data.toString();
      } else if (type == AppConfig.rawTransactionTypeWAImage) {
        final file = File(data);
        final exists = await file.exists();
        if (!exists) {
          return Left(
            AppFailure(
              message: "File does not exist at the provided path",
              stackTrace: StackTrace.current,
            ),
          );
        }
        params['image'] = await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last.toLowerCase(),
        );
      }

      await _dbService.insert(AppConfig.rawTransactionsLocalTable, {
        'data': jsonEncode(params),
        'status': 'PENDING',
      });

      return Right(null);
    } catch (e) {
      return Left(AppFailure(message: "Unexpected error occurred"));
    }
  }

  Future<List<dynamic>> index() async {
    try {
      final rawTransactions = await _dbService.queryAll(
        AppConfig.rawTransactionsLocalTable,
        where: 'status = ?',
        whereArgs: ['PENDING'],
        orderBy: 'created_at DESC',
      );

      if (rawTransactions.isEmpty) {
        return [];
      }

      return rawTransactions;
    } catch (e) {
      return [];
    }
  }

  Future<int> delete(int id) async {
    try {
      final res =
          await _dbService.delete(AppConfig.rawTransactionsLocalTable, id);

      return res;
    } catch (e) {
      return 0;
    }
  }

  // TODO: IMPROVE THIS METHOD
  FutureEither<ApiResponse<RawTransaction, RawTransaction>> sync(int id) async {
    try {
      final rawTransaction =
          await _dbService.queryById(AppConfig.rawTransactionsLocalTable, id);

      if (rawTransaction == null) {
        return Left(
          HttpFailure(
            message: "Raw transaction not found",
            statusCode: 404,
          ),
        );
      }

      final data = jsonDecode(rawTransaction['data']) as Map<String, dynamic>;

      FormData formData = FormData.fromMap(data);

      final endpoint = 'v1/raw-transaction';

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
        (r) async {
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

            // Update status asynchronously without blocking
            _updateTransactionStatus(id).catchError((e) {
              debugPrint('Failed to update transaction status: $e');
            });

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
      return Left(
        HttpFailure(
          message: "Unexpected error occurred",
          statusCode: 500,
        ),
      );
    }
  }

  // Helper method to update transaction status without blocking
  Future<void> _updateTransactionStatus(int id) async {
    await _dbService.update(
      AppConfig.rawTransactionsLocalTable,
      {'status': 'SYNCED'},
      id,
    );
  }
}
