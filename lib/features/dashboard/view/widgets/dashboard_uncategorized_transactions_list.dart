import 'package:expense_manager/core/widgets/loader.dart';
import 'package:expense_manager/core/widgets/radial_step_counter.dart';
import 'package:expense_manager/core/widgets/skeleton_loader.dart';
import 'package:expense_manager/data/models/transactions/user_transaction.dart';
import 'package:expense_manager/features/dashboard/view/widgets/dashboard_transaction_card.dart';
import 'package:expense_manager/features/dashboard/viewmodel/dashboard_uncategorized_transactions_list_viewmodel/dashboard_uncategorized_transactions_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for pagination loading state
final paginationLoadingProvider = StateProvider<bool>((ref) => false);

// Provider for transaction details callback
final transactionDetailsCallbackProvider =
    Provider<Future<Map<String, dynamic>?> Function(String, UserTransaction?)?>(
        (ref) => null);

class DashboardUncategorizedTransactionsList extends StatelessWidget {
  const DashboardUncategorizedTransactionsList({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('>>> DashboardUncategorizedTransactionsList build <<<');
    return SliverMainAxisGroup(
      slivers: [
        const _TransactionsHeader(),
        const _TransactionsContent(),
      ],
    );
  }
}

class _TransactionsHeader extends ConsumerWidget {
  const _TransactionsHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('>>> _TransactionsHeader build <<<');
    return SliverToBoxAdapter(
      child: RepaintBoundary(
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
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
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
    );
  }
}

class _TransactionsContent extends ConsumerWidget {
  const _TransactionsContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('>>> _TransactionsContent build <<<');

    final isLoading = ref.watch(paginationLoadingProvider);
    final callback = ref.watch(transactionDetailsCallbackProvider);

    return ref
        .watch(dashboardUncategorizedTransactionsListViewModelProvider)
        .when(
          data: (data) => SliverMainAxisGroup(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return DashboardTransactionCard(
                      transaction: data?.uncategorizedTransactions[index],
                      showTransactionDetailsBottomSheet:
                          callback ?? (_, __) => Future.value(null),
                    );
                  },
                  childCount: data?.uncategorizedTransactions.length ?? 0,
                ),
              ),
              if (isLoading)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 35,
                    width: 35,
                    child: Loader(),
                  ),
                ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 30,
                ),
              ),
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
                      highlightColor: Theme.of(context).cardColor.withValues(
                            alpha: 2.5,
                          ),
                    ),
                    SkeletonLoader(
                      width: double.infinity,
                      height: 100,
                      baseColor: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      highlightColor: Theme.of(context).cardColor.withValues(
                            alpha: 2.5,
                          ),
                    ),
                    SkeletonLoader(
                      width: double.infinity,
                      height: 100,
                      baseColor: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      highlightColor: Theme.of(context).cardColor.withValues(
                            alpha: 2.5,
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
  }
}
