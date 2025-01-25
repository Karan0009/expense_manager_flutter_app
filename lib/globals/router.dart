import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:expense_manager/screens/login_page/view/login_page_view.dart';
import 'package:expense_manager/screens/create_account_page/view/create_account_page_view.dart';

final GoRouter router = GoRouter(
  initialLocation: LoginPageView.routePath,
  routes: [
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
    // GoRoute(
    //   path: loginOtpPage,
    //   builder: (context, state) => const LoginOtpPageView(),
    // ),
  ],
);
