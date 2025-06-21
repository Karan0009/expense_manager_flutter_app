import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:expense_manager/core/layouts/above_navbar_layout.dart';
import 'package:expense_manager/core/widgets/custom_button.dart';
import 'package:expense_manager/core/widgets/custom_input_field.dart';
import 'package:expense_manager/data/models/category/sub_category.dart';
import 'package:expense_manager/data/models/transactions/user_transaction.dart';
import 'package:expense_manager/features/dashboard/view/dashboard_page_view.dart';
import 'package:expense_manager/features/dashboard/view/widgets/main_cat_list_view_with_search.dart';
import 'package:expense_manager/features/dashboard/view/widgets/sub_cat_list_view_with_search.dart';
import 'package:expense_manager/features/dashboard/viewmodel/add_expense_viewmodel/add_expense_viewmodel.dart';
import 'package:expense_manager/features/dashboard/viewmodel/dashboard_sub_category_list_viewmodel/dashboard_sub_category_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NoTransactionsWidget extends ConsumerStatefulWidget {
  const NoTransactionsWidget({super.key});

  @override
  ConsumerState<NoTransactionsWidget> createState() =>
      _NoTransactionsWidgetState();
}

class _NoTransactionsWidgetState extends ConsumerState<NoTransactionsWidget> {
  final expenseAmountController = TextEditingController();
  final expenseTitleController = TextEditingController();
  final searchSubCategoryController = TextEditingController();
  final newSubCatNameController = TextEditingController();
  final newSubCatDescController = TextEditingController();
  SubCategory? selectedSubCat;
  SubCategory? selectedCat;
  bool showAddExpenseLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    expenseAmountController.dispose();
    expenseTitleController.dispose();
    searchSubCategoryController.dispose();
    newSubCatNameController.dispose();
    newSubCatDescController.dispose();
    selectedSubCat = null;
    selectedCat = null;
    showAddExpenseLoading = false;
    super.dispose();
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
                                  // log(error.message);
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

    _navigateToWithTransactionsView();
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

  void _navigateToWithTransactionsView() {
    context.pushReplacement(DashboardPageView.routePath);
  }

  @override
  Widget build(BuildContext context) {
    return AboveNavbarLayout(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    child: Image.asset(
                      'assets/images/piggy_empty_state_1.png',
                      width: 300,
                      height: 300,
                    ),
                  ),
                  Text(
                    'No Expense Added',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your expenses will be automatically added.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w400,
                          color:
                              ColorsConfig.textColor2.withValues(alpha: 0.75),
                        ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0, left: 4, right: 4),
            child: SizedBox(
              width: double.infinity,
              child: CustomButton(
                  onPressed: () => _showAddExpenseBottomSheet('Add Expense'),
                  isLoading: false,
                  buttonText: 'Add Manually'),
            ),
          ),
        ],
      ),
    );
  }
}
