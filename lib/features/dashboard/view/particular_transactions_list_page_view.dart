import 'dart:developer';

import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:expense_manager/core/helpers/transaction_helpers.dart';
import 'package:expense_manager/core/helpers/utils.dart';
import 'package:expense_manager/core/widgets/custom_button.dart';
import 'package:expense_manager/core/widgets/custom_input_field.dart';
import 'package:expense_manager/core/widgets/filling_animation_button.dart';
import 'package:expense_manager/core/widgets/loader.dart';
import 'package:expense_manager/data/models/category/main_category.dart';
import 'package:expense_manager/data/models/category/sub_category.dart';
import 'package:expense_manager/data/models/transactions/user_transaction.dart';
import 'package:expense_manager/features/dashboard/providers/pagination_loading_provider.dart';
import 'package:expense_manager/features/dashboard/view/widgets/dashboard_transaction_card.dart';
import 'package:expense_manager/features/dashboard/view/widgets/main_cat_list_view_with_search.dart';
import 'package:expense_manager/features/dashboard/view/widgets/sub_cat_list_view_with_search.dart';
import 'package:expense_manager/features/dashboard/viewmodel/add_expense_viewmodel/add_expense_viewmodel.dart';
import 'package:expense_manager/features/dashboard/viewmodel/daily_summary_graph_viewmodel/daily_summary_graph_viewmodel.dart';
import 'package:expense_manager/features/dashboard/viewmodel/dashboard_sub_category_list_viewmodel/dashboard_sub_category_list_viewmodel.dart';
import 'package:expense_manager/features/dashboard/viewmodel/monthly_summary_viewmodel/monthly_summary_viewmodel.dart';
import 'package:expense_manager/features/dashboard/viewmodel/transactions_list_viewmodel/transactions_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';

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
  SubCategory? selectedSubCat;
  MainCategory? selectedCat;
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
  bool showDeleteTrxnonTapMessage = false;

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

  Future<Map<String, dynamic>?> _showEditExpenseBottomSheet(
    String buttonLabel,
    UserTransaction? transaction,
  ) async {
    if (transaction == null) {
      return null;
    }
    expenseAmountController.setText(
      TransactionHelpers.getAmountFromDbAmount(transaction.amount).toString(),
    );
    expenseTitleController.setText(
      transaction.recipientName,
    );
    setState(() {
      selectedSubCat = transaction.subCategory;
    });
    final result = await showModalBottomSheet<Map<String, dynamic>?>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      // constraints: BoxConstraints(maxHeight: 300),
      enableDrag: true,
      showDragHandle: false,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(builder: (context, state) {
          return Consumer(
            builder: (context, ref, _) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ColorsConfig.bgColor1.withValues(alpha: 0.9),
                          border: Border(
                            top: BorderSide(
                              color: ColorsConfig.color4,
                              width: 1,
                            ),
                          ),
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            // Text(
                            //   "Add Expense",
                            //   style: Theme.of(context).textTheme.headlineSmall,
                            // ),
                            SizedBox(height: 12),
                            CustomInputField(
                              enabled: !showAddExpenseLoading,
                              hintText: 'Amount',
                              controller: expenseAmountController,
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              autoFocus: true,
                              prefixIcon: Icon(
                                size: 30,
                                Icons.currency_rupee,
                                color: Colors.white,
                              ),
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                            ),
                            SizedBox(height: 12),
                            CustomInputField(
                              enabled: !showAddExpenseLoading,
                              hintText: 'Title',
                              controller: expenseTitleController,
                              maxLength: 300,
                              keyboardType: TextInputType.text,
                              prefixIcon: Icon(
                                size: 30,
                                Icons.abc,
                                color: Colors.white,
                              ),
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                            ),
                            SizedBox(height: 12),
                            GestureDetector(
                              onTap: showAddExpenseLoading
                                  ? null
                                  : () async {
                                      final val = await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            SubCatListViewWithSearch(
                                          createButtonOnTap: () async {
                                            final res =
                                                await _showCreateSubCatBottomSheet();
                                            if (res != null) {
                                              ref
                                                  .read(
                                                      dashboardSubCategoryListViewModelProvider
                                                          .notifier)
                                                  .addSubCategoryToList(res);
                                            }
                                          },
                                          createButtonText: 'Create',
                                          showCreateButton: true,
                                          searchHintText: 'Search Category',
                                        ),
                                        fullscreenDialog: true,
                                      ));
                                      if (val != null) {
                                        state(() {
                                          selectedSubCat = val;
                                        });

                                        setState(() {
                                          selectedSubCat = val;
                                        });
                                      }
                                    },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: ColorsConfig.bgColor2,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      selectedSubCat == null
                                          ? "Add Category"
                                          : selectedSubCat!.name,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    Icon(
                                      Icons.playlist_add_rounded,
                                      color: ColorsConfig.textColor4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 30),

                            // add or edit transaction button in modal
                            CustomButton(
                              isDisabled: false,
                              buttonText: buttonLabel,
                              isLoading: showAddExpenseLoading,
                              onPressed: () async {
                                if (transaction.id == null) {
                                  // TODO: DO SOMETHING TO SHOW SOME ERROR OCCURED
                                  return;
                                }
                                state(() {
                                  showAddExpenseLoading = true;
                                });
                                setState(() {
                                  showAddExpenseLoading = true;
                                });

                                final result = await ref
                                    .read(addExpenseViewModelProvider.notifier)
                                    .edit(
                                      transaction.id!,
                                      expenseAmountController.text,
                                      expenseTitleController.text,
                                      selectedSubCat,
                                      transaction.transactionDatetime,
                                    );

                                state(() {
                                  showAddExpenseLoading = false;
                                });
                                setState(() {
                                  showAddExpenseLoading = false;
                                });

                                result.fold((error) {
                                  log(error.message);
                                  // TODO: DO SOMETHING TO SHOW SOME ERROR OCCURED
                                }, (data) {
                                  Navigator.of(context).pop({
                                    'action': 'edit',
                                    'statusCode': '0',
                                    'data': data.userTransaction.copyWith(
                                      subCategory: selectedSubCat,
                                    )
                                  });
                                });
                              },
                            ),
                            SizedBox(height: 10),

                            // delete transaction button in modal
                            AnimatedLongPressButton(
                              text: 'Delete Transaction',
                              onLongPress: () async {
                                if (transaction.id == null) {
                                  // TODO: DO SOMETHING TO SHOW SOME ERROR OCCURED
                                  return;
                                }

                                state(() {
                                  isDeleteButtonLoading = true;
                                });

                                await AppUtils.delay(3000);

                                final result = await ref
                                    .read(addExpenseViewModelProvider.notifier)
                                    .delete(transaction.id!);

                                state(() {
                                  isDeleteButtonLoading = false;
                                });

                                result.fold((error) {
                                  log(error.message);
                                  // TODO: DO SOMETHING TO SHOW SOME ERROR OCCURED
                                  // some error occured
                                }, (data) {
                                  Navigator.of(context).pop({
                                    'action': 'delete',
                                    'statusCode': '0',
                                    'data': transaction.id,
                                  });
                                  // TODO: DO SOMETHING TO SHOW TRANSACTION deleted
                                });
                              },
                              onTap: () async {
                                state(() {
                                  showDeleteTrxnonTapMessage = true;
                                });

                                await AppUtils.delay(1000);

                                state(() {
                                  showDeleteTrxnonTapMessage = false;
                                });
                              },
                              height: 53,
                              backgroundColor: ColorsConfig.color8,
                              animatedColor: ColorsConfig.color8,
                              isLoading: isDeleteButtonLoading,
                            ),

                            // BOTTOM MARGIN
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Backdrop with Close Button
                  Positioned(
                    top: -50,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 35,
                        height: 35,
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: ColorsConfig.bgColor2,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // Show message to long press to delete transaction
                  if (showDeleteTrxnonTapMessage)
                    Positioned(
                      top: 170,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorsConfig.bgColor1,
                          border: Border.all(
                            color: ColorsConfig.color4,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(9),
                        child: Text('Long press to delete transaction',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  color: ColorsConfig.textColor3,
                                )),
                      ),
                    ),
                ],
              );
            },
          );
        });
      },
    );

    _resetAddTransactionFormBottomSheet();

    if (result == null) {
      return result;
    }

    switch (result['action']) {
      case 'edit':
        await ref
            .read(transactionsListViewModelProvider.notifier)
            .editTransaction(result['data']);

        await ref
            .read(monthlySummaryViewModelProvider.notifier)
            .editTransaction(result['data'], transaction);

        await ref
            .read(dailySummaryGraphViewModelProvider.notifier)
            .editTransaction(result['data'], transaction);

        break;
      case 'delete':
        await ref
            .read(transactionsListViewModelProvider.notifier)
            .removeTransaction(result['data']);

        await ref
            .read(monthlySummaryViewModelProvider.notifier)
            .removeTransaction(transaction);

        await ref
            .read(dailySummaryGraphViewModelProvider.notifier)
            .removeTransaction(transaction);
        break;
      default:
      // TODO: DO SOMETHING TO TELL SOME ERROR OCCURED
    }

    return result;
  }

  Future<SubCategory?> _showCreateSubCatBottomSheet() async {
    final result = await showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: true,
      useSafeArea: true,
      // constraints: BoxConstraints(maxHeight: 300),
      enableDrag: true,
      showDragHandle: false,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(builder: (context, state) {
          return Consumer(
            builder: (ctx, ref, _) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ColorsConfig.bgColor1.withValues(alpha: 0.9),
                          border: Border(
                            top: BorderSide(
                              color: ColorsConfig.color4,
                              width: 1,
                            ),
                          ),
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomInputField(
                              hintText: 'Name',
                              controller: newSubCatNameController,
                              keyboardType: TextInputType.text,
                              prefixIcon: Icon(
                                size: 30,
                                Icons.title,
                                color: Colors.white,
                              ),
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                            ),
                            SizedBox(height: 12),
                            CustomInputField(
                              hintText: 'Description',
                              controller: newSubCatDescController,
                              maxLength: 300,
                              keyboardType: TextInputType.text,
                              prefixIcon: Icon(
                                size: 30,
                                Icons.description,
                                color: Colors.white,
                              ),
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                            ),
                            SizedBox(height: 12),
                            GestureDetector(
                              onTap: () async {
                                final val = await Navigator.of(ctx)
                                    .push(MaterialPageRoute(
                                  builder: (context) =>
                                      MainCatListViewWithSearch(
                                    showCreateButton: false,
                                    createButtonOnTap: () {},
                                    createButtonText: '',
                                    searchHintText: 'Search Category',
                                  ),
                                  fullscreenDialog: true,
                                ));

                                if (val != null) {
                                  state(() {
                                    selectedCat = val;
                                  });

                                  setState(() {
                                    selectedCat = val;
                                  });
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: ColorsConfig.bgColor2,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      selectedCat == null
                                          ? "Add Main Category"
                                          : selectedCat!.name,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    Icon(
                                      Icons.playlist_add_rounded,
                                      color: ColorsConfig.textColor4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            CustomButton(
                              isDisabled: false,
                              buttonText: 'Create',
                              isLoading: false,
                              onPressed: () async {
                                if (newSubCatDescController.text.isEmpty ||
                                    newSubCatNameController.text.isEmpty ||
                                    selectedCat == null) {
                                  return;
                                }
                                final res = await ref
                                    .read(
                                        dashboardSubCategoryListViewModelProvider
                                            .notifier)
                                    .create(
                                      categoryId: selectedCat!.id,
                                      description: newSubCatDescController.text,
                                      name: newSubCatNameController.text,
                                    );

                                res.fold((error) {
                                  // AppUtils.showSnackBar(
                                  //   context,
                                  //   error.message,
                                  // );
                                }, (subCat) {
                                  Navigator.of(context).pop(subCat);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Backdrop with Close Button
                  Positioned(
                    top: -50,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 35,
                        height: 35,
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: ColorsConfig.bgColor2,
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                        ),
                        child: IconButton(
                          icon:
                              Icon(Icons.close, size: 20, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        });
      },
    );

    _resetCreateCategoryFormBottomSheet();

    return result;
  }

  void _resetCreateCategoryFormBottomSheet() {
    newSubCatNameController.clear();
    newSubCatDescController.clear();
    setState(() {
      selectedCat = null;
    });
  }

  void _resetAddTransactionFormBottomSheet() {
    expenseAmountController.clear();
    expenseTitleController.clear();
    searchSubCategoryController.clear();
    setState(() {
      selectedSubCat = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncTxns = ref.watch(transactionsListViewModelProvider);

    final isLoading = ref.watch(paginationLoadingProvider);
    final callback = ref.watch(transactionDetailsCallbackProvider);

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
                                        _showEditExpenseBottomSheet,
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
