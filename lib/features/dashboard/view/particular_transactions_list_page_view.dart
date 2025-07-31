import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:expense_manager/core/widgets/loader.dart';
import 'package:expense_manager/features/dashboard/view/widgets/dashboard_transaction_card.dart';
import 'package:expense_manager/features/dashboard/viewmodel/transactions_list_viewmodel/transactions_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ParticularTransactionsListPageView extends ConsumerStatefulWidget {
  static const String routePath = '/expenses-dashboard/transactions';
  final int subCatId;
  const ParticularTransactionsListPageView({
    super.key,
    required this.subCatId,
  });

  @override
  ConsumerState<ParticularTransactionsListPageView> createState() =>
      _ParticularTransactionsListPageViewState();
}

class _ParticularTransactionsListPageViewState
    extends ConsumerState<ParticularTransactionsListPageView> {
  final expenseTitleController = TextEditingController();
  final expenseAmountController = TextEditingController();
  final searchSubCategoryController = TextEditingController();
  final searchCategoryController = TextEditingController();
  final newSubCatNameController = TextEditingController();
  final newSubCatDescController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  bool _isInitialized = false;
  bool _isListLoading = false;
  bool showAddExpenseLoading = false;
  bool isDeleteButtonLoading = false;
  bool isEditButtonLoading = false;

  @override
  void initState() {
    super.initState();
    addScrollListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FocusScope.of(context).unfocus();

      if (!_isInitialized) {
        await ref
            .read(transactionsListViewModelProvider.notifier)
            .loadTransctions(1, widget.subCatId);
        _isInitialized = true;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    expenseTitleController.dispose();
    expenseAmountController.dispose();
    searchSubCategoryController.dispose();
    newSubCatNameController.dispose();
    newSubCatDescController.dispose();
    searchCategoryController.dispose();
    super.dispose();
  }

  void addScrollListeners() {
    _scrollController.addListener(() async {
      // print(
      // "clients: ${_scrollController.hasClients}, Scroll position: ${_scrollController.position.pixels}, Max Scroll Extent: ${_scrollController.position.maxScrollExtent}, screen height: ${MediaQuery.of(context).size.height} ,should show up ${_scrollController.position.pixels > MediaQuery.of(context).size.height}");
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_isListLoading) return;

        setState(() {
          _isListLoading = true;
        });

        await ref
            .read(transactionsListViewModelProvider.notifier)
            .loadMoreTransactions();

        setState(() {
          _isListLoading = false;
        });
      }

      if (mounted &&
          _scrollController.hasClients &&
          _scrollController.position.pixels >
              MediaQuery.of(context).size.height) {
        // setState(() {
        //   showScrollToTopButton = true;
        // });
      } else {
        // setState(() {
        //   showScrollToTopButton = false;
        // });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncTxns = ref.watch(transactionsListViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transactions',
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
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    asyncTxns.when(
                        loading: () => const SliverToBoxAdapter(
                              child: Center(child: CircularProgressIndicator()),
                            ),
                        error: (err, _) => const SliverToBoxAdapter(
                              child: Center(child: Text('Some error occurred')),
                            ),
                        data: (data) {
                          if (data == null) {
                            return const SliverToBoxAdapter(
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          if (data.transactions.isEmpty) {
                            return const SliverToBoxAdapter(
                              child: Center(
                                child: Text('No transactions found.'),
                              ),
                            );
                          }

                          return SliverPadding(
                            padding: const EdgeInsets.only(bottom: 90),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return DashboardTransactionCard(
                                    transaction: data.transactions[index],
                                    showTransactionDetailsBottomSheet:
                                        (_, __) async {
                                      return const {};
                                    },
                                  );
                                },
                                childCount: data.transactions.length,
                              ),
                            ),
                          );

                          // return ListView.builder(
                          //     controller: _scrollController,
                          //     padding: const EdgeInsets.only(bottom: 80),
                          //     itemCount: data.transactions.length,
                          //     itemBuilder: (context, index) {
                          //       return DashboardTransactionCard(
                          //         transaction: data.transactions[index],
                          //         showTransactionDetailsBottomSheet:
                          //             (_, __) async {
                          //           return const {};
                          //         },
                          //       );
                          //     });
                        }),
                    if (_isListLoading)
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 35,
                          width: 35,
                          child: Loader(),
                        ),
                      ),
                    if (_isListLoading)
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 30,
                        ),
                      ),
                  ],
                )),
          );
        },
      ),
    );
  }
}
