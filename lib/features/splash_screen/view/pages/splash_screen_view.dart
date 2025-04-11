import 'package:expense_manager/features/dashboard/view/dashboard_page_view.dart';
import 'package:expense_manager/features/login_page/view/pages/login_page_view.dart';
import 'package:expense_manager/features/splash_screen/viewmodel/splash_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreenView extends ConsumerWidget {
  static const String routePath = '/';
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokenState = ref.watch(splashScreenViewModelProvider);
    return tokenState.when(
      data: (token) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (token != null) {
            _navigateToHomeScreen(context);
          } else {
            _navigateToLoginScreen(context);
          }
        });
        return const SizedBox();
      },
      error: (error, stackTrace) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _navigateToLoginScreen(context);
        });
        return const SizedBox();
      },
      loading: () => Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/piggy_img.png',
                      width: constraints.maxWidth * 0.3,
                      height: constraints.maxWidth * 0.3,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void _navigateToLoginScreen(BuildContext context) {
  context.pushReplacement(LoginPageView.routePath);
}

void _navigateToHomeScreen(BuildContext context) {
  context.pushReplacement(DashboardPageView.routePath);
}
