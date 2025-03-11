import 'dart:math';

import 'package:expense_manager/config/app_config.dart';
import 'package:expense_manager/config/colors_config.dart';
import 'package:expense_manager/data/providers/transactions_provider.dart';
import 'package:expense_manager/globals/services/utils.dart';
import 'package:expense_manager/screens/expenses_dashboard_page/controller/expenses_dashboard_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

/// graph code start

class BarChartSample5 extends StatefulWidget {
  const BarChartSample5({super.key});

  @override
  State<StatefulWidget> createState() => BarChartSample5State();
}

class BarChartSample5State extends State<BarChartSample5> {
  static const double barWidth = 29;
  static const shadowOpacity = 0.2;
  static const mainItems = <int, List<double>>{
    0: [1200],
    1: [2090],
    2: [100],
    3: [1000],
    4: [1800],
    5: [0],
    6: [1000],
  };
  static int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.white, fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Mon';
        break;
      case 1:
        text = 'Tue';
        break;
      case 2:
        text = 'Wed';
        break;
      case 3:
        text = 'Thu';
        break;
      case 4:
        text = 'Fri';
        break;
      case 5:
        text = 'Sat';
        break;
      case 6:
        text = 'Sun';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      meta: meta,
      child: Text(text, style: style),
    );
  }

  Widget topTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.white, fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Mon';
        break;
      case 1:
        text = 'Tue';
        break;
      case 2:
        text = 'Wed';
        break;
      case 3:
        text = 'Thu';
        break;
      case 4:
        text = 'Fri';
        break;
      case 5:
        text = 'Sat';
        break;
      case 6:
        text = 'Sun';
        break;
      default:
        return Container();
    }
    return SideTitleWidget(
      meta: meta,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.white, fontSize: 10);
    String text;
    if (value == 0) {
      text = '0';
    } else {
      text = '${value.toInt()}0k';
    }
    return SideTitleWidget(
      angle: Utils.degreeToRadian(value < 0 ? -45 : 45),
      meta: meta,
      space: 4,
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget rightTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.white, fontSize: 10);
    String text;
    if (value <= 0) {
      text = '0';
    } else if (value % 1000 == 0) {
      text = '${(value / 1000).toInt()}k';
    } else {
      text = '${(value / 1000).toInt()}.5k';
    }
    return SideTitleWidget(
      angle: 0,
      meta: meta,
      space: 10,
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  BarChartGroupData generateGroup(
    int x,
    double value,
  ) {
    final isTouched = DateTime.now().weekday - 1 == x;
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      showingTooltipIndicators: isTouched ? [0] : [],
      barRods: [
        BarChartRodData(
          toY: value,
          width: barWidth,
          borderRadius: const BorderRadius.all(
            Radius.circular(6),
          ),
          rodStackItems: [
            BarChartRodStackItem(
              0,
              value,
              ColorsConfig.color2,
            ),
          ],
        ),
      ],
    );
  }

  bool isShadowBar(int rodIndex) => rodIndex == 1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.center,
            maxY: 2000,
            minY: 0,
            baselineY: 0,
            groupsSpace: 12,
            barTouchData: BarTouchData(
              handleBuiltInTouches: false,
              touchTooltipData: BarTouchTooltipData(
                tooltipPadding: const EdgeInsets.all(3), // More padding
                tooltipMargin: 10, // Add some space from bars
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${rod.toY.toInt()}', // Display integer values
                    const TextStyle(
                      color: Colors.white, // Text color
                      fontSize: 14, // Slightly bigger font
                      fontWeight: FontWeight.bold, // Bold text
                    ),
                  );
                },
              ),
              touchCallback: (FlTouchEvent event, barTouchResponse) {
                if (!event.isInterestedForInteractions ||
                    barTouchResponse == null ||
                    barTouchResponse.spot == null) {
                  setState(() {
                    touchedIndex = -1;
                  });
                  return;
                }
                // final rodIndex = barTouchResponse.spot!.touchedRodDataIndex;
                // if (isShadowBar(rodIndex)) {
                //   setState(() {
                //     touchedIndex = -1;
                //   });
                //   return;
                // }
                setState(() {
                  touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                });
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  // reservedSize: 32,
                  // getTitlesWidget: topTitles,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  getTitlesWidget: bottomTitles,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  // getTitlesWidget: leftTitles,
                  // interval: 5,
                  // reservedSize: 42,
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: rightTitles,
                  interval: 500,
                  reservedSize: 42,
                ),
              ),
            ),
            gridData: FlGridData(
              show: false,
              checkToShowHorizontalLine: (value) => value % 1000 == 0,
              getDrawingHorizontalLine: (value) {
                if (value == 0) {
                  return FlLine(
                    color: ColorsConfig.accent.withValues(alpha: 0.1),
                    strokeWidth: 3,
                  );
                }
                return FlLine(
                  color: ColorsConfig.color3.withValues(alpha: 0.05),
                  strokeWidth: 0.8,
                );
              },
            ),
            borderData: FlBorderData(
              show: false,
            ),
            barGroups: mainItems.entries
                .map(
                  (e) => generateGroup(
                    e.key,
                    e.value[0],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class ExpensesWeeklySummaryCard extends StatelessWidget {
  const ExpensesWeeklySummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: ColorsConfig.bgColor2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorsConfig.color5,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorsConfig.bgShadowColor1,
            offset: Offset(0, 4),
            blurRadius: 5,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 200),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BarChartSample5(),
            ],
          ),
        ),
      ),
    );
  }
}

/// graph code end

Color getRandomColor() {
  List<Color> colors = [
    ColorsConfig.lightBgColor1,
    ColorsConfig.lightBgColor2,
    ColorsConfig.lightBgColor3
  ];

  final random = Random();
  int randomIndex = random.nextInt(colors.length);

  return colors[randomIndex];
}

Widget buildGrid() {
  return Container(
    height: 120,
    width: 300,
    decoration: BoxDecoration(
      // color: Colors.yellow, // Background color of grid container
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            children: [
              gridItem(Icons.restaurant, "DINE IN", "₹345"),
              gridItem(Icons.restaurant, "DINE IN", "₹345"),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              gridItem(Icons.restaurant, "DINE IN", "₹345"),
              gridItem(Icons.restaurant, "DINE IN", "₹345"),
            ],
          ),
        ),
      ],
    ),
  );
  // GridView.count(

  //   crossAxisCount: 2,
  //   // crossAxisSpacing: 10,
  //   // mainAxisSpacing: 10,
  //   // shrinkWrap: false, // So it doesn't take infinite height
  //   // physics: NeverScrollableScrollPhysics(), // Prevent nested scroll issues
  //   children: [
  //     _gridItem(Icons.restaurant, "DINE IN", "₹345"),
  //     _gridItem(Icons.local_pizza, "TAKE OUT", "₹0"),
  //     _gridItem(Icons.airplanemode_active, "TRAVEL", "₹0"),
  //     _gridItem(Icons.shopping_bag, "CLOTHES", "₹0"),
  //   ],
  // ));
}

Widget gridItem(IconData icon, String label, String amount) {
  return Container(
    padding: EdgeInsets.all(10),
    // color: Colors.green,
    width: double.infinity,
    height: 60,
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: getRandomColor(),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Icon(icon, size: 20, color: Colors.red),
          ),
        ),
        const SizedBox(width: 15),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: ColorsConfig.textColor5,
                fontSize: 9,
                fontWeight: FontWeight.w500,
                fontFamily: GoogleFonts.inter().fontFamily,
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                color: ColorsConfig.textColor4,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: GoogleFonts.inter().fontFamily,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class ExpensesCarousel extends StatelessWidget {
  const ExpensesCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 120,
        autoPlay: true,
        enlargeCenterPage: false,
        viewportFraction: 1,
      ),
      items: [
        buildGrid(),
        buildGrid(),
        buildGrid(),
      ], // Add multiple grids
    );
  }
}

class ExpensesSummaryCard extends ConsumerWidget {
  const ExpensesSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = {
      "onDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
      "summaryType": AppConfig.summaryTypeDaily
    };
    final summarizedTransactionsAsync =
        ref.watch(summarizedTransactionsProvider(params));
    print(summarizedTransactionsAsync);
    final maxWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: ColorsConfig.bgColor2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorsConfig.color5,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorsConfig.bgShadowColor1,
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
              Text(
                "SPENT IN ${DateFormat('MMMM').format(DateTime.now()).toUpperCase()}",
                style: TextStyle(
                  fontSize: 9,
                  color: ColorsConfig.textColor3,
                  fontFamily: GoogleFonts.inter().fontFamily,
                  fontWeight: FontWeight.w500,
                ),
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
                    FittedBox(
                      child: summarizedTransactionsAsync.when(
                          data: (data) => Text(
                                "₹${9}",
                                textHeightBehavior: TextHeightBehavior(
                                    applyHeightToFirstAscent: false,
                                    applyHeightToLastDescent: false),
                                style: TextStyle(
                                  fontSize: 29,
                                  color: ColorsConfig.textColor4,
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                          error: (error, stack) => Text("Error :$error"),
                          loading: () =>
                              const Center(child: CircularProgressIndicator())),
                    ),
                    const SizedBox(width: 8),
                    // TODO: UNCOMMENT AFTER ADDING BUDGET THINGS
                    // FittedBox(
                    //   child: Text(
                    //     "out of ₹99,999",
                    //     textHeightBehavior: TextHeightBehavior(
                    //         applyHeightToFirstAscent: true,
                    //         applyHeightToLastDescent: true),
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
              LinearProgressIndicator(
                borderRadius: BorderRadius.circular(20),
                value: 0.5,
                backgroundColor: ColorsConfig.color1,
                valueColor: AlwaysStoppedAnimation<Color>(
                  ColorsConfig.textColor2,
                ),
                minHeight: 5,
              ),
              const SizedBox(height: 8),
              // buildGrid(),
              ExpensesCarousel()
            ],
          ),
          // SizedBox(height: 10),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     ExpenseCategory(
          //         icon: Icons.restaurant, label: "DINE IN", amount: "₹345"),
          //     ExpenseCategory(
          //         icon: Icons.fastfood, label: "TAKE OUT", amount: "₹0"),
          //     ExpenseCategory(
          //         icon: Icons.flight, label: "TRAVEL", amount: "₹0"),
          //     ExpenseCategory(
          //         icon: Icons.shopping_bag, label: "CLOTHES", amount: "₹0"),
          //   ],
          // ),
        ],
      ),
    );
  }
}

class ExpenseCategory extends StatelessWidget {
  final IconData icon;
  final String label;
  final String amount;

  const ExpenseCategory(
      {super.key,
      required this.icon,
      required this.label,
      required this.amount});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white70)),
        Text(amount,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class NoTransactionsWidget extends ConsumerWidget {
  const NoTransactionsWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(expensesDashboardPageViewModelProvider);
    return Column(
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
                    fontFamily: GoogleFonts.instrumentSerif().fontFamily,
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
                    color: ColorsConfig.textColor2.withValues(alpha: 0.75),
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
    );
  }
}

class WithTransactionsWidget extends ConsumerWidget {
  const WithTransactionsWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double maxWidth = MediaQuery.of(context).size.width;
    // final state = ref.watch(expensesDashboardPageViewModelProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Expenses',
          style: TextStyle(
            fontFamily: GoogleFonts.instrumentSerif().fontFamily,
            fontSize: 29,
            fontWeight: FontWeight.w400,
            color: ColorsConfig.textColor2,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        // SizedBox(
        //   height: 220,
        //   width: maxWidth,
        //   child: CarouselView(
        //     scrollDirection: Axis.horizontal,
        //     controller: CarouselController(initialItem: 0),
        //     itemExtent: maxWidth,
        //     shrinkExtent: 0,

        //     children: [
        //       ExpensesSummaryCard(),
        ExpensesSummaryCard(),
        const SizedBox(height: 20),
        ExpensesWeeklySummaryCard(),
        const SizedBox(height: 20),
        //   ],
        // ),
        // )
      ],
    );
  }
}

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
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: constraints.maxHeight,
              maxWidth: constraints.maxWidth,
            ),
            child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16.0 : constraints.maxWidth * 0.2,
                ),
                child: SingleChildScrollView(
                  child: state.expenses.isEmpty
                      ? const NoTransactionsWidget()
                      : const WithTransactionsWidget(),
                )),
          ),
        );
      },
    );
  }
}
