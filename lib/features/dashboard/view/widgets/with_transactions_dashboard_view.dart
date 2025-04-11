import 'package:expense_manager/features/dashboard/view/widgets/daily_summary_graph_card.dart';
import 'package:expense_manager/features/dashboard/view/widgets/expenses_summary_card.dart';
import 'package:expense_manager/features/dashboard/view/widgets/dashboard_transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WithTransactionsDashboardView extends ConsumerWidget {
  const WithTransactionsDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Expenses',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(
          height: 10,
        ),
        ExpensesSummaryCard(),
        const SizedBox(
          height: 10,
        ),
        DailySummaryGraphCard(),
        const SizedBox(
          height: 10,
        ),
        DashboardTransactionsList()
      ],
    );
  }
}
