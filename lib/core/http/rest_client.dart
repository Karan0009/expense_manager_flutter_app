import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:expense_manager/config/app_config.dart';
import 'package:expense_manager/config/failures_messages.dart';
import 'package:expense_manager/config/log_label.dart';
import 'package:expense_manager/core/http/http_failure.dart';
import 'package:expense_manager/core/http/http_type_def.dart';
import 'package:expense_manager/data/repositories/auth/auth_local_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rest_client.g.dart';

@riverpod
RestClient restClient(Ref ref) {
  final authLocalRepo = ref.watch(authLocalRepositoryProvider);
  return RestClient(authLocalRepository: authLocalRepo);
}

class RestClient {
  // final String? _authToken;
  final Dio _dio;
  final AuthLocalRepository _authLocalRepository;

  RestClient({required AuthLocalRepository authLocalRepository})
      : _authLocalRepository = authLocalRepository,
        _dio = Dio(
          BaseOptions(
            baseUrl: AppConfig.baseApiUrl,
            connectTimeout: Duration(seconds: 10),
            receiveTimeout: Duration(seconds: 5),
            validateStatus: (status) => status! < 500,
            headers: {
              "Content-Type": "application/json",
              // "Cookie": "token=$authToken",
            },
          ),
        );

  FutureEither<Response> getRequest({
    required String url,
    bool requireAuth = true,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      if (requireAuth) {
        final authToken = await _authLocalRepository.getAccessToken();

        authToken.fold(
          (l) {
            return Left(HttpFailure(
              message: FailureMessage.authTokenEmpty,
              statusCode: 401,
            ));
          },
          (r) {
            if (r.isEmpty) {
              return Left(HttpFailure(
                message: FailureMessage.authTokenEmpty,
                statusCode: 401,
              ));
            }
            _dio.options.headers["Authorization"] = "Bearer $r";
          },
        );
      }

      if (AppConfig.logHttp) {
        log('REQUEST TO : $url', name: LogLabel.httpGet);
      }

      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
      );
      if (AppConfig.logHttp) {
        log('RESPONSE : ${response.data}', name: LogLabel.httpGet);
      }
      return Right(response);
    } catch (e, stktrc) {
      log('ERROR: $e', name: LogLabel.httpGet);
      return Left(HttpFailure(
        message: FailureMessage.getRequestMessage,
        stackTrace: stktrc,
      ));
    }
  }

  FutureEither<Response> postRequest(
      {required String url, dynamic body, bool requireAuth = true}) async {
    try {
      if (requireAuth) {
        final authToken = await _authLocalRepository.getAccessToken();

        authToken.fold(
          (l) {
            return Left(HttpFailure(
              message: FailureMessage.authTokenEmpty,
              statusCode: 401,
            ));
          },
          (r) {
            if (r.isEmpty) {
              return Left(HttpFailure(
                message: FailureMessage.authTokenEmpty,
                statusCode: 401,
              ));
            }
            _dio.options.headers["Authorization"] = "Bearer $r";
          },
        );
      }

      if (AppConfig.logHttp) {
        log('REQUEST TO : $url', name: LogLabel.httpPost);
        log('BODY : $body', name: LogLabel.httpPost);
      }

      final response = await _dio.post(url, data: body);
      if (AppConfig.logHttp) {
        log('RESPONSE : ${response.data}', name: LogLabel.httpPost);
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response);
      }

      if (response.statusCode == 429) {
        return Left(HttpFailure(
          message: FailureMessage.postTooManyRequests,
          statusCode: response.statusCode!,
        ));
      }

      return Left(HttpFailure(
        message: response.data.toString(),
        statusCode: response.statusCode ?? 500,
      ));
    } catch (e, stktrc) {
      log('ERROR: $e', name: LogLabel.httpPost);
      return Left(HttpFailure(
        message: e.toString(),
        stackTrace: stktrc,
      ));
    }
  }

  FutureEither<Response> putRequest({
    required String url,
    dynamic body,
    bool requireAuth = true,
  }) async {
    try {
      if (requireAuth) {
        final authToken = await _authLocalRepository.getAccessToken();

        authToken.fold(
          (l) {
            return Left(HttpFailure(
              message: FailureMessage.authTokenEmpty,
              statusCode: 401,
            ));
          },
          (r) {
            if (r.isEmpty) {
              return Left(HttpFailure(
                message: FailureMessage.authTokenEmpty,
                statusCode: 401,
              ));
            }
            _dio.options.headers["Authorization"] = "Bearer $r";
          },
        );
      }

      if (AppConfig.logHttp) {
        log('REQUEST TO : $url', name: LogLabel.httpPut);
        log('BODY : $body', name: LogLabel.httpPut);
      }

      final response = await _dio.put(url, data: body);
      if (AppConfig.logHttp) {
        log('RESPONSE : ${response.data}', name: LogLabel.httpPut);
      }
      return Right(response);
    } catch (e, stktrc) {
      log('ERROR: $e', name: LogLabel.httpPut);
      return Left(HttpFailure(
        message: FailureMessage.putRequestMessage,
        stackTrace: stktrc,
      ));
    }
  }

  FutureEither<Response> deleteRequest({
    required String url,
    dynamic body,
    bool requireAuth = true,
  }) async {
    try {
      if (requireAuth) {
        final authToken = await _authLocalRepository.getAccessToken();

        authToken.fold(
          (l) {
            return Left(HttpFailure(
              message: FailureMessage.authTokenEmpty,
              statusCode: 401,
            ));
          },
          (r) {
            if (r.isEmpty) {
              return Left(HttpFailure(
                message: FailureMessage.authTokenEmpty,
                statusCode: 401,
              ));
            }
            _dio.options.headers["Authorization"] = "Bearer $r";
          },
        );
      }

      if (AppConfig.logHttp) {
        log('REQUEST TO : $url', name: LogLabel.httpDelete);
        log('BODY : $body', name: LogLabel.httpDelete);
      }

      final response = await _dio.delete(url, data: body);
      if (AppConfig.logHttp) {
        log('RESPONSE : ${response.data}', name: LogLabel.httpDelete);
      }
      return Right(response);
    } catch (e, stktrc) {
      log('ERROR: $e', name: LogLabel.httpDelete);
      return Left(HttpFailure(
        message: FailureMessage.deleteRequestMessage,
        stackTrace: stktrc,
      ));
    }
  }
}
