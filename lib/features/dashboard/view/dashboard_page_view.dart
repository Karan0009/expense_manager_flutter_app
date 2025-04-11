import 'package:expense_manager/features/dashboard/view/widgets/with_transactions_dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardPageView extends ConsumerWidget {
  static const String routePath = '/expenses-dashboard';
  const DashboardPageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              child:
                  // TODO: REF WATCH TRANSACTIONS PROVIDERS HERE
                  // NoTransactionsWidget(),
                  SingleChildScrollView(
                child: const WithTransactionsDashboardView(),
              ),
            ),
          ),
        );
      },
    );
  }
}
