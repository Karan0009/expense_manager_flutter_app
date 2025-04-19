import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:expense_manager/core/helpers/utils.dart';
import 'package:expense_manager/core/widgets/custom_button.dart';
import 'package:expense_manager/core/widgets/custom_input_field.dart';
import 'package:expense_manager/features/dashboard/view/widgets/daily_summary_graph_card.dart';
import 'package:expense_manager/features/dashboard/view/widgets/expenses_summary_card.dart';
import 'package:expense_manager/features/dashboard/view/widgets/dashboard_uncategorized_transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CustomScrollView(
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
            child: ExpensesSummaryCard(),
          ),
          SliverToBoxAdapter(
            child: const SizedBox(
              height: 10,
            ),
          ),
          SliverToBoxAdapter(
            child: DailySummaryGraphCard(),
          ),
          SliverToBoxAdapter(
            child: const SizedBox(
              height: 10,
            ),
          ),
          DashboardUncategorizedTransactionsList(),
          SliverToBoxAdapter(
            child: SizedBox(
              height: AppUtils.getNavbarHeight(context) * 2,
            ),
          ),
        ],
      ),
      Positioned(
        bottom: AppUtils.getNavbarHeight(context) + 10,
        left: (MediaQuery.of(context).size.width / 2) - 100,
        child: CustomButton(
          onPressed: () {
            _showAddExpenseBottomSheet(
              context,
              'Add Expense',
              expenseAmountController,
              expenseTitleController,
              searchSubCategoryController,
            );
          },
          isLoading: false,
          buttonText: 'Add Expense',
          prefixIcon: Icon(Icons.add_rounded),
          containerHeight: 30,
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
    ]);
  }
}

void _showAddExpenseBottomSheet(
  BuildContext context,
  String buttonLabel,
  TextEditingController? expenseAmountController,
  TextEditingController? expenseTitleController,
  TextEditingController? searchSubCategoryController,
) {
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    isDismissible: true,
    useSafeArea: true,
    constraints: BoxConstraints(maxHeight: 300),
    enableDrag: true,
    showDragHandle: false,
    barrierColor: Colors.black.withValues(alpha: 0.7), // Darkens backdrop
    backgroundColor: Colors.transparent, // Make modal container transparent
    builder: (context) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
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
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                  hintText: 'Amount',
                  controller: expenseAmountController,
                  keyboardType: TextInputType.number,
                  prefixIcon: Center(
                    heightFactor: 0.5,
                    widthFactor: 0,
                    child: Container(
                      height: 25,
                      width: 25,
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.only(bottom: 7),
                      decoration: BoxDecoration(
                        color: ColorsConfig.color1,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(
                        size: 15,
                        Icons.currency_rupee,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                CustomInputField(
                  hintText: 'Title',
                  controller: expenseTitleController,
                  maxLength: 300,
                  keyboardType: TextInputType.text,
                  prefixIcon: Center(
                    heightFactor: 0.5,
                    widthFactor: 0,
                    child: Container(
                      height: 25,
                      width: 25,
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.only(bottom: 7),
                      decoration: BoxDecoration(
                        color: ColorsConfig.color1,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(
                        size: 15,
                        Icons.phone_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    _showSelectCategoryBottomSheet(
                      context,
                      searchSubCategoryController,
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: ColorsConfig.bgColor2,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Add Category",
                          style: Theme.of(context).textTheme.bodyLarge,
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
                  isDisabled: true,
                  buttonText: buttonLabel,
                  isLoading: false,
                  onPressed: () async {
                    //   final isError = ref
                    //       .read(authViewModelProvider.notifier)
                    //       .validateAuthForm(phoneController.text,
                    //           isTermsAndConditionsAccepted);
                    //   if (isError != null) {
                    //     AppUtils.showSnackBar(context, isError);
                    //     return;
                    //   }

                    //   final result = await ref
                    //       .read(authViewModelProvider.notifier)
                    //       .getOtp(
                    //         phoneController.text,
                    //         isTermsAndConditionsAccepted,
                    //       );

                    //   result.fold((l) {
                    //     AppUtils.showSnackBar(
                    //         context, 'Some error occured');
                    //   }, (otp) {
                    //     context
                    //         .pushReplacement(EnterOtpPageView.routePath);
                    //   });
                  },
                ),
              ],
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
                  icon: Icon(Icons.close, size: 20, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

void _showSelectCategoryBottomSheet(
  BuildContext context,
  TextEditingController? searchSubCategoryController,
) {
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    isDismissible: true,
    useSafeArea: true,
    enableDrag: true,
    showDragHandle: false,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.9,
    ),
    barrierColor: Colors.black.withValues(alpha: 0.7), // Darkens backdrop
    backgroundColor: Colors.transparent, // Make modal container transparent
    builder: (context) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
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
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                  hintText: 'Search Category',
                  controller: searchSubCategoryController,
                  keyboardType: TextInputType.text,
                  prefixIcon: Icon(
                    size: 25,
                    Icons.search,
                    color: ColorsConfig.color2,
                  ),
                ),
                SizedBox(height: 30),
                CustomButton(
                  isDisabled: true,
                  buttonText: 'Create Category',
                  isLoading: false,
                  onPressed: () async {},
                ),
              ],
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
                  icon: Icon(Icons.close, size: 20, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
