import 'dart:async';
import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:expense_manager/core/helpers/connectivity_service.dart';
import 'package:expense_manager/data/repositories/raw_transaction/raw_transaction_local_repository.dart';
import 'package:expense_manager/features/dashboard/view/widgets/with_transactions_dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardPageView extends ConsumerStatefulWidget {
  static const String routePath = '/expenses-dashboard';
  const DashboardPageView({super.key});

  @override
  ConsumerState<DashboardPageView> createState() => _DashboardPageViewState();
}

class _DashboardPageViewState extends ConsumerState<DashboardPageView> {
  bool hasInternet = false;
  StreamSubscription<bool>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initializeConnectivity();
  }

  Future<void> _initializeConnectivity() async {
    // Check initial connectivity state
    final initialConnectivity =
        await ConnectivityService().hasInternetConnection();
    if (mounted) {
      setState(() {
        hasInternet = initialConnectivity;
      });
    }

    // Listen to connectivity changes
    _connectivitySubscription = ConnectivityService()
        .connectivityStream
        .listen((hasInternetConnection) {
      if (mounted) {
        setState(() {
          hasInternet = hasInternetConnection;
        });

        // Auto-sync when connectivity is restored
        if (hasInternetConnection) {
          _syncPendingTransactions();
        }
      }
    });
  }

  Future<void> _syncPendingTransactions() async {
    try {
      final pendingRawTransactions =
          await ref.read(rawTransactionLocalRepositoryProvider).index();

      for (int i = 0; i < pendingRawTransactions.length; i++) {
        final transaction = pendingRawTransactions[i];
        await ref
            .read(rawTransactionLocalRepositoryProvider)
            .sync(transaction['id']);
      }
    } catch (e) {
      // Handle sync errors silently or show notification
      debugPrint('Auto-sync failed: $e');
    }
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              child: hasInternet
                  ? WithTransactionsDashboardView()
                  : const Center(
                      child: Text(
                        'No internet connection. Please check your network settings.',
                        style: TextStyle(color: ColorsConfig.textColor3),
                      ),
                    ),

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
