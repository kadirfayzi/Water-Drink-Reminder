import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/functions.dart';
import 'package:water_reminder/models/chart_data.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/widgets/elevated_container.dart';
import 'history_helpers.dart';
import 'dart:math' as math;

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Object? timeRangeValue = 0;
  final DateTime _date = DateTime.now();

  late List<dynamic> selectedDate = [_date.year, _date.month, _date.day];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<DataProvider>(builder: (context, provider, _) {
      final List<ChartData> chartDataList = provider.getMonthDayChartDataList;
      return Scrollbar(
        child: SingleChildScrollView(
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
                        if (timeRangeValue == 0) {
                          if (chartDataList.any((chartData) =>
                              chartData.month == _date.month - 1)) {
                            setState(() => selectedDate = [
                                  _date.year,
                                  _date.month - 1,
                                  _date.day
                                ]);
                          }
                        } else {
                          if (chartDataList.any((chartData) =>
                              chartData.year == _date.year - 1)) {
                            setState(() => selectedDate = [
                                  _date.year - 1,
                                  _date.month,
                                  _date.day
                                ]);
                          }
                        }
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: chartDataList.any((chartData) =>
                                  chartData.month == _date.month - 1)
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
                    Text(
                      timeRangeValue == 0
                          ? '${kMonths[selectedDate[1] - 1]} ${selectedDate[0]}'
                          : '${selectedDate[0]}',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (timeRangeValue == 0) {
                          if (chartDataList.any((chartData) =>
                              chartData.month == _date.month + 1)) {
                            setState(() => selectedDate = [
                                  _date.year,
                                  _date.month + 1,
                                  _date.day
                                ]);
                          }
                        } else {
                          if (chartDataList.any((chartData) =>
                              chartData.year == _date.year + 1)) {
                            setState(() => selectedDate = [
                                  _date.year + 1,
                                  _date.month,
                                  _date.day
                                ]);
                          }
                        }
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: chartDataList.any((chartData) =>
                                  chartData.month == _date.month + 1)
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
                width: size.width * 0.975,
                child: BarChart(
                  BarChartData(
                    maxY: 120,
                    minY: 0,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      bottomTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (context, value) => const TextStyle(
                          color: Color(0xff939393),
                          fontSize: 10,
                        ),
                        margin: 10,
                        interval: timeRangeValue == 0 ? 3 : 1,
                        getTitles: timeRangeValue == 1
                            ? (value) {
                                if (value == 0) {
                                  return 'Jan';
                                } else if (value == 1) {
                                  return 'Feb';
                                } else if (value == 2) {
                                  return 'Mar';
                                } else if (value == 3) {
                                  return 'Apr';
                                } else if (value == 4) {
                                  return 'May';
                                } else if (value == 5) {
                                  return 'Jun';
                                } else if (value == 6) {
                                  return 'Jul';
                                } else if (value == 7) {
                                  return 'Aug';
                                } else if (value == 8) {
                                  return 'Sep';
                                } else if (value == 9) {
                                  return 'Oct';
                                } else if (value == 10) {
                                  return 'Nov';
                                } else if (value == 11) {
                                  return 'Dec';
                                }

                                return '';
                              }
                            : (value) => (value + 1).toStringAsFixed(0),
                      ),
                      leftTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitles: (value) =>
                            value == 120 ? '(%)' : value.toStringAsFixed(0),
                        getTextStyles: (context, value) => value == 120
                            ? const TextStyle(
                                color: Color(0xff939393),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              )
                            : const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                              ),
                        margin: 10,
                        interval: 20,
                      ),
                      topTitles: SideTitles(showTitles: false),
                      rightTitles: SideTitles(showTitles: false),
                    ),
                    gridData: FlGridData(
                      show: true,
                      // checkToShowHorizontalLine: (value) => value % 10 == 0,
                      getDrawingVerticalLine: (value) => FlLine(
                        // color: const Color(0xffe7e8ec),
                        strokeWidth: 0,
                      ),
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: const Color(0xffe7e8ec),
                        strokeWidth: 1,
                        dashArray: [3],
                      ),
                    ),
                    borderData: FlBorderData(
                        show: true,
                        border: const Border(
                          bottom: BorderSide(
                            width: 0.5,
                            color: Color(0xffd0d0d0),
                          ),
                          left: BorderSide(
                            width: 0.5,
                            color: Color(0xffd0d0d0),
                          ),
                        )),
                    barGroups: timeRangeValue == 0
                        ? getMonthGroupData(chartDataList)
                        : getYearGroupData(chartDataList),
                  ),
                  swapAnimationCurve: Curves.easeInOutCubic,
                  swapAnimationDuration: const Duration(milliseconds: 1000),
                ),
              ),

              SizedBox(height: size.height * 0.03),

              /// Time range selection
              CupertinoSlidingSegmentedControl(
                groupValue: timeRangeValue,
                children: const {0: Text('Month'), 1: Text('Year')},
                onValueChanged: (value) =>
                    setState(() => timeRangeValue = value),
              ),

              SizedBox(height: size.height * 0.03),

              /// Weekly completion
              Container(
                width: double.infinity,
                height: size.height * 0.185,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      kPrimaryColor,
                      Colors.blue[200]!,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      heightFactor: 2,
                      child: Text(
                        'Weekly Completion',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          7,
                          (index) => Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedContainer(
                                  blurRadius: 1,
                                  width: 40,
                                  height: 40,
                                  child: Center(
                                      child:
                                          Image.asset('assets/images/3.png')),
                                ),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  kWeekDays[index],
                                  style: const TextStyle(
                                    color: Colors.white,
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
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.01),
              const SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'Drink Water Report',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),

              buildReportRow(
                size: size,
                iconColor: Colors.green,
                title: 'Weekly average',
                content: '1955 ml / day',
              ),
              const Divider(),
              buildReportRow(
                size: size,
                iconColor: kPrimaryColor,
                title: 'Monthly average',
                content: '1955 ml / day',
              ),
              const Divider(),
              buildReportRow(
                size: size,
                iconColor: Colors.orange,
                title: 'Average completion',
                content: '77%',
              ),
              const Divider(),
              buildReportRow(
                size: size,
                iconColor: Colors.red,
                title: 'Drink frequency',
                content: '11 times / day',
              ),
              const Divider(),

              /// Tips
              SizedBox(
                width: size.width * 0.95,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: ElevatedContainer(
                          height: size.height * 0.085,
                          color: kSecondaryColor,
                          shadowColor: kSecondaryColor,
                          shape: BoxShape.rectangle,
                          padding: const EdgeInsets.all(8.0),
                          blurRadius: 0.0,
                          borderRadius: const BorderRadius.only(
                            topLeft: kRadius_25,
                            bottomRight: kRadius_25,
                            bottomLeft: kRadius_25,
                          ),
                          child: Center(
                            child: Text(
                              getRandomTip(),
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )),
                    ),
                    SizedBox(width: size.width * 0.02),
                    Expanded(
                      child: Image.asset('assets/images/2.png', scale: 1),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.02),
            ],
          ),
        ),
      );
    });
  }

  /// Get year group data
  List<BarChartGroupData> getYearGroupData(List<ChartData> chartDataList) {
    final List<ChartData> chartDataMonthList = chartDataList
        .where((element) => element.year == selectedDate[0])
        .toList();

    return List.generate(
      kMonths.length,
      (index) {
        return BarChartGroupData(
          x: index,
          barsSpace: 15,
          barRods: [
            BarChartRodData(
              y: Random().nextInt(100) + 10.toDouble(),
              colors: [kPrimaryColor],
              borderRadius: BorderRadius.zero,
            )
          ],
        );
      },
    );
  }

  /// Get month group data
  List<BarChartGroupData> getMonthGroupData(List<ChartData> chartDataList) =>
      chartDataList
          .map<BarChartGroupData>(
            (ChartData data) => BarChartGroupData(
              x: data.day,
              barRods: [
                BarChartRodData(
                  y: data.percent,
                  colors: [kPrimaryColor],
                  borderRadius: BorderRadius.zero,
                )
              ],
            ),
          )
          .toList();
  // List<BarChartGroupData> getMonthGroupData(DataProvider provider) =>
  //     List.generate(
  //       getMonthDays(),
  //       (index) => BarChartGroupData(
  //         x: provider.getMonthDayChartDataList[index],
  //         barsSpace: 15,
  //         barRods: [
  //           BarChartRodData(
  //             y: Random().nextInt(100) + 10.toDouble(),
  //             // y: provider.getMonthDayChartDataList[index].y.toDouble(),
  //             colors: List.generate(getMonthDays(), (index) => kPrimaryColor),
  //           )
  //         ],
  //       ),
  //     );
}
