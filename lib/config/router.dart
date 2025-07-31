import 'package:expense_manager/core/layouts/home_layout.dart';
import 'package:expense_manager/features/dashboard/view/dashboard_page_view.dart';
import 'package:expense_manager/features/dashboard/view/particular_transactions_list_page_view.dart';
import 'package:expense_manager/features/login_page/view/pages/enter_otp_page_view.dart';
import 'package:expense_manager/features/shared_raw_transaction/view/pages/shared_raw_transaction_view.dart';
import 'package:expense_manager/features/sms_permission_screen/view/pages/sms_permission_page_view.dart';
import 'package:expense_manager/features/splash_screen/view/pages/splash_screen_view.dart';
import 'package:expense_manager/features/user_account_screen/view/pages/offline_transactions_page_view.dart';
import 'package:expense_manager/features/user_account_screen/view/pages/user_account_options_page_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:expense_manager/features/login_page/view/pages/login_page_view.dart';
import 'package:expense_manager/features/login_page/view/pages/create_account_page_view.dart';

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
              path: UserAccountOptionsPageView.routePath,
              builder: (context, state) => const UserAccountOptionsPageView(),
            ),
            GoRoute(
              path: OfflineTransactionsPageView.routePath,
              builder: (context, state) => const OfflineTransactionsPageView(),
            ),
            GoRoute(
              path: DashboardPageView.routePath,
              builder: (context, state) => const DashboardPageView(),
            ),
            GoRoute(
              path: ParticularTransactionsListPageView.routePath,
              builder: (context, state) => ParticularTransactionsListPageView(
                subCatId: (state.extra as dynamic)?['subCatId'] as int,
              ),
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
      name: SharedRawTransactionView.routePath,
      path: SharedRawTransactionView.routePath,
      builder: (BuildContext context, GoRouterState state) =>
          SharedRawTransactionView(
        images: (state.extra as dynamic)?['images'] ?? [],
        text: (state.extra as dynamic)?['text'] as String? ?? '',
      ),
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
      path: SmsPermissionPageView.routePath,
      builder: (context, state) => const SmsPermissionPageView(),
    ),
  ],
);
