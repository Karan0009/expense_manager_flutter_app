import 'package:expense_manager/data/models/token.dart';
import 'package:expense_manager/data/repositories/auth/auth_local_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_screen_viewmodel.g.dart';

@riverpod
class SplashScreenViewModel extends _$SplashScreenViewModel {
  late AuthLocalRepository _authLocalRepository;
  // late AuthRemoteRepository _authRemoteRepository;

  @override
  FutureOr<Token?> build() async {
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);

    return await checkIfUserLoggedIn();
  }

  Future<Token?> checkIfUserLoggedIn() async {
    final savedToken = await _authLocalRepository.getAccessAndRefreshTokens();
    return savedToken.fold(
      (error) {
        return null;
      },
      (token) {
        return token;
      },
    );
  }
}
