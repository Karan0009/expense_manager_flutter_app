import 'package:expense_manager/core/widgets/radial_step_counter.dart';
import 'package:expense_manager/data/models/transactions/user_transaction.dart';
import 'package:expense_manager/features/dashboard/view/widgets/dashboard_transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardTransactionsList extends ConsumerWidget {
  const DashboardTransactionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int current = 10;
    int total = 100;
    // todo: fix this
    return SizedBox(
      height: 500,
      child: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transactions',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Row(
                    children: [
                      Text(
                        "$current/$total added",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      RadialStepCounter(
                        current: current,
                        total: total,
                        diameter: 22,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return DashboardTransactionCard(
                  transaction: UserTransaction(),
                );
              },
              childCount: 2,
            ),
          )
        ],
      ),
    );
  }
}
