import 'dart:convert';

import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:expense_manager/core/widgets/custom_button.dart';
import 'package:expense_manager/features/user_account_screen/viewmodel/raw_transactions_local_viewmodel/raw_transaction_local_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OfflineTransactionsPageView extends ConsumerStatefulWidget {
  static const String routePath = '/local-raw-transactions';
  const OfflineTransactionsPageView({super.key});

  @override
  ConsumerState<OfflineTransactionsPageView> createState() =>
      _OfflineTransactionsPageViewState();
}

class _OfflineTransactionsPageViewState
    extends ConsumerState<OfflineTransactionsPageView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🔄 OfflineTransactionsPageView build');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Offline Transactions',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        backgroundColor: ColorsConfig.color1,
        forceMaterialTransparency: true,
        foregroundColor: ColorsConfig.textColor1,
      ),
      body: RepaintBoundary(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Consumer(
            builder: (context, ref, _) {
              final asyncTxns = ref.watch(rawTransactionLocalViewModelProvider);
              return asyncTxns.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('❌ Error: $err')),
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return const Center(
                        child: Text('No offline transactions found.'));
                  }

                  return ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(bottom: 60),
                    itemCount: transactions.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final tx = transactions[index];
                      return _TransactionListItem(
                        transaction: tx,
                        onTap: _showTransactionDetails,
                        key: ValueKey(tx['id']),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // Optimized method signature to avoid parsing in build
  void _showTransactionDetails(BuildContext context, Map<String, dynamic> tx) {
    final parsedData = jsonDecode(tx['data']) ?? {};

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Transaction Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('ID', tx['id']?.toString() ?? 'N/A'),
                _buildDetailRow('Status', tx['status']?.toString() ?? 'N/A'),
                _buildDetailRow(
                    'Type', parsedData['type']?.toString() ?? 'N/A'),
                _buildDetailRow(
                    'Created At', tx['created_at']?.toString() ?? 'N/A'),
                _buildDetailRow(
                    'Updated At', tx['updated_at']?.toString() ?? 'N/A'),
                const SizedBox(height: 16),
                Text(
                  'Data:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ColorsConfig.textColor1,
                      ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ColorsConfig.bgColor1.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: ColorsConfig.textColor1.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    parsedData['data']?.toString() ?? 'No data available',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                        ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(color: ColorsConfig.color2),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: ColorsConfig.textColor1,
                  ),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

// Optimized transaction list item widget with cached parsing
class _TransactionListItem extends ConsumerWidget {
  final Map<String, dynamic> transaction;
  final Function(BuildContext, Map<String, dynamic>) onTap;

  const _TransactionListItem({
    required this.transaction,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint(
        '>>> _TransactionListItem build for ID: ${transaction['id']} <<<');

    // Parse JSON only once per build
    final parsedData = jsonDecode(transaction['data']) ?? {};
    final vm = ref.watch(rawTransactionLocalViewModelProvider.notifier);
    final syncingIds = vm.syncingIds;
    final transactionId = transaction['id'];

    return RepaintBoundary(
      child: ListTile(
        onTap: () => onTap(context, transaction),
        title: _TransactionDetails(
          parsedData: parsedData,
          transaction: transaction,
        ),
        trailing: _TransactionActions(
          transactionId: transactionId,
          isLoading: syncingIds.contains(transactionId),
        ),
      ),
    );
  }
}

// Extracted widget for transaction details to avoid rebuilds
class _TransactionDetails extends StatelessWidget {
  final Map<String, dynamic> parsedData;
  final Map<String, dynamic> transaction;

  const _TransactionDetails({
    required this.parsedData,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('>>> _TransactionDetails build <<<');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Data: ${parsedData['data'] ?? ''}",
          style: Theme.of(context).textTheme.bodySmall,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          "Type: ${parsedData['type'] ?? ''}",
          style: Theme.of(context).textTheme.bodySmall,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          'Status: ${transaction['status']}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          transaction['created_at'] ?? '',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

// Extracted widget for action buttons with optimized style
class _TransactionActions extends ConsumerWidget {
  final dynamic transactionId;
  final bool isLoading;

  const _TransactionActions({
    required this.transactionId,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('>>> _TransactionActions build for ID: $transactionId <<<');

    // Cache expensive style calculations
    final buttonTextStyle = Theme.of(context).textTheme.labelMedium!.copyWith(
          color: ColorsConfig.color4,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        );

    final buttonStyle = ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(0),
      backgroundColor: ColorsConfig.bgColor1.withValues(alpha: 0.9),
    );

    final containerStyle = BoxDecoration(
      border: Border.all(
        color: ColorsConfig.textColor1,
        width: 1,
      ),
    );

    return SizedBox(
      width: 200,
      child: Row(
        children: [
          CustomButton(
            isLoading: isLoading,
            buttonText: 'Remove',
            onPressed: () async {
              await ref
                  .read(rawTransactionLocalViewModelProvider.notifier)
                  .deleteTransaction(transactionId);
            },
            containerWidth: 105,
            textStyle: buttonTextStyle,
            style: buttonStyle,
            prefixIcon: const Icon(
              Icons.delete_forever,
              color: ColorsConfig.textColor1,
              size: 16,
            ),
            containerStyle: containerStyle,
          ),
          CustomButton(
            isLoading: isLoading,
            buttonText: 'Sync',
            onPressed: () async {
              await ref
                  .read(rawTransactionLocalViewModelProvider.notifier)
                  .syncTransaction(transactionId);
            },
            containerWidth: 90,
            textStyle: buttonTextStyle,
            style: buttonStyle,
            prefixIcon: const Icon(
              Icons.sync,
              color: ColorsConfig.textColor1,
              size: 16,
            ),
            containerStyle: containerStyle,
          ),
        ],
      ),
    );
  }
}
