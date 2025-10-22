import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:expense_manager/core/helpers/transaction_helpers.dart';
import 'package:expense_manager/features/dashboard/view/widgets/expenses_carousel.dart';
import 'package:expense_manager/features/dashboard/viewmodel/monthly_summary_viewmodel/monthly_summary_viewmodel.dart';
import 'package:expense_manager/globals/components/animated_icon_tap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ExpensesSummaryCard extends ConsumerWidget {
  const ExpensesSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("ExpensesSummaryCard build called");
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
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedIconTap(
                    icon: Icons.arrow_back_ios,
                    onTap: () async {
                      await ref
                          .read(monthlySummaryViewModelProvider.notifier)
                          .getPreviousMonthSummary();
                    },
                    splashColor: ColorsConfig.textColor3.withValues(alpha: 0.1),
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.only(left: 3),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  ref.watch(monthlySummaryViewModelProvider).whenData<Widget>(
                        (value) {
                          return value != null
                              ? Text(
                                  "SPENT IN ${DateFormat('MMMM').format(value.selectedMonth).toUpperCase()}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 9),
                                )
                              : SizedBox.shrink();
                        },
                      ).value ??
                      SizedBox.shrink(),

                  SizedBox(
                    width: 8,
                  ),
                  // Arrow to change to next week
                  AnimatedIconTap(
                    icon: Icons.arrow_forward_ios,
                    onTap: () async {
                      // TODO: FIX THIS THINGY
                      DateTime now = DateTime.now();
                      if (now.month ==
                              ref
                                  .read(monthlySummaryViewModelProvider)
                                  .value
                                  ?.selectedMonth
                                  .month &&
                          now.year ==
                              ref
                                  .read(monthlySummaryViewModelProvider)
                                  .value
                                  ?.selectedMonth
                                  .year) {
                        // Current month is the same as the selected month, do not go to next month
                        return;
                      }

                      // validation for next month

                      // DateTime last = DateTime(widget.dateRange.last.year,
                      //     widget.dateRange.last.month, widget.dateRange.last.day);

                      // DateTime isNextWeekCurrentWeek =
                      //     last.add(const Duration(days: 7));
                      // DateTime nextWeekLast = DateTime(isNextWeekCurrentWeek.year,
                      //     isNextWeekCurrentWeek.month, isNextWeekCurrentWeek.day);
                      //   if (today.isAfter(nextWeekLast)) {
                      //     setState(() {
                      //       isCurrentWeek = false;
                      //     });
                      //   }
                      // if (!today.isAfter(last)) {
                      //   return;
                      // }
                      await ref
                          .read(monthlySummaryViewModelProvider.notifier)
                          .getNextMonthSummary();
                    },
                    splashColor: ColorsConfig.textColor3.withValues(alpha: 0.1),
                    padding: const EdgeInsets.all(4),
                  ),
                ],
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
                    ref
                            .watch(monthlySummaryViewModelProvider)
                            .whenData((value) {
                          return FittedBox(
                            child: Text(
                              value != null
                                  ? TransactionHelpers.formatStringAmount(
                                      value.totalSummarizedAmount.toString())
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
                          );
                        }).value ??
                        SizedBox.shrink(),

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
