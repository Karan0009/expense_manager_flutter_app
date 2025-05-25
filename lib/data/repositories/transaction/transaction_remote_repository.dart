import 'package:dartz/dartz.dart';
import 'package:expense_manager/core/http/rest_client.dart';
import 'package:expense_manager/core/http/http_failure.dart';
import 'package:expense_manager/core/http/http_type_def.dart';
import 'package:expense_manager/data/models/common/api_response.dart';
import 'package:expense_manager/data/models/transactions/user_transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_remote_repository.g.dart';

@riverpod
TransactionRemoteRepository transactionRemoteRepository(Ref ref) {
  final restClient = ref.watch(restClientProvider);
  return TransactionRemoteRepository(restClient: restClient);
}

class TransactionRemoteRepository {
  final RestClient _restClient;

  TransactionRemoteRepository({required RestClient restClient})
      : _restClient = restClient;

  FutureEither<ApiResponse<List<UserTransaction>, UserTransaction>>
      getTransactions({
    String? fromDate,
    String? toDate,
    int? subCatId,
    String? sortBy = 'transaction_datetime',
    required String orderBy,
    required int limit,
    required int page,
  }) async {
    try {
      final endpoint = 'v1/transaction';
      Map<String, dynamic> params = {
        "sort_by": sortBy,
        "order_by": orderBy,
        "limit": limit,
        "page": page,
      };

      if (fromDate != null && toDate != null) {
        params["from_date"] = fromDate;
        params["to_date"] = toDate;
      }

      if (subCatId != null) {
        params["sub_cat_id"] = subCatId;
      }

      final response = await _restClient.getRequest(
        url: endpoint,
        requireAuth: true,
        queryParameters: params,
      );

      return response.fold(
        (l) {
          return Left(l);
        },
        (r) {
          try {
            if (r.statusCode != 200 && r.data["data"] != null) {
              return Left(
                HttpFailure(
                  message: r.data["meta"]["message"] ?? "Failed to fetch data",
                  statusCode: r.statusCode ?? 500,
                ),
              );
            }

            final val =
                ApiResponse<List<UserTransaction>, UserTransaction>.fromMap(
              r.data,
              UserTransaction.fromMap,
              isDataList: true,
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

  FutureEither<ApiResponse<UserTransaction, UserTransaction>> create(
    int amount, {
    String? recipientName,
    String? transactionDatetime,
    int? subCatId,
  }) async {
    try {
      final endpoint = 'v1/transaction';

      Map<String, dynamic> params = {
        "amount": amount,
      };

      if (recipientName != null) {
        params["recipient_name"] = recipientName;
      }
      if (transactionDatetime != null) {
        params["transaction_datetime"] = transactionDatetime;
      }
      if (subCatId != null) {
        params["sub_cat_id"] = subCatId;
      }

      final response = await _restClient.postRequest(
        url: endpoint,
        requireAuth: true,
        body: params,
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

            final val = ApiResponse<UserTransaction, UserTransaction>.fromMap(
              r.data,
              UserTransaction.fromMap,
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

  FutureEither<ApiResponse<UserTransaction, UserTransaction>> edit(
    int id, {
    int? amount,
    String? recipientName,
    String? transactionDatetime,
    int? subCatId,
  }) async {
    try {
      final endpoint = 'v1/transaction/$id';

      Map<String, dynamic> params = {};

      if (amount != null) {
        params["amount"] = amount;
      }

      if (recipientName != null) {
        params["recipient_name"] = recipientName;
      }
      if (transactionDatetime != null) {
        params["transaction_datetime"] = transactionDatetime;
      }
      if (subCatId != null) {
        params["sub_cat_id"] = subCatId;
      }

      if (params.isEmpty) {
        return Left(HttpFailure(message: 'empty params'));
      }

      final response = await _restClient.putRequest(
        url: endpoint,
        requireAuth: true,
        body: params,
      );

      return response.fold(
        (l) {
          return Left(l);
        },
        (r) {
          try {
            if (r.statusCode != 200 || r.data["data"] == null) {
              return Left(
                HttpFailure(
                  message: r.data["meta"]["message"] ?? "Failed to edit data",
                  statusCode: r.statusCode ?? 500,
                ),
              );
            }

            final modifiedData = r.data;
            modifiedData['data']['amount'] =
                (modifiedData['data']['amount'] as int).toString();

            final val = ApiResponse<UserTransaction, UserTransaction>.fromMap(
              modifiedData,
              UserTransaction.fromMap,
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

  FutureEither<void> delete(int id) async {
    try {
      final endpoint = 'v1/transaction/$id';

      final response = await _restClient.deleteRequest(
        url: endpoint,
        requireAuth: true,
      );

      return response.fold(
        (l) {
          return Left(l);
        },
        (r) {
          try {
            if (r.statusCode != 200 || r.data["data"] == null) {
              return Left(
                HttpFailure(
                  message: r.data["meta"]["message"] ?? "Failed to delete data",
                  statusCode: r.statusCode ?? 500,
                ),
              );
            }

            return Right(null);
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
