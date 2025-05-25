import 'package:dartz/dartz.dart';
import 'package:expense_manager/core/http/rest_client.dart';
import 'package:expense_manager/core/http/http_failure.dart';
import 'package:expense_manager/core/http/http_type_def.dart';
import 'package:expense_manager/data/models/category/main_category.dart';
import 'package:expense_manager/data/models/common/api_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_remote_repository.g.dart';

@riverpod
CategoryRemoteRepository categoryRemoteRepository(Ref ref) {
  final restClient = ref.watch(restClientProvider);
  return CategoryRemoteRepository(restClient: restClient);
}

class CategoryRemoteRepository {
  final RestClient _restClient;

  CategoryRemoteRepository({required RestClient restClient})
      : _restClient = restClient;

  FutureEither<ApiResponse<List<MainCategory>, MainCategory>> index({
    required int limit,
    required int page,
    String? searchTxt,
  }) async {
    try {
      final endpoint = 'v1/category';
      Map<String, dynamic> params = {
        "limit": limit,
        "page": page,
      };

      if (searchTxt != null && searchTxt.isNotEmpty) {
        params["search_txt"] = searchTxt;
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
            final val = ApiResponse<List<MainCategory>, MainCategory>.fromMap(
              r.data,
              MainCategory.fromMap,
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

  FutureEither<ApiResponse<List<MainCategory>, MainCategory>> search({
    required String name,
  }) async {
    try {
      final endpoint = 'v1/category/search';

      Map<String, dynamic> params = {
        "search_txt": name,
      };

      final response = await _restClient.getRequest(
        url: endpoint,
        queryParameters: params,
        requireAuth: true,
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
            final val = ApiResponse<List<MainCategory>, MainCategory>.fromMap(
              r.data,
              MainCategory.fromMap,
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
