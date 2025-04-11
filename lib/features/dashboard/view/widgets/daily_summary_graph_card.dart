import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:expense_manager/core/helpers/transaction_helpers.dart';
import 'package:expense_manager/core/helpers/utils.dart';
import 'package:expense_manager/core/widgets/skeleton_loader.dart';
import 'package:expense_manager/features/dashboard/viewmodel/daily_summary_graph_viewmodel/daily_summary_graph_viewmodel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DailySummaryGraphCard extends StatefulWidget {
  const DailySummaryGraphCard({super.key});

  @override
  State<DailySummaryGraphCard> createState() => _DailySummaryGraphCardState();
}

class _DailySummaryGraphCardState extends State<DailySummaryGraphCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpensesWeeklySummaryCard();
  }
}

class BarChartSample5 extends StatefulWidget {
  final Map<int, List<double>> dataValues;
  final Map<int, String> xAxisLabels;
  final BigInt currentWeekTotalAmount;
  final double maxY;

  const BarChartSample5(
      {required this.dataValues,
      required this.maxY,
      required this.xAxisLabels,
      required this.currentWeekTotalAmount,
      super.key});

  @override
  State<StatefulWidget> createState() => _BarChartSample5State();
}

class _BarChartSample5State extends State<BarChartSample5> {
  static const double barWidth = 29;
  int touchedIndex = -1;
  bool showTodayBarTooltip = true;

  @override
  void initState() {
    super.initState();
  }

  Widget bottomTitles(BuildContext context, double value, TitleMeta meta) {
    final style = Theme.of(context).textTheme.bodySmall!.copyWith(
          color: ColorsConfig.textColor1,
          fontWeight: FontWeight.w500,
        );
    String text = widget.xAxisLabels[value] ?? '';
    return SideTitleWidget(
      meta: meta,
      angle: AppUtils.degreeToRadian(0),
      space: 20,
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
      angle: AppUtils.degreeToRadian(value < 0 ? -45 : 45),
      meta: meta,
      space: 4,
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget rightTitles(BuildContext context, double value, TitleMeta meta) {
    final style = Theme.of(context).textTheme.bodySmall!.copyWith(
          color: ColorsConfig.textColor1,
          fontWeight: FontWeight.w500,
        );
    String text;
    if (value <= 0) {
      text = '0';
    } else if (value % 1000 == 0) {
      text = '${(value / 1000).toInt()}k';
    } else {
      text = '${(value / 1000).toInt()}.${(value % 1000).toString()[0]}k';
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
    final isToday = DateTime.now().weekday - 1 == x;
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      showingTooltipIndicators:
          (showTodayBarTooltip && isToday) || touchedIndex == x ? [0] : [],
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
              isToday ? ColorsConfig.color2 : ColorsConfig.color5,
            ),
          ],
        ),
      ],
    );
  }

  bool isShadowBar(int rodIndex) => rodIndex == 1;

  double getYAxisInterval() {
    if (widget.maxY > 2000) {
      return 1000;
    } else if (widget.maxY > 1000) {
      return 500;
    } else {
      return 200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: double.infinity,
        minWidth: double.infinity,
      ),
      child: Column(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Column(children: [
            Text(
              'THIS WEEK',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: ColorsConfig.textColor5,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Padding(
              padding: const EdgeInsets.all(3),
              child: Text(
                TransactionHelpers.formatStringAmount(
                  widget.currentWeekTotalAmount.toString(),
                ),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: ColorsConfig.textColor4,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ]),
        ),
        AspectRatio(
          aspectRatio: 2,
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.center,
                maxY: widget.maxY,
                minY: 0,
                baselineY: 0,
                groupsSpace: 12,
                barTouchData: BarTouchData(
                  handleBuiltInTouches: false,
                  touchTooltipData: BarTouchTooltipData(
                    fitInsideHorizontally: true,
                    tooltipBorder: BorderSide(
                      color: ColorsConfig.color7,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                    getTooltipColor: (group) => ColorsConfig.color5,
                    tooltipPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    tooltipMargin: 10,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        TransactionHelpers.formatIndianCurrency(rod.toY),
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
                      // setState(() {
                      //   touchedIndex = -1;
                      //   showTodayBarTooltip = true;
                      // });
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
                      touchedIndex =
                          barTouchResponse.spot!.touchedBarGroupIndex;
                      showTodayBarTooltip = false;
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
                      getTitlesWidget: (value, meta) =>
                          bottomTitles(context, value, meta),
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
                      getTitlesWidget: (value, meta) =>
                          rightTitles(context, value, meta),
                      interval: getYAxisInterval(),
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
                barGroups: widget.dataValues.entries
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
        )
      ]),
    );
  }
}

class ExpensesWeeklySummaryCard extends ConsumerWidget {
  const ExpensesWeeklySummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        constraints: BoxConstraints(
          maxHeight: 200,
          minWidth: double.infinity,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ref.watch(dailySummaryGraphViewModelProvider).when(
                    data: (data) {
                      if (data == null) {
                        return SkeletonLoader();
                      }
                      Map<int, List<double>> dataValues = {};
                      Map<int, String> xAxisLables = {};
                      double maxAmount = 0;
                      data.dateRange.asMap().entries.forEach(
                        (element) {
                          final perDayDbValue = data
                              .dailySummarizedTransactionsMap[element.key]
                              ?.totalAmount;
                          double barValue =
                              TransactionHelpers.getAmountFromDbAmount('0');
                          if (perDayDbValue != null) {
                            barValue = TransactionHelpers.getAmountFromDbAmount(
                                perDayDbValue.toString());
                          }
                          if (barValue > maxAmount) {
                            maxAmount = barValue;
                          }
                          dataValues[element.key] = [barValue];
                          xAxisLables[element.key] =
                              DateFormat('EEE').format(element.value);
                        },
                      );
                      return BarChartSample5(
                        dataValues: dataValues,
                        currentWeekTotalAmount: data.totalSummarizedAmount,
                        maxY: maxAmount,
                        xAxisLabels: xAxisLables,
                      );
                    },
                    error: (error, stackTrace) {
                      return Text(
                        'Error loading data',
                        style: Theme.of(context).textTheme.bodyMedium,
                      );
                    },
                    loading: () => SkeletonLoader(
                      width: double.infinity,
                      height: 120,
                    ),
                  )
            ],
          ),
        ),
      ),
    );
  }
}
