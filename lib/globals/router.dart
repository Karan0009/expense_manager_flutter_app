import 'package:expense_manager/globals/layouts/home_layout.dart';
import 'package:expense_manager/screens/enter_otp_page/view/enter_otp_page_view.dart';
import 'package:expense_manager/screens/expenses_dashboard_page/view/expenses_dashboard_page_view.dart';
import 'package:expense_manager/screens/splash_screen/view/splash_screen_view.dart';
import 'package:expense_manager/screens/user_account_page/view/user_account_page_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:expense_manager/screens/login_page/view/login_page_view.dart';
import 'package:expense_manager/screens/create_account_page/view/create_account_page_view.dart';

final GlobalKey<NavigatorState> _rootNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _rootNavHomeKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellHome');

final GoRouter router = GoRouter(
  initialLocation: SplashScreenView.routePath,
  navigatorKey: _rootNavKey,
  routes: [
    StatefulShellRoute.indexedStack(
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          navigatorKey: _rootNavHomeKey,
          routes: [
            GoRoute(
              path: UserAccountPageView.routePath,
              builder: (context, state) => const UserAccountPageView(),
            ),
            GoRoute(
              path: ExpensesDashboardPageView.routePath,
              builder: (context, state) => const ExpensesDashboardPageView(),
            ),
          ],
        )
      ],
      builder: (context, state, navigationShell) {
        return HomeLayout(
          navigationShell: navigationShell,
        );
      },
    ),
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
  ],
);
