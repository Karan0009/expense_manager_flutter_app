import 'package:dartz/dartz.dart';
import 'package:expense_manager/core/http/rest_client.dart';
import 'package:expense_manager/core/http/http_failure.dart';
import 'package:expense_manager/core/http/http_type_def.dart';
import 'package:expense_manager/data/models/category/sub_category.dart';
import 'package:expense_manager/data/models/common/api_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sub_category_remote_repository.g.dart';

@riverpod
SubCategoryRemoteRepository subCategoryRemoteRepository(Ref ref) {
  final restClient = ref.watch(restClientProvider);
  return SubCategoryRemoteRepository(restClient: restClient);
}

class SubCategoryRemoteRepository {
  final RestClient _restClient;

  SubCategoryRemoteRepository({required RestClient restClient})
      : _restClient = restClient;

  FutureEither<ApiResponse<List<SubCategory>, SubCategory>> getSubCategories({
    required int limit,
    required int page,
  }) async {
    try {
      final endpoint = 'v1/sub-category';
      Map<String, dynamic> params = {
        "limit": limit,
        "page": page,
      };

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
            if (r.statusCode != 200 || r.data["data"] == null) {
              return Left(
                HttpFailure(
                  message: r.data["message"] ?? "Failed to fetch data",
                  statusCode: r.statusCode ?? 500,
                ),
              );
            }
            final val = ApiResponse<List<SubCategory>, SubCategory>.fromMap(
              r.data,
              SubCategory.fromMap,
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

  FutureEither<ApiResponse<SubCategory, SubCategory>> createSubCategories({
    required String name,
    required String description,
    required String? icon,
    required int categoryId,
  }) async {
    try {
      final endpoint = 'v1/sub-category';
      Map<String, dynamic> body = {
        "name": name,
        "description": description,
        "category_id": categoryId,
      };

      if (icon != null) {
        body["icon"] = icon;
      }

      final response = await _restClient.postRequest(
        url: endpoint,
        body: body,
        requireAuth: true,
      );

      return response.fold(
        (l) {
          return Left(l);
        },
        (r) {
          try {
            if (r.statusCode != 201 && r.data["data"] == null) {
              return Left(
                HttpFailure(
                  message: r.data["message"] ?? "Failed to fetch data",
                  statusCode: r.statusCode ?? 500,
                ),
              );
            }
            final val = ApiResponse<SubCategory, SubCategory>.fromMap(
              r.data,
              SubCategory.fromMap,
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

  FutureEither<ApiResponse<List<SubCategory>, SubCategory>>
      searchSubCategories({
    required String name,
  }) async {
    try {
      final endpoint = 'v1/sub-category/search';

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
            if (r.statusCode != 200 && r.data["data"] == null) {
              return Left(
                HttpFailure(
                  message: r.data["message"] ?? "Failed to fetch data",
                  statusCode: r.statusCode ?? 500,
                ),
              );
            }
            final val = ApiResponse<List<SubCategory>, SubCategory>.fromMap(
              r.data,
              SubCategory.fromMap,
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
