import 'package:expense_manager/data/models/user.dart';
import 'package:expense_manager/data/repositories/user/user_local_repository.dart';
import 'package:expense_manager/data/repositories/user/user_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_account_viewmodel.g.dart';

@riverpod
class UserAccountViewModel extends _$UserAccountViewModel {
  late UserLocalRepository _userLocalRepository;
  late UserRemoteRepository _userRemoteRepository;

  @override
  FutureOr<User?> build() async {
    _userLocalRepository = ref.watch(userLocalRepositoryProvider);
    _userRemoteRepository = ref.watch(userRemoteRepositoryProvider);

    return await loadUserDetails();
  }

  Future<User?> loadUserDetails() async {
    final savedUserDetails = await isUserInfoSaved();
    if (savedUserDetails != null) {
      return savedUserDetails;
    }

    final apiRes = await getUserDetailsFromApi();

    if (apiRes == null) {
      ;
      throw Exception("Failed to fetch user details from API");
    }

    await _userLocalRepository.setUserDetails(apiRes);

    return apiRes;
  }

  Future<User?> isUserInfoSaved() async {
    final savedUserDetails = await _userLocalRepository.getUserDetails();

    return savedUserDetails.fold(
      (error) {
        return null;
      },
      (user) {
        return user;
      },
    );
  }

  Future<User?> getUserDetailsFromApi() async {
    final apiRes = await _userRemoteRepository.getUserDetails();

    return apiRes.fold(
      (error) {
        return null;
      },
      (user) {
        return user;
      },
    );
  }
}
