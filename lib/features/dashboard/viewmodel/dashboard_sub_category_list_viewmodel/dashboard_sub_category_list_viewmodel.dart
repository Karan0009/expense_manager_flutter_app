import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:expense_manager/config/app_config.dart';
import 'package:expense_manager/core/http/http_type_def.dart';
import 'package:expense_manager/data/models/category/sub_category.dart';
import 'package:expense_manager/data/repositories/category/sub_category_remote_repository.dart';
import 'package:expense_manager/features/dashboard/models/dashboard_sub_categories_list_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_sub_category_list_viewmodel.g.dart';

@riverpod
class DashboardSubCategoryListViewModel
    extends _$DashboardSubCategoryListViewModel {
  late SubCategoryRemoteRepository _subCategoryRemoteRepository;

  @override
  Future<DashboardSubCategoriesListState?> build() async {
    _subCategoryRemoteRepository =
        ref.watch(subCategoryRemoteRepositoryProvider);
    final data = await loadSubCategories(state.value?.meta.nextPage ?? 1);
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

  FutureEither<DashboardSubCategoriesListState?> loadSubCategories(
    int page,
  ) async {
    final result = await _subCategoryRemoteRepository.getSubCategories(
      limit: AppConfig.restClientGetMaxLimit,
      page: page,
    );
    return result.fold(
      (error) {
        return Left(error);
      },
      (apiResponse) {
        return Right(DashboardSubCategoriesListState(
          subCategories: apiResponse.data,
          meta: apiResponse.meta,
        ));
      },
    );
  }

  FutureEither<SubCategory?> create({
    required int categoryId,
    required String description,
    required String name,
  }) async {
    final result = await _subCategoryRemoteRepository.createSubCategories(
      categoryId: categoryId,
      description: description,
      icon: null,
      name: name,
    );
    return result.fold(
      (error) {
        return Left(error);
      },
      (apiResponse) {
        return Right(apiResponse.data);
      },
    );
  }

  FutureVoid addSubCategoryToList(SubCategory sc) async {
    if (state.value != null) {
      state = AsyncValue.data(state.value!.copyWith(
        subCategories: [
          ...state.value!.subCategories,
          sc,
        ],
      ));
    }
  }
}
