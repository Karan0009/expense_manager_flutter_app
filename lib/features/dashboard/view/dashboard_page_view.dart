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
  bool isCheckingConnectivity = true;
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
        isCheckingConnectivity = false;
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
    return _DashboardLayout(
      hasInternet: hasInternet,
      isCheckingConnectivity: isCheckingConnectivity,
    );
  }
}

class _DashboardLayout extends StatelessWidget {
  final bool hasInternet;
  final bool isCheckingConnectivity;

  const _DashboardLayout({
    required this.hasInternet,
    required this.isCheckingConnectivity,
  });

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
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildContent(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    if (isCheckingConnectivity) {
      return const _LoadingWidget();
    }

    return hasInternet
        ? const WithTransactionsDashboardView()
        : const _NoInternetWidget();
  }
}

class _NoInternetWidget extends StatelessWidget {
  const _NoInternetWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off,
            size: 64,
            color: ColorsConfig.textColor3,
          ),
          SizedBox(height: 16),
          Text(
            'No internet connection',
            style: TextStyle(
              color: ColorsConfig.textColor3,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please check your network settings.',
            style: TextStyle(
              color: ColorsConfig.textColor3,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Checking connectivity...',
            style: TextStyle(
              color: ColorsConfig.textColor3,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
