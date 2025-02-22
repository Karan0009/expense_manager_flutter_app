import 'package:expense_manager/config/colors_config.dart';
import 'package:expense_manager/screens/expenses_dashboard_page/controller/expenses_dashboard_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpensesDashboardPageView extends ConsumerWidget {
  static const String routePath = '/expenses-dashboard';
  const ExpensesDashboardPageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(expensesDashboardPageViewModelProvider);
    // final viewModel = ref.read(expensesDashboardPageViewModelProvider.notifier);
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight,
                maxWidth: constraints.maxWidth,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16.0 : constraints.maxWidth * 0.2,
                ),
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
                              style: TextStyle(
                                fontFamily:
                                    GoogleFonts.instrumentSerif().fontFamily,
                                fontSize: 40,
                                fontWeight: FontWeight.w400,
                                color: ColorsConfig.textColor2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Your expenses will be automatically added.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: GoogleFonts.inter().fontFamily,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: ColorsConfig.textColor2
                                    .withValues(alpha: 0.75),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 16.0, left: 4, right: 4),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => {},
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            backgroundColor: ColorsConfig.color2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: state.isLoading
                              ? Container(
                                  color: Colors.transparent,
                                  width: 30,
                                  height: 30,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: ColorsConfig.textColor2,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Add Manually',
                                  style: TextStyle(
                                    color: ColorsConfig.textColor2,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: GoogleFonts.inter().fontFamily,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
