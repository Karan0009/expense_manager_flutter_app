import 'package:dartz/dartz.dart';
import 'package:expense_manager/core/http/rest_client.dart';
import 'package:expense_manager/core/http/http_failure.dart';
import 'package:expense_manager/core/http/http_type_def.dart';
import 'package:expense_manager/data/models/common/api_response.dart';
import 'package:expense_manager/data/models/transactions/summarized_transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_summary_remote_repository.g.dart';

@riverpod
TransactionSummaryRemoteRepository transactionSummaryRemoteRepository(Ref ref) {
  final restClient = ref.watch(restClientProvider);
  return TransactionSummaryRemoteRepository(restClient: restClient);
}

class TransactionSummaryRemoteRepository {
  final RestClient _restClient;

  TransactionSummaryRemoteRepository({required RestClient restClient})
      : _restClient = restClient;

  FutureEither<ApiResponse<List<SummarizedTransaction>, SummarizedTransaction>>
      getSummarizedTransactions({
    String? onDate,
    String? fromDate,
    String? toDate,
    required String summaryType,
    String? sortBy = 'transaction_datetime',
    required String orderBy,
  }) async {
    try {
      final endpoint = 'v1/transaction/summary';
      Map<String, dynamic> params = {
        "summary_type": summaryType,
        "sort_by": sortBy,
        "order_by": orderBy,
      };

      if (onDate != null) {
        params["on_date"] = onDate;
      } else if (fromDate != null && toDate != null) {
        params["from_date"] = fromDate;
        params["to_date"] = toDate;
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
                  message: r.data["message"] ?? "Failed to fetch data",
                  statusCode: r.statusCode ?? 500,
                ),
              );
            }
            final val = ApiResponse<List<SummarizedTransaction>,
                SummarizedTransaction>.fromMap(
              r.data,
              SummarizedTransaction.fromMap,
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
