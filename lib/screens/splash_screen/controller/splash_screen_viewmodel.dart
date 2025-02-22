import 'package:expense_manager/data/models/splash_screen_state.dart';
import 'package:expense_manager/data/repositories/shared_prefs_repository.dart';
import 'package:expense_manager/screens/login_page/view/login_page_view.dart';
import 'package:expense_manager/screens/user_account_page/view/user_account_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// You need to override the dispose method if your StateNotifier or other providers
/// manage resources like:
///     Streams
///     Timers
///     Listeners (e.g., EventListeners or ValueNotifiers)
///     Controllers (e.g., TextEditingController, ScrollController)

final splashScreenViewModelProvider =
    StateNotifierProvider<SplashScreenViewmodel, SplashScreenState>((ref) {
  final sharedPrefsRepo = ref.watch(sharedPrefsRepoProvider);
  return SplashScreenViewmodel(sharedPrefsRepo);
});

class SplashScreenViewmodel extends StateNotifier<SplashScreenState> {
  final SharedPrefsRepo _sharedPrefsRepo;

  SplashScreenViewmodel(this._sharedPrefsRepo) : super(SplashScreenState());

  Future<void> checkIfUserLoggedIn(BuildContext context) async {
    // final curUser = await _sharedPrefsRepo.getCurrentUser();
    final accessToken = await _sharedPrefsRepo.getAccessToken();
    final refreshToken = await _sharedPrefsRepo.getRefreshToken();
    if (accessToken == null || refreshToken == null) {
      if (context.mounted) context.pushReplacement(LoginPageView.routePath);
    } else {
      if (context.mounted) {
        context.pushReplacement(UserAccountPageView.routePath);
      }
    }
    // if (context.mounted) {
    //   context.pushReplacement(LoginPageView.routePath);
    // }
  }
}
