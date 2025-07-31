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
    final asyncTxns = ref.watch(rawTransactionLocalViewModelProvider);
    final vm = ref.watch(rawTransactionLocalViewModelProvider.notifier);
    final syncingIds = vm.syncingIds;

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight,
                maxWidth: constraints.maxWidth,
              ),
              child: asyncTxns.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(child: Text('❌ Error: $err')),
                  data: (transactions) {
                    if (transactions.isEmpty) {
                      return const Center(
                          child: Text('No offline transactions found.'));
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.only(bottom: 60),
                      itemCount: transactions.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final tx = transactions[index];

                        final parsedData = jsonDecode(tx['data']) ?? {};

                        return ListTile(
                          onTap: () =>
                              _showTransactionDetails(context, tx, parsedData),
                          title: Column(
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
                                'status: ${tx['status']}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                tx['created_at'] ?? '',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          trailing: SizedBox(
                              width:
                                  190, // Constrain the width to fit both buttons
                              child: Row(
                                children: [
                                  CustomButton(
                                    isLoading: syncingIds.contains(tx['id']),
                                    buttonText: 'Remove',
                                    onPressed: () async {
                                      await ref
                                          .read(
                                              rawTransactionLocalViewModelProvider
                                                  .notifier)
                                          .deleteTransaction(tx['id']);
                                    },
                                    containerWidth: 90,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          color: ColorsConfig.color4,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(0),
                                      backgroundColor: ColorsConfig.bgColor1
                                          .withValues(alpha: 0.9),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.delete_forever,
                                      color: ColorsConfig.textColor1,
                                      size: 16,
                                    ),
                                    containerStyle: BoxDecoration(
                                      border: Border.all(
                                        color: ColorsConfig.textColor1,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  CustomButton(
                                    isLoading: syncingIds.contains(tx['id']),
                                    buttonText: 'Sync',
                                    onPressed: () async {
                                      await ref
                                          .read(
                                              rawTransactionLocalViewModelProvider
                                                  .notifier)
                                          .syncTransaction(tx['id']);
                                    },
                                    containerWidth: 90,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          color: ColorsConfig.color4,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(0),
                                      backgroundColor: ColorsConfig.bgColor1
                                          .withValues(alpha: 0.9),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.sync,
                                      color: ColorsConfig.textColor1,
                                      size: 16,
                                    ),
                                    containerStyle: BoxDecoration(
                                      border: Border.all(
                                        color: ColorsConfig.textColor1,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        );
                      },
                    );
                  }),
            ),
          );
        },
      ),
    );
  }

  // Add this method to your _OfflineTransactionsPageViewState class
  void _showTransactionDetails(BuildContext context, Map<String, dynamic> tx,
      Map<String, dynamic> parsedData) {
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
                    jsonDecode(tx['data'])['data']?.toString() ??
                        'No data available',
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
