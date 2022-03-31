import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/functions.dart';
import 'package:water_reminder/models/chart_data.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/widgets/elevated_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:water_reminder/widgets/glassmorphism.dart';
import 'statistics_helpers.dart';
import 'dart:math' as math;

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  Object? _chartType = 0; // 0=month, 1=year
  final DateTime _now = DateTime.now();
  late List<int> _selectedDate = [_now.year, _now.month];

  late final DataProvider _provider;
  late final List<ChartData> _chartDataList;
  double _monthlyDrinkAverage = 0;
  double _weeklyDrinkAverage = 0;
  int _drinkFrequency = 0;
  int _averageCompletion = 0;
  double _weeklyCompletionPercent = 0;

  String monthString(int month) => DateFormat.MMM(
        Localizations.localeOf(context).languageCode,
      ).format(DateTime(_selectedDate[0], month));

  String weekDayString(int day) => DateFormat.E(
        Localizations.localeOf(context).languageCode,
      ).format(DateTime(_now.year, _now.month, day));

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<DataProvider>(context, listen: false);
    _chartDataList = _provider.getChartDataList;

    _monthlyDrinkAverage = monthlyDrinkAverage(
      chartDataList: _provider.getChartDataList,
      year: _now.year,
      month: _now.month,
    );
    _weeklyCompletionPercent = weeklyPercent(weekDataList: _provider.getWeekDataList);
    _weeklyDrinkAverage = weeklyDrinkAverage(weekDataList: _provider.getWeekDataList);
    _drinkFrequency = drinkFrequency(chartDataList: _provider.getChartDataList);
    _averageCompletion = averageCompletion(chartDataList: _provider.getChartDataList);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<DataProvider>(builder: (context, provider, _) {
      return Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GlassmorphicContainer(
                height: size.height * 0.375,
                width: size.width * 0.95,
                borderRadius: BorderRadius.circular(10),
                blur: 10,
                linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade200.withOpacity(0.1),
                    Colors.blue.shade200.withOpacity(0.05),
                  ],
                  stops: const [0.1, 1],
                ),
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
                                /// Needs to be fixed

                                if (_chartType == 0 && _selectedDate[1] > 1) {
                                  if (_chartDataList.any((chartData) =>
                                      chartData.year == _selectedDate[0] &&
                                      chartData.month == _selectedDate[1] - 1)) {
                                    setState(() =>
                                        _selectedDate = [_selectedDate[0], _selectedDate[1] - 1]);
                                  }
                                } else if (_chartType == 1) {
                                  if (_chartDataList
                                      .any((chartData) => chartData.year == _selectedDate[0] - 1)) {
                                    setState(() =>
                                        _selectedDate = [_selectedDate[0] - 1, _selectedDate[1]]);
                                  }
                                }
                              },
                              icon: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _chartDataList.any(
                                          (chartData) => chartData.month == _selectedDate[1] - 1)
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                                child: Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(math.pi),
                                  child: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 13,
                                  ),
                                ),
                              ),
                            ),
                            getChartTitle(value: _chartType!),
                            IconButton(
                              onPressed: () {
                                //TODO: Needs to be fixed
                                if (_chartType == 0 && _selectedDate[1] > 1) {
                                  if (_chartDataList.any((chartData) =>
                                      chartData.year == _selectedDate[0] &&
                                      chartData.month == _selectedDate[1] + 1)) {
                                    setState(() =>
                                        _selectedDate = [_selectedDate[0], _selectedDate[1] + 1]);
                                  }
                                } else if (_chartType == 1 &&
                                    _chartDataList.any(
                                        (chartData) => chartData.year == _selectedDate[0] + 1)) {
                                  setState(() =>
                                      _selectedDate = [_selectedDate[0] + 1, _selectedDate[1]]);
                                }
                              },
                              icon: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _chartDataList.any(
                                          (chartData) => chartData.month == _selectedDate[1] + 1)
                                      ? Colors.blue
                                      : Colors.grey,
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
                            maxY: 120,
                            minY: 0,
                            barTouchData: BarTouchData(enabled: false),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: _chartType == 0 ? 3 : 1,
                                  getTitlesWidget: (value, meta) => Text(
                                    _chartType == 0
                                        ? value.toStringAsFixed(0)
                                        : monthString(value.toInt() + 1),
                                    style: const TextStyle(
                                      color: Color(0xff939393),
                                      fontSize: 10,
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
                                    value == 120 ? '(%)' : value.toStringAsFixed(0),
                                    style: value == 120
                                        ? const TextStyle(
                                            color: Color(0xff939393),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          )
                                        : const TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
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
                                strokeWidth: 0,
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
                                  width: 0.8,
                                  color: Colors.black12,
                                ),
                                left: BorderSide(
                                  width: 0.8,
                                  color: Colors.black12,
                                ),
                              ),
                            ),
                            barGroups: _chartType == 0 ? getMonthGroupData() : getYearGroupData(),
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
                groupValue: _chartType,
                children: {
                  0: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(AppLocalizations.of(context)!.month),
                  ),
                  1: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(AppLocalizations.of(context)!.year),
                  )
                },
                onValueChanged: (value) => setState(() => _chartType = value),
              ),

              SizedBox(height: size.height * 0.03),

              /// Weekly completion
              GlassmorphicContainer(
                width: size.width * 0.95,
                height: size.height * 0.185,
                blur: 10,
                borderRadius: const BorderRadius.only(
                  topRight: kRadius_50,
                  bottomLeft: kRadius_50,
                ),
                linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade200.withOpacity(0.1),
                    Colors.blue.shade200.withOpacity(0.05),
                  ],
                  stops: const [0.1, 1],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.weeklyCompletion,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '${_weeklyCompletionPercent.toStringAsFixed(2)}%',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          7,
                          (index) => Expanded(
                            child: AnimationLimiter(
                              child: Column(
                                children: AnimationConfiguration.toStaggeredList(
                                  duration: const Duration(milliseconds: 800),
                                  childAnimationBuilder: (widget) => SlideAnimation(
                                    horizontalOffset: 50.0,
                                    child: FadeInAnimation(child: widget),
                                  ),
                                  children: [
                                    ElevatedContainer(
                                      blurRadius: 1,
                                      width: 45,
                                      height: 45,
                                      child: Center(
                                        child: provider.getWeekDataList[index].drankAmount > 0
                                            ? const Icon(
                                                Icons.water_drop,
                                                size: 32,
                                                color: kPrimaryColor,
                                              )
                                            : const Icon(
                                                Icons.water_drop,
                                                size: 32,
                                                color: Colors.black26,
                                              ),
                                      ),
                                    ),
                                    SizedBox(height: size.height * 0.01),
                                    Text(
                                      weekDayString(index),
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.05),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Text(
                    AppLocalizations.of(context)!.drinkWaterReport,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              GlassmorphicContainer(
                width: size.width * 0.95,
                height: size.height * 0.385,
                borderRadius: BorderRadius.circular(10),
                blur: 10,
                linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade200.withOpacity(0.1),
                    Colors.blue.shade200.withOpacity(0.05),
                  ],
                  stops: const [0.1, 1],
                ),
                child: AnimationLimiter(
                  child: Column(
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 800),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(child: widget),
                      ),
                      children: [
                        buildReportRow(
                          size: size,
                          iconColor: Colors.green,
                          title: AppLocalizations.of(context)!.weeklyAverage,
                          content:
                              '${provider.getCapacityUnit == 0 ? _weeklyDrinkAverage.toStringAsFixed(0) : mlToFlOz(_weeklyDrinkAverage).toStringAsFixed(1)} '
                              '${kCapacityUnitStrings[provider.getCapacityUnit]} / ${AppLocalizations.of(context)!.day}',
                        ),
                        Divider(
                          thickness: 1,
                          indent: size.width * 0.05,
                          endIndent: size.width * 0.05,
                        ),
                        buildReportRow(
                          size: size,
                          iconColor: kPrimaryColor,
                          title: AppLocalizations.of(context)!.monthlyAverage,
                          content:
                              '${provider.getCapacityUnit == 0 ? _monthlyDrinkAverage.toStringAsFixed(0) : mlToFlOz(_monthlyDrinkAverage).toStringAsFixed(1)} '
                              '${kCapacityUnitStrings[provider.getCapacityUnit]} / ${AppLocalizations.of(context)!.day}',
                        ),
                        Divider(
                          thickness: 1,
                          indent: size.width * 0.05,
                          endIndent: size.width * 0.05,
                        ),
                        buildReportRow(
                          size: size,
                          iconColor: Colors.orange,
                          title: AppLocalizations.of(context)!.averageCompletion,
                          content: '$_averageCompletion%',
                        ),
                        Divider(
                          thickness: 1,
                          indent: size.width * 0.05,
                          endIndent: size.width * 0.05,
                        ),
                        buildReportRow(
                          size: size,
                          iconColor: Colors.red,
                          title: AppLocalizations.of(context)!.drinkFrequency,
                          content:
                              '$_drinkFrequency ${AppLocalizations.of(context)!.times} / ${AppLocalizations.of(context)!.day}',
                        ),
                        Divider(
                          thickness: 1,
                          indent: size.width * 0.05,
                          endIndent: size.width * 0.05,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      );
    });
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
  Widget getChartTitle({required Object value}) {
    if (value == 0) {
      return chartTitleWidget(text: '${monthString(_selectedDate[1])} ${_selectedDate[0]}');
    } else if (value == 1) {
      return chartTitleWidget(text: '${_selectedDate[0]}');
    }

    return chartTitleWidget(text: '${monthString(_selectedDate[1])} ${_selectedDate[0]}');
  }

  /// Get year group data
  List<BarChartGroupData> getYearGroupData() {
    final List<double> barRodValues = List.generate(
        12,
        (index) => monthlyDrinkPercent(
              chartDataList: _chartDataList,
              month: index + 1,
              year: _selectedDate[0],
              intakeGoalAmount: _provider.getIntakeGoalAmount,
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
  List<BarChartGroupData> getMonthGroupData() {
    final List<ChartData> selectedMonthChartDataList = selectedMonthChartData(
      chartDataList: _chartDataList,
      selectedDate: _selectedDate,
    );

    return selectedMonthChartDataList
        .map((data) => BarChartGroupData(
              x: data.day + 1,
              barRods: [
                BarChartRodData(
                  toY: data.percent,
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.zero,
                )
              ],
            ))
        .toList();
  }
}
