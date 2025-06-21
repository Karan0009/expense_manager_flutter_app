import 'dart:developer';

import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:expense_manager/core/helpers/transaction_helpers.dart';
import 'package:expense_manager/core/helpers/utils.dart';
import 'package:expense_manager/core/widgets/custom_button.dart';
import 'package:expense_manager/core/widgets/custom_input_field.dart';
import 'package:expense_manager/core/widgets/filling_animation_button.dart';
import 'package:expense_manager/core/widgets/skeleton_loader.dart';
import 'package:expense_manager/data/models/category/main_category.dart';
import 'package:expense_manager/data/models/category/sub_category.dart';
import 'package:expense_manager/data/models/transactions/user_transaction.dart';
import 'package:expense_manager/features/dashboard/view/widgets/daily_summary_graph_card.dart';
import 'package:expense_manager/features/dashboard/view/widgets/expenses_summary_card.dart';
import 'package:expense_manager/features/dashboard/view/widgets/dashboard_uncategorized_transactions_list.dart';
import 'package:expense_manager/features/dashboard/view/widgets/main_cat_list_view_with_search.dart';
import 'package:expense_manager/features/dashboard/view/widgets/sub_cat_list_view_with_search.dart';
import 'package:expense_manager/features/dashboard/viewmodel/add_expense_viewmodel/add_expense_viewmodel.dart';
import 'package:expense_manager/features/dashboard/viewmodel/daily_summary_graph_viewmodel/daily_summary_graph_viewmodel.dart';
import 'package:expense_manager/features/dashboard/viewmodel/dashboard_sub_category_list_viewmodel/dashboard_sub_category_list_viewmodel.dart';
import 'package:expense_manager/features/dashboard/viewmodel/dashboard_uncategorized_transactions_list_viewmodel/dashboard_uncategorized_transactions_list_viewmodel.dart';

import 'package:expense_manager/features/dashboard/viewmodel/monthly_summary_viewmodel/monthly_summary_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class WithTransactionsDashboardView extends ConsumerStatefulWidget {
  const WithTransactionsDashboardView({super.key});

  @override
  ConsumerState<WithTransactionsDashboardView> createState() =>
      _WithTransactionsDashboardViewState();
}

class _WithTransactionsDashboardViewState
    extends ConsumerState<WithTransactionsDashboardView> {
  final expenseTitleController = TextEditingController();
  final expenseAmountController = TextEditingController();
  final searchSubCategoryController = TextEditingController();
  final searchCategoryController = TextEditingController();

  final newSubCatNameController = TextEditingController();
  final newSubCatDescController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  SubCategory? selectedSubCat;
  MainCategory? selectedCat;

  bool showAddExpenseLoading = false;
  bool isDeleteButtonLoading = false;
  bool isEditButtonLoading = false;
  bool isUncategorizedTransactionsListLoading = false;
  bool showScrollToTopButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() async {
      // print(
      //     "clients: ${_scrollController.hasClients}, Scroll position: ${_scrollController.position.pixels}, Max Scroll Extent: ${_scrollController.position.maxScrollExtent}, screen height: ${MediaQuery.of(context).size.height} ,should show up ${_scrollController.position.pixels > MediaQuery.of(context).size.height}");
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          isUncategorizedTransactionsListLoading = true;
        });

        await ref
            .read(dashboardUncategorizedTransactionsListViewModelProvider
                .notifier)
            .loadMoreTransactions();

        setState(() {
          isUncategorizedTransactionsListLoading = false;
        });

        print(
            "isUncategorizedTransactionsListLoading: $isUncategorizedTransactionsListLoading");
      }

      if (context.mounted &&
          _scrollController.hasClients &&
          _scrollController.position.pixels >
              MediaQuery.of(context).size.height) {
        setState(() {
          showScrollToTopButton = true;
        });
      } else {
        setState(() {
          showScrollToTopButton = false;
        });
      }
    });
  }

  @override
  void dispose() {
    expenseTitleController.dispose();
    expenseAmountController.dispose();
    searchSubCategoryController.dispose();
    newSubCatNameController.dispose();
    newSubCatDescController.dispose();
    searchCategoryController.dispose();
    _scrollController.dispose();
    super.dispose();
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
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter state) {
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
                                          createButtonText: 'Create Category',
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
                            CustomButton(
                              isDisabled: false,
                              buttonText: buttonLabel,
                              isLoading: showAddExpenseLoading,
                              onPressed: () async {
                                setState(() {
                                  showAddExpenseLoading = true;
                                });

                                if (transaction.id == null) {
                                  // TODO: DO SOMETHING TO SHOW SOME ERROR OCCURED
                                  return;
                                }

                                final result = await ref
                                    .read(addExpenseViewModelProvider.notifier)
                                    .edit(
                                      transaction.id!,
                                      expenseAmountController.text,
                                      expenseTitleController.text,
                                      selectedSubCat,
                                      transaction.transactionDatetime,
                                    );

                                setState(() {
                                  showAddExpenseLoading = false;
                                });
                                // todo: hide loading

                                result.fold((error) {
                                  log(error.message);
                                  // TODO: DO SOMETHING TO SHOW SOME ERROR OCCURED
                                  // some error occured
                                }, (data) {
                                  Navigator.of(context).pop({
                                    'action': 'edit',
                                    'statusCode': '0',
                                    'data': data.userTransaction.copyWith(
                                      subCategory: selectedSubCat,
                                    )
                                  });
                                  // TODO: DO SOMETHING TO SHOW TRANSACTION ADDED
                                });
                                // ref.read()
                              },
                            ),
                            SizedBox(height: 10),
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
                              onTap: () {
                                // Handle tap
                              },
                              height: 53,
                              backgroundColor: ColorsConfig.color8,
                              animatedColor: ColorsConfig.color8,
                              isLoading: isDeleteButtonLoading,
                            ),
                            SizedBox(height: 10),
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
            .read(dashboardUncategorizedTransactionsListViewModelProvider
                .notifier)
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
            .read(dashboardUncategorizedTransactionsListViewModelProvider
                .notifier)
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

  Future<UserTransaction?> _showAddExpenseBottomSheet(
    String buttonLabel,
  ) async {
    final result = await showModalBottomSheet<UserTransaction?>(
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
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter state) {
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
                                          createButtonText: 'Create Category',
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
                            CustomButton(
                              isDisabled: false,
                              buttonText: buttonLabel,
                              isLoading: showAddExpenseLoading,
                              onPressed: () async {
                                state(() {
                                  showAddExpenseLoading = true;
                                });

                                final result = await ref
                                    .read(addExpenseViewModelProvider.notifier)
                                    .create(
                                      expenseAmountController.text,
                                      expenseTitleController.text,
                                      selectedSubCat,
                                      DateTime.now(),
                                    );

                                state(() {
                                  showAddExpenseLoading = false;
                                });
                                // todo: hide loading

                                result.fold((error) {
                                  log(error.message);
                                  // TODO: DO SOMETHING TO SHOW SOME ERROR OCCURED
                                  // some error occured
                                }, (data) {
                                  Navigator.of(context)
                                      .pop(data.userTransaction.copyWith(
                                    subCategory: selectedSubCat,
                                  ));
                                  // TODO: DO SOMETHING TO SHOW TRANSACTION ADDED
                                });
                                // ref.read()
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
                ],
              );
            },
          );
        });
      },
    );

    _resetAddTransactionFormBottomSheet();

    return result;
  }

  void _resetAddTransactionFormBottomSheet() {
    expenseAmountController.clear();
    expenseTitleController.clear();
    searchSubCategoryController.clear();
    setState(() {
      selectedSubCat = null;
    });
  }

  void _resetCreateCategoryFormBottomSheet() {
    newSubCatNameController.clear();
    newSubCatDescController.clear();
    setState(() {
      selectedCat = null;
    });
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

  Widget cardLoader(BuildContext context) {
    return SkeletonLoader(
      width: double.infinity,
      height: 220,
      baseColor: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      highlightColor: Theme.of(context).cardColor.withValues(
            alpha: 2.5,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      RefreshIndicator(
        onRefresh: () async {
          await ref.read(monthlySummaryViewModelProvider.notifier).refresh();
          await ref.read(dailySummaryGraphViewModelProvider.notifier).refresh();
          await ref
              .read(dashboardUncategorizedTransactionsListViewModelProvider
                  .notifier)
              .refresh();
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Your Expenses',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            ),
            SliverToBoxAdapter(
              child: ref.watch(monthlySummaryViewModelProvider).when(
                    data: (data) {
                      return ExpensesSummaryCard();
                    },
                    error: (error, stackTrace) => FittedBox(
                      child: Text(
                        "Err",
                        textHeightBehavior: TextHeightBehavior(
                          applyHeightToFirstAscent: false,
                          applyHeightToLastDescent: false,
                        ),
                        style: TextStyle(
                          fontSize: 29,
                          color: ColorsConfig.textColor4,
                          fontFamily: GoogleFonts.inter().fontFamily,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    loading: () => cardLoader(context),
                  ),
            ),
            SliverToBoxAdapter(
              child: const SizedBox(
                height: 10,
              ),
            ),
            SliverToBoxAdapter(
              child: ref.watch(dailySummaryGraphViewModelProvider).when(
                    data: (data) => DailySummaryGraphCard(),
                    error: (error, _) => Text(
                      'Error loading data',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    loading: () => cardLoader(context),
                  ),
            ),
            SliverToBoxAdapter(
              child: const SizedBox(
                height: 10,
              ),
            ),
            DashboardUncategorizedTransactionsList(
              isLoading: isUncategorizedTransactionsListLoading,
              showTransactionDetailsBottomSheet: _showEditExpenseBottomSheet,
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: AppUtils.getNavbarHeight(context) * 2,
              ),
            ),
          ],
        ),
      ),
      Positioned(
        bottom: AppUtils.getNavbarHeight(context) + 10,
        left: (MediaQuery.of(context).size.width / 2) - 100,
        child: CustomButton(
          onPressed: () async {
            final newTransaction = await _showAddExpenseBottomSheet(
              'Add Expense',
            );

            if (newTransaction != null) {
              await ref
                  .read(dashboardUncategorizedTransactionsListViewModelProvider
                      .notifier)
                  .addNewTransaction(newTransaction);

              await ref
                  .read(monthlySummaryViewModelProvider.notifier)
                  .addNewTransaction(newTransaction);

              await ref
                  .read(dailySummaryGraphViewModelProvider.notifier)
                  .addNewTransaction(newTransaction);
            }
          },
          isLoading: false,
          buttonText: 'Add Expense',
          prefixIcon: Icon(Icons.add_rounded),
          containerHeight: 50,
          containerWidth: 162,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(0),
            backgroundColor: ColorsConfig.bgColor1.withValues(alpha: 0.9),
            textStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: ColorsConfig.color4,
                  fontWeight: FontWeight.w600,
                ),
          ),
          containerPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          containerStyle: BoxDecoration(
            color: ColorsConfig.bgColor1,
            border: Border.all(
              color: ColorsConfig.color4,
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      // Scroll to top button

      Positioned(
        bottom: AppUtils.getNavbarHeight(context) + 10,
        left: MediaQuery.of(context).size.width - 80,
        child: showScrollToTopButton
            ? IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: ColorsConfig.bgColor1.withValues(alpha: 0.5),
                  padding: EdgeInsets.all(10),
                  shape: CircleBorder(),
                ),
                onPressed: () async {
                  await _scrollController.animateTo(
                    0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                icon: const Icon(
                  Icons.arrow_upward_rounded,
                  size: 24,
                  color: ColorsConfig.textColor3,
                ),
              )
            : SizedBox.shrink(),
      ),
    ]);
  }
}
