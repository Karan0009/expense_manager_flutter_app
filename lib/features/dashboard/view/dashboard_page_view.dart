import 'dart:io';

import 'package:expense_manager/core/helpers/permission_service.dart';
import 'package:expense_manager/core/helpers/sms_service.dart';
import 'package:expense_manager/core/helpers/utils.dart';
import 'package:expense_manager/features/dashboard/view/widgets/with_transactions_dashboard_view.dart';
import 'package:expense_manager/features/sms_permission_screen/view/pages/sms_permission_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardPageView extends ConsumerWidget {
  static const String routePath = '/expenses-dashboard';
  const DashboardPageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FocusScope.of(context).unfocus();

      if (Platform.isAndroid) {
        if (await PermissionService.isSmsPermissionGranted()) {
          SmsService().initialize(
              allowedSenders: [],
              onMessageReceived: (message) {
                // Handle the received SMS message here
                print("📨 Received SMS: $message");
                AppUtils.showSnackBar(context, "📩 SMS received: $message");
              });

          return;
        }
        if (!context.mounted) return;

        _navigateToSmsPermissionScreen(context);
      }
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: constraints.maxHeight,
              maxWidth: constraints.maxWidth,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16.0 : constraints.maxWidth * 0.2,
              ),
              child: WithTransactionsDashboardView(),

              // uncategorizedTransactionsState.when(
              //   data: (data) {
              //     if ((data?.meta.totalCount ?? 0) == 0) {
              //       return NoTransactionsWidget();
              //     }
              //     return WithTransactionsDashboardView();
              //   },
              //   loading: () => WithTransactionsDashboardView(),
              //   error: (error, stack) => Center(child: Text('Error: $error')),
              // ),
            ),
          ),
        );
      },
    );
  }
}

void _navigateToSmsPermissionScreen(BuildContext context) {
  context.push(SmsPermissionPageView.routePath);
}
