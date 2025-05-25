import 'package:expense_manager/core/widgets/custom_button.dart';
import 'package:expense_manager/core/widgets/radial_step_counter.dart';
import 'package:expense_manager/core/widgets/skeleton_loader.dart';
import 'package:expense_manager/data/models/transactions/user_transaction.dart';
import 'package:expense_manager/features/dashboard/view/widgets/dashboard_transaction_card.dart';
import 'package:expense_manager/features/dashboard/viewmodel/dashboard_uncategorized_transactions_list_viewmodel/dashboard_uncategorized_transactions_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardUncategorizedTransactionsList extends ConsumerStatefulWidget {
  final Future<Map<String, dynamic>?> Function(String, UserTransaction?)
      showTransactionDetailsBottomSheet;
  const DashboardUncategorizedTransactionsList({
    super.key,
    required this.showTransactionDetailsBottomSheet,
  });

  @override
  ConsumerState<DashboardUncategorizedTransactionsList> createState() =>
      _DashboardUncategorizedTransactionsListState();
}

class _DashboardUncategorizedTransactionsListState
    extends ConsumerState<DashboardUncategorizedTransactionsList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // todo: fix this
    return SliverMainAxisGroup(
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
                ref
                    .watch(
                        dashboardUncategorizedTransactionsListViewModelProvider)
                    .when(
                      data: (data) => Row(
                        children: [
                          Text(
                            "${data?.meta.totalCount.toString() ?? '0'} Pending",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          RadialStepCounter(
                            current: 10,
                            total: 100,
                            diameter: 22,
                          ),
                        ],
                      ),
                      error: (error, stackTrace) => Text(
                        'Error loading transactions',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      loading: () => SkeletonLoader(
                        width: 100,
                        height: 50,
                        baseColor: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        highlightColor: Theme.of(context).cardColor.withValues(
                              alpha: 2.5,
                            ),
                      ),
                    ),
              ],
            ),
          ),
        ),
        ref.watch(dashboardUncategorizedTransactionsListViewModelProvider).when(
              data: (data) => SliverMainAxisGroup(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return DashboardTransactionCard(
                          transaction: data?.uncategorizedTransactions[index],
                          showTransactionDetailsBottomSheet:
                              widget.showTransactionDetailsBottomSheet,
                        );
                      },
                      childCount: data?.uncategorizedTransactions.length ?? 0,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: CustomButton(
                      onPressed: () {},
                      isLoading: false,
                      buttonText: 'Load more',
                    ),
                  )
                ],
              ),
              error: (error, stackTrace) => SliverToBoxAdapter(
                child: Text(
                  'Error Loading transaction',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              loading: () {
                return SliverToBoxAdapter(
                  child: SizedBox(
                    height: 400,
                    width: double.infinity,
                    child: Column(
                      children: [
                        SkeletonLoader(
                          width: double.infinity,
                          height: 100,
                          baseColor: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          highlightColor:
                              Theme.of(context).cardColor.withValues(
                                    alpha: 2.5,
                                  ),
                        ),
                        SkeletonLoader(
                          width: double.infinity,
                          height: 100,
                          baseColor: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          highlightColor:
                              Theme.of(context).cardColor.withValues(
                                    alpha: 2.5,
                                  ),
                        ),
                        SkeletonLoader(
                          width: double.infinity,
                          height: 100,
                          baseColor: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          highlightColor:
                              Theme.of(context).cardColor.withValues(
                                    alpha: 2.5,
                                  ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      ],
    );
  }
}
