import 'package:expense_manager/screens/enter_otp_page/view/enter_otp_page_view.dart';
import 'package:expense_manager/screens/splash_screen/view/splash_screen_view.dart';
import 'package:expense_manager/screens/user_account_page/view/user_account_page_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:expense_manager/screens/login_page/view/login_page_view.dart';
import 'package:expense_manager/screens/create_account_page/view/create_account_page_view.dart';

final GoRouter router = GoRouter(
  initialLocation: SplashScreenView.routePath,
  routes: [
    GoRoute(
      path: SplashScreenView.routePath,
      builder: (BuildContext context, GoRouterState state) =>
          const SplashScreenView(),
    ),
    GoRoute(
      path: LoginPageView.routePath,
      builder: (BuildContext context, GoRouterState state) =>
          const LoginPageView(),
    ),
    GoRoute(
      path: CreateAccountPageView.routePath,
      builder: (BuildContext context, GoRouterState state) =>
          const CreateAccountPageView(),
    ),
    GoRoute(
      path: EnterOtpPageView.routePath,
      builder: (context, state) => const EnterOtpPageView(),
    ),
    GoRoute(
      path: UserAccountPageView.routePath,
      builder: (context, state) => const UserAccountPageView(),
    ),
  ],
);
