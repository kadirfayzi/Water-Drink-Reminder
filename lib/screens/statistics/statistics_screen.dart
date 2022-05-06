import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/functions.dart';
import 'package:water_reminder/models/chart_data.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/screens/statistics/widgets/drink_water_report.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:math' show pi;

import 'package:water_reminder/screens/statistics/widgets/weekly_completion.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String monthString(int month) => DateFormat.MMM(
        Localizations.localeOf(context).languageCode,
      ).format(DateTime(DateTime.now().year, month));

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final localize = AppLocalizations.of(context)!;
    return Consumer<DataProvider>(
      builder: (context, provider, _) => SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: size.width * 0.95,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.03),
                    SizedBox(
                      width: size.width * 0.7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              /// Select previous year/month chart data if exists
                              if (provider.getChartType == 0 &&
                                  provider.getChartDataList.any((chartData) =>
                                      chartData.year == provider.getSelectedDate.year &&
                                      chartData.month == provider.getSelectedDate.month - 1)) {
                                provider.setSelectedDate = DateTime(provider.getSelectedDate.year,
                                    provider.getSelectedDate.month - 1);
                              } else if (provider.getChartType == 1 &&
                                  provider.getChartDataList.any((chartData) =>
                                      chartData.year == provider.getSelectedDate.year - 1)) {
                                provider.setSelectedDate = DateTime(
                                    provider.getSelectedDate.year - 1,
                                    provider.getSelectedDate.month);
                              }
                            },
                            icon: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: getPreviousIconColor(
                                  chartDataList: provider.getChartDataList,
                                  selectedDate: provider.getSelectedDate,
                                  chartType: provider.getChartType,
                                ),
                              ),
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(pi),
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 13,
                                ),
                              ),
                            ),
                          ),
                          getChartTitle(
                            value: provider.getChartType,
                            selectedDate: provider.getSelectedDate,
                          ),
                          IconButton(
                            onPressed: () {
                              if (provider.getChartType == 0 &&
                                  provider.getChartDataList.any((chartData) =>
                                      chartData.year == provider.getSelectedDate.year &&
                                      chartData.month == provider.getSelectedDate.month + 1)) {
                                provider.setSelectedDate = DateTime(provider.getSelectedDate.year,
                                    provider.getSelectedDate.month + 1);
                              } else if (provider.getChartType == 1 &&
                                  provider.getChartDataList.any((chartData) =>
                                      chartData.year == provider.getSelectedDate.year + 1)) {
                                provider.setSelectedDate = DateTime(
                                    provider.getSelectedDate.year + 1,
                                    provider.getSelectedDate.month);
                              }
                            },
                            icon: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: getNextIconColor(
                                  chartDataList: provider.getChartDataList,
                                  selectedDate: provider.getSelectedDate,
                                  chartType: provider.getChartType,
                                ),
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    SizedBox(
                      height: size.height * 0.25,
                      child: BarChart(
                        BarChartData(
                          maxY: 115,
                          minY: 0,
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: getMonthlyInterval(chartType: provider.getChartType),
                                getTitlesWidget: (value, meta) => Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: getBottomTitle(
                                    chartType: provider.getChartType,
                                    value: value,
                                    context: context,
                                  ),
                                ),
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 20,
                                reservedSize: 25,
                                getTitlesWidget: (value, meta) => Text(
                                  value == 115 ? '(%)' : value.toStringAsFixed(0),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                // margin: 10,
                              ),
                            ),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: FlGridData(
                            show: true,
                            getDrawingVerticalLine: (value) => FlLine(
                              color: Colors.black12,
                              strokeWidth: 1,
                              dashArray: [3],
                            ),
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.black12,
                              strokeWidth: 1,
                              dashArray: [3],
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: const Border(
                              bottom: BorderSide(
                                width: 1.5,
                                color: Colors.black12,
                              ),
                              left: BorderSide(
                                width: 1.5,
                                color: Colors.black12,
                              ),
                            ),
                          ),
                          barGroups: getBarGroupsList(
                            chartDataList: provider.getChartDataList,
                            intakeGoalAmount: provider.getIntakeGoalAmount,
                            selectedDate: provider.getSelectedDate,
                            chartType: provider.getChartType,
                          ),
                        ),
                        // swapAnimationCurve: Curves.easeInOutCubic,
                        // swapAnimationDuration: Duration.zero,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: size.height * 0.01),

            /// Time range selection
            CupertinoSlidingSegmentedControl(
              groupValue: provider.getChartType,
              children: {
                0: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(localize.month),
                ),
                1: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(localize.year),
                )
              },
              onValueChanged: (value) => provider.setChartType = value!,
            ),

            SizedBox(height: size.height * 0.03),

            const WeeklyCompletion(),
            SizedBox(height: size.height * 0.05),

            const DrinkWaterReport(),
            SizedBox(height: size.height * 0.05),
          ],
        ),
      ),
    );
  }

  /// Chart title widget
  Text chartTitleWidget({required String text}) => Text(
        text,
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 15,
        ),
      );

  /// Get chart title
  getChartTitle({required Object value, required DateTime selectedDate}) {
    if (value == 0) {
      return chartTitleWidget(text: '${monthString(selectedDate.month)} ${selectedDate.year}');
    } else if (value == 1) {
      return chartTitleWidget(text: '${selectedDate.year}');
    }
  }

  /// Next icon color
  getPreviousIconColor({
    required List<ChartData> chartDataList,
    required DateTime selectedDate,
    required Object chartType,
  }) {
    switch (chartType) {
      case 0:
        return chartDataList.any((chartData) => chartData.month == selectedDate.month - 1)
            ? Colors.blue
            : Colors.grey;
      case 1:
        return chartDataList.any((chartData) => chartData.year == selectedDate.year - 1)
            ? Colors.blue
            : Colors.grey;
    }
  }

  /// Next icon color
  getNextIconColor({
    required List<ChartData> chartDataList,
    required DateTime selectedDate,
    required Object chartType,
  }) {
    switch (chartType) {
      case 0:
        return chartDataList.any((chartData) => chartData.month == selectedDate.month + 1)
            ? Colors.blue
            : Colors.grey;
      case 1:
        return chartDataList.any((chartData) => chartData.year == selectedDate.year + 1)
            ? Colors.blue
            : Colors.grey;
    }
  }

  /// Get bar groups list
  getBarGroupsList({
    required List<ChartData> chartDataList,
    required double intakeGoalAmount,
    required DateTime selectedDate,
    required Object chartType,
  }) {
    switch (chartType) {
      case 0:
        return getMonthGroupDataList(chartDataList: chartDataList, selectedDate: selectedDate);
      case 1:
        return getYearGroupDataList(
          chartDataList: chartDataList,
          intakeGoalAmount: intakeGoalAmount,
          selectedDate: selectedDate,
        );
    }
  }

  /// Get Monthly chart bottom titles interval
  getMonthlyInterval({required Object chartType}) {
    switch (chartType) {
      case 0:
        return 3.0;
      case 1:
        return 1.0;
    }
  }

  /// Get chart's bottom title
  getBottomTitle({
    required double value,
    required Object chartType,
    required BuildContext context,
  }) {
    switch (chartType) {
      case 0:
        return Text(
          value.toStringAsFixed(0),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 8,
          ),
        );
      case 1:
        return Text(
          monthString(value.toInt() + 1),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        );
    }
  }

  /// Get year group data
  List<BarChartGroupData> getYearGroupDataList({
    required List<ChartData> chartDataList,
    required double intakeGoalAmount,
    required DateTime selectedDate,
  }) {
    final List<double> barRodValues = List.generate(
        12,
        (index) => Functions.monthlyDrinkPercent(
              chartDataList: chartDataList,
              month: index + 1,
              year: selectedDate.year,
              intakeGoalAmount: intakeGoalAmount,
            )).toList();

    return List.generate(
      12,
      (index) => BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: barRodValues[index] > 100 ? 100 : barRodValues[index],
            color: kPrimaryColor,
            borderRadius: BorderRadius.zero,
            width: 12.5,
          )
        ],
      ),
    );
  }

  /// Get month group data
  List<BarChartGroupData> getMonthGroupDataList({
    required List<ChartData> chartDataList,
    required DateTime selectedDate,
  }) {
    /// Get selected month chart data
    final List<ChartData> selectedMonthChartDataList = chartDataList
        .where(
            (element) => element.year == selectedDate.year && element.month == selectedDate.month)
        .toList();

    return selectedMonthChartDataList
        .map((data) => BarChartGroupData(
              x: data.day,
              barRods: [
                BarChartRodData(
                  toY: data.percent,
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.zero,
                  width: 5,
                )
              ],
            ))
        .toList();
  }
}
