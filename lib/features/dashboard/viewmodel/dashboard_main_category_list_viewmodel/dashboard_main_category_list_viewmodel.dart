import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:expense_manager/config/app_config.dart';
import 'package:expense_manager/core/http/http_type_def.dart';
import 'package:expense_manager/data/repositories/category/category_remote_repository.dart';
import 'package:expense_manager/features/dashboard/models/dashboard_main_categories_list_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_main_category_list_viewmodel.g.dart';

@riverpod
class DashboardMainCategoryListViewModel
    extends _$DashboardMainCategoryListViewModel {
  late CategoryRemoteRepository _categoryRemoteRepository;

  @override
  Future<DashboardMainCategoriesListState?> build() async {
    _categoryRemoteRepository = ref.watch(categoryRemoteRepositoryProvider);
    final data = await loadTransctions(state.value?.meta.nextPageNumber ?? 1);
    return data.fold(
      (error) {
        log(error.message);
        throw Exception(error.message);
        // return Left(
        //     AppFailure(message: error.message, stackTrace: StackTrace.current));
      },
      (data) {
        log(data.toString());
        return data;
      },
    );
  }

  FutureEither<DashboardMainCategoriesListState?> loadTransctions(
      int page) async {
    final result = await _categoryRemoteRepository.index(
      limit: AppConfig.restClientGetMaxLimit,
      page: page,
    );
    return result.fold(
      (error) {
        return Left(error);
      },
      (apiResponse) {
        return Right(DashboardMainCategoriesListState(
          categories: apiResponse.data,
          meta: apiResponse.meta,
        ));
      },
    );
  }
}
