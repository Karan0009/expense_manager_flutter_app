import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:expense_manager/core/helpers/transaction_helpers.dart';
import 'package:expense_manager/core/widgets/skeleton_loader.dart';
import 'package:expense_manager/features/dashboard/view/widgets/expenses_carousel.dart';
import 'package:expense_manager/features/dashboard/viewmodel/monthly_summary_viewmodel/monthly_summary_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ExpensesSummaryCard extends ConsumerWidget {
  const ExpensesSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maxWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorsConfig.color5,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            offset: Offset(0, 4),
            blurRadius: 5,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ref.watch(monthlySummaryViewModelProvider).when(
                    data: (data) => data != null
                        ? Text(
                            "SPENT IN ${DateFormat('MMMM').format(DateTime.parse(data.categorySummarizedTransactions[0].summaryStart)).toUpperCase()}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.w500, fontSize: 9),
                          )
                        : SizedBox.shrink(),
                    error: (error, _) => Text(
                      "SPENT IN Err",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.w500, fontSize: 9),
                    ),
                    loading: () => SizedBox.shrink(),
                  ),

              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: maxWidth,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ref.watch(monthlySummaryViewModelProvider).when(
                          data: (data) => FittedBox(
                            child: Text(
                              data != null
                                  ? TransactionHelpers.formatStringAmount(
                                      data.totalSummarizedAmount.toString())
                                  : "₹0.00",
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
                          error: (error, _) => FittedBox(
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
                          loading: () => SkeletonLoader(
                            width: 80,
                            height: 40,
                          ),
                        ),

                    const SizedBox(width: 8),
                    // TODO: UNCOMMENT AFTER ADDING BUDGET THINGS
                    // FittedBox(
                    //   child: Text(
                    //     "out of ₹99,999",
                    //     textHeightBehavior: TextHeightBehavior(
                    //       applyHeightToFirstAscent: true,
                    //       applyHeightToLastDescent: true,
                    //     ),
                    //     style: TextStyle(
                    //       fontSize: 14,
                    //       color: ColorsConfig.textColor1,
                    //       fontFamily: GoogleFonts.inter().fontFamily,
                    //       fontWeight: FontWeight.w400,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // TODO: UNCOMMENT AFTER ADDING BUDGET THINGS
              // LinearProgressIndicator(
              //   borderRadius: BorderRadius.circular(20),
              //   value: 0.5,
              //   backgroundColor: ColorsConfig.color1,
              //   valueColor: AlwaysStoppedAnimation<Color>(
              //     ColorsConfig.textColor2,
              //   ),
              //   minHeight: 5,
              // ),
              const SizedBox(height: 8),
              ExpensesCarousel()
            ],
          ),
        ],
      ),
    );
  }
}
