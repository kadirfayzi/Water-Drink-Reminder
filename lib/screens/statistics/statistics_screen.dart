import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/functions.dart';
import 'package:water_reminder/models/chart_data.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/widgets/elevated_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  int _monthlyDrinkAverage = 0;
  int _drinkFrequency = 0;
  int _averageCompletion = 0;

  String monthString(int month) => DateFormat.MMM(Localizations.localeOf(context).languageCode)
      .format(DateTime(_selectedDate[0], month));

  String weekDayString(int day) => DateFormat.E(Localizations.localeOf(context).languageCode)
      .format(DateTime(_now.year, _now.month, day));

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<DataProvider>(context, listen: false);
    _chartDataList = _provider.getChartDataList;

    _monthlyDrinkAverage = monthlyDrinkAverage(
        chartDataList: _provider.getChartDataList, year: _now.year, month: _now.month);
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
                            setState(
                                () => _selectedDate = [_selectedDate[0], _selectedDate[1] - 1]);
                          }
                        } else if (_chartType == 1) {
                          if (_chartDataList
                              .any((chartData) => chartData.year == _selectedDate[0] - 1)) {
                            setState(
                                () => _selectedDate = [_selectedDate[0] - 1, _selectedDate[1]]);
                          }
                        }
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _chartDataList
                                  .any((chartData) => chartData.month == _selectedDate[1] - 1)
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
                        /// Needs to be fixed
                        if (_chartType == 0 && _selectedDate[1] > 1) {
                          if (_chartDataList.any((chartData) =>
                              chartData.year == _selectedDate[0] &&
                              chartData.month == _selectedDate[1] + 1)) {
                            setState(
                                () => _selectedDate = [_selectedDate[0], _selectedDate[1] + 1]);
                          }
                        } else if (_chartType == 1 &&
                            _chartDataList
                                .any((chartData) => chartData.year == _selectedDate[0] + 1)) {
                          setState(() => _selectedDate = [_selectedDate[0] + 1, _selectedDate[1]]);
                        }
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _chartDataList
                                  .any((chartData) => chartData.month == _selectedDate[1] + 1)
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
                          interval: _chartType == 0 ? 3 : 1,
                          getTitles: _chartType == 0
                              ? (value) => value.toStringAsFixed(0)
                              : (value) => monthString(value.toInt() + 1)),
                      leftTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitles: (value) => value == 120 ? '(%)' : value.toStringAsFixed(0),
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
                    barGroups: _chartType == 0 ? getMonthGroupData() : getYearGroupData(),
                  ),
                  swapAnimationCurve: Curves.easeInOutCubic,
                  swapAnimationDuration: Duration.zero,
                ),
              ),

              SizedBox(height: size.height * 0.03),

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
              Container(
                width: double.infinity,
                height: size.height * 0.185,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.blue,
                      Colors.lightBlueAccent,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      heightFactor: 2,
                      child: Text(
                        AppLocalizations.of(context)!.weeklyCompletion,
                        style: const TextStyle(
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
                                  color: Colors.lightBlueAccent,
                                  blurRadius: 1,
                                  width: 40,
                                  height: 40,
                                  child: Center(
                                    child: Image.asset('assets/images/happy-water-glass.png'),
                                  ),
                                ),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  weekDayString(index),
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
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    AppLocalizations.of(context)!.drinkWaterReport,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),

              buildReportRow(
                size: size,
                iconColor: Colors.green,
                title: AppLocalizations.of(context)!.weeklyAverage,
                content: '1955 ml / day',
              ),
              const Divider(),
              buildReportRow(
                size: size,
                iconColor: kPrimaryColor,
                title: AppLocalizations.of(context)!.monthlyAverage,
                content: '$_monthlyDrinkAverage ml / day',
              ),
              const Divider(),
              buildReportRow(
                size: size,
                iconColor: Colors.orange,
                title: AppLocalizations.of(context)!.averageCompletion,
                content: '$_averageCompletion%',
              ),
              const Divider(),
              buildReportRow(
                size: size,
                iconColor: Colors.red,
                title: AppLocalizations.of(context)!.drinkFrequency,
                content: '$_drinkFrequency times / day',
              ),
              const Divider(),
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
        (index) => monthOfYearChartData(
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
            y: barRodValues[index] > 100 ? 100 : barRodValues[index],
            colors: [Colors.lightBlueAccent, kPrimaryColor],
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
    return List.generate(
      selectedMonthChartDataList.length,
      (index) => BarChartGroupData(
        x: index + 1,
        barRods: [
          BarChartRodData(
            y: selectedMonthChartDataList[index].percent,
            colors: [Colors.lightBlueAccent, kPrimaryColor],
            borderRadius: BorderRadius.zero,
          )
        ],
      ),
    );
  }
}

/// Statistics screen with weekly data
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:water_reminder/constants.dart';
// import 'package:water_reminder/functions.dart';
// import 'package:water_reminder/models/chart_data.dart';
// import 'package:water_reminder/provider/data_provider.dart';
// import 'package:water_reminder/widgets/elevated_container.dart';
// import 'statistics_helpers.dart';
// import 'dart:math' as math;
//
// class StatisticsScreen extends StatefulWidget {
//   const StatisticsScreen({Key? key}) : super(key: key);
//
//   @override
//   _StatisticsScreenState createState() => _StatisticsScreenState();
// }
//
// class _StatisticsScreenState extends State<StatisticsScreen> {
//   Object? _chartType = 0; // 0=week, 1=month, 2=year
//   final DateTime _now = DateTime.now();
//   late List<int> _selectedDate = [_now.year, _now.month, _now.day];
//   late final DataProvider _provider;
//   late final List<ChartData> _monthDayChartDataList;
//   int _monthlyDrinkAverage = 0;
//   int _drinkFrequency = 0;
//   int _averageCompletion = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _provider = Provider.of<DataProvider>(context, listen: false);
//     _monthDayChartDataList = _provider.getChartDataList;
//
//     _monthlyDrinkAverage = monthlyDrinkAverage(
//       monthDayChartDataList: _provider.getChartDataList,
//       month: _now.month,
//       year: _now.year,
//     );
//     _drinkFrequency = drinkFrequency(monthDayChartDataList: _provider.getChartDataList);
//     _averageCompletion = averageCompletion(monthDayChartDataList: _provider.getChartDataList);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Consumer<DataProvider>(builder: (context, provider, _) {
//       return Scrollbar(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(height: size.height * 0.03),
//               SizedBox(
//                 width: size.width * 0.7,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     IconButton(
//                       onPressed: () {
//                         //TODO:need to be update according weekly chart
//                         // if (_chartType == 0) {
//                         //   if (_monthDayChartDataList
//                         //       .any((chartData) => chartData.month == _now.month - 1)) {
//                         //     setState(() => _selectedDate = [_now.year, _now.month - 1, _now.day]);
//                         //   }
//                         // } else {
//                         //   if (_monthDayChartDataList
//                         //       .any((chartData) => chartData.year == _now.year - 1)) {
//                         //     setState(() => _selectedDate = [_now.year - 1, _now.month, _now.day]);
//                         //   }
//                         // }
//                         // }
//                       },
//                       icon: Container(
//                         padding: const EdgeInsets.all(4),
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.grey,
//                           //TODO:fix it
//                           // color: _monthDayChartDataList
//                           //         .any((chartData) => chartData.month == _now.month - 1)
//                           //     ? Colors.blue
//                           //     : Colors.grey,
//                         ),
//                         child: Transform(
//                           alignment: Alignment.center,
//                           transform: Matrix4.rotationY(math.pi),
//                           child: const Icon(
//                             Icons.arrow_forward_ios,
//                             color: Colors.white,
//                             size: 13,
//                           ),
//                         ),
//                       ),
//                     ),
//                     getChartTitle(value: _chartType!),
//                     IconButton(
//                       onPressed: () {
//                         //TODO:need to be update according weekly chart
//                         // if (_chartType == 0) {
//                         //   if (_monthDayChartDataList
//                         //       .any((chartData) => chartData.month == _now.month + 1)) {
//                         //     setState(() => _selectedDate = [_now.year, _now.month + 1, _now.day]);
//                         //   }
//                         // } else {
//                         //   if (_monthDayChartDataList
//                         //       .any((chartData) => chartData.year == _now.year + 1)) {
//                         //     setState(() => _selectedDate = [_now.year + 1, _now.month, _now.day]);
//                         //   }
//                         // }
//                       },
//                       icon: Container(
//                         padding: const EdgeInsets.all(4),
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.grey,
//                           //TODO:fix it
//                           // color: _monthDayChartDataList
//                           //         .any((chartData) => chartData.month == _now.month + 1)
//                           //     ? Colors.blue
//                           //     : Colors.grey,
//                         ),
//                         child: const Icon(
//                           Icons.arrow_forward_ios,
//                           color: Colors.white,
//                           size: 13,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: size.height * 0.02),
//               SizedBox(
//                 height: size.height * 0.25,
//                 width: size.width * 0.975,
//                 child: BarChart(
//                   BarChartData(
//                     maxY: 120,
//                     minY: 0,
//                     barTouchData: BarTouchData(enabled: false),
//                     titlesData: FlTitlesData(
//                       bottomTitles: SideTitles(
//                         showTitles: true,
//                         getTextStyles: (context, value) => const TextStyle(
//                           color: Color(0xff939393),
//                           fontSize: 10,
//                         ),
//                         margin: 10,
//                         interval: getBarInterval(timeRangeValue: _chartType!),
//                         getTitles: (value) => getBarTitles(
//                           titleValue: value.toInt(),
//                           timeRangeValue: _chartType!,
//                         ),
//                       ),
//                       leftTitles: SideTitles(
//                         showTitles: true,
//                         reservedSize: 30,
//                         getTitles: (value) => value == 120 ? '(%)' : value.toStringAsFixed(0),
//                         getTextStyles: (context, value) => value == 120
//                             ? const TextStyle(
//                                 color: Color(0xff939393),
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w600,
//                               )
//                             : const TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 10,
//                               ),
//                         margin: 10,
//                         interval: 20,
//                       ),
//                       topTitles: SideTitles(showTitles: false),
//                       rightTitles: SideTitles(showTitles: false),
//                     ),
//                     gridData: FlGridData(
//                       show: true,
//                       // checkToShowHorizontalLine: (value) => value % 10 == 0,
//                       getDrawingVerticalLine: (value) => FlLine(
//                         // color: const Color(0xffe7e8ec),
//                         strokeWidth: 0,
//                       ),
//                       getDrawingHorizontalLine: (value) => FlLine(
//                         color: const Color(0xffe7e8ec),
//                         strokeWidth: 1,
//                         dashArray: [3],
//                       ),
//                     ),
//                     borderData: FlBorderData(
//                         show: true,
//                         border: const Border(
//                           bottom: BorderSide(
//                             width: 0.5,
//                             color: Color(0xffd0d0d0),
//                           ),
//                           left: BorderSide(
//                             width: 0.5,
//                             color: Color(0xffd0d0d0),
//                           ),
//                         )),
//                     barGroups: getBarChartGroupData(
//                       timeRangeValue: _chartType!,
//                       chartDataList: _monthDayChartDataList,
//                     ),
//                   ),
//                   swapAnimationCurve: Curves.easeInOutCubic,
//                   swapAnimationDuration: const Duration(milliseconds: 1000),
//                 ),
//               ),
//
//               SizedBox(height: size.height * 0.03),
//
//               /// Time range selection
//               CupertinoSlidingSegmentedControl(
//                 groupValue: _chartType,
//                 children: const {0: Text('Week'), 1: Text('Month'), 2: Text('Year')},
//                 onValueChanged: (value) => setState(() => _chartType = value),
//               ),
//
//               SizedBox(height: size.height * 0.03),
//
//               /// Weekly completion
//               Container(
//                 width: double.infinity,
//                 height: size.height * 0.185,
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topRight,
//                     end: Alignment.bottomLeft,
//                     colors: [
//                       kPrimaryColor,
//                       Colors.lightBlueAccent,
//                     ],
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       heightFactor: 2,
//                       child: Text(
//                         'Weekly Completion',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w400,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: List.generate(
//                           kWeekDays.length,
//                           (index) => Expanded(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 ElevatedContainer(
//                                   blurRadius: 1,
//                                   width: 40,
//                                   height: 40,
//                                   child: Center(child: Image.asset('assets/images/3.png')),
//                                 ),
//                                 SizedBox(height: size.height * 0.01),
//                                 Text(
//                                   kWeekDays[index],
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: size.height * 0.01),
//               const SizedBox(
//                 width: double.infinity,
//                 child: Padding(
//                   padding: EdgeInsets.all(15),
//                   child: Text(
//                     'Drink Water Report',
//                     style: TextStyle(fontSize: 18),
//                     textAlign: TextAlign.left,
//                   ),
//                 ),
//               ),
//
//               buildReportRow(
//                 size: size,
//                 iconColor: Colors.green,
//                 title: 'Weekly average',
//                 content: '1955 ml / day',
//               ),
//               const Divider(),
//               buildReportRow(
//                 size: size,
//                 iconColor: kPrimaryColor,
//                 title: 'Monthly average',
//                 content: '$_monthlyDrinkAverage ml / day',
//               ),
//               const Divider(),
//               buildReportRow(
//                 size: size,
//                 iconColor: Colors.orange,
//                 title: 'Average completion',
//                 content: '$_averageCompletion%',
//               ),
//               const Divider(),
//               buildReportRow(
//                 size: size,
//                 iconColor: Colors.red,
//                 title: 'Drink frequency',
//                 content: '$_drinkFrequency times / day',
//               ),
//               const Divider(),
//
//               /// Tips
//               SizedBox(
//                 width: size.width * 0.95,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       flex: 3,
//                       child: ElevatedContainer(
//                           height: size.height * 0.085,
//                           color: kSecondaryColor,
//                           shadowColor: kSecondaryColor,
//                           shape: BoxShape.rectangle,
//                           padding: const EdgeInsets.all(8.0),
//                           blurRadius: 0.0,
//                           borderRadius: const BorderRadius.only(
//                             topLeft: kRadius_25,
//                             bottomRight: kRadius_25,
//                             bottomLeft: kRadius_25,
//                           ),
//                           child: Center(
//                             child: Text(
//                               getRandomTip(),
//                               style: const TextStyle(
//                                 color: Colors.black87,
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           )),
//                     ),
//                     SizedBox(width: size.width * 0.02),
//                     Expanded(
//                       child: Image.asset('assets/images/2.png', scale: 1),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: size.height * 0.02),
//             ],
//           ),
//         ),
//       );
//     });
//   }
//
//   /// Chart title widget
//   Text chartTitleWidget({required String text}) => Text(
//         text,
//         style: TextStyle(
//           color: Colors.grey[700],
//           fontSize: 15,
//         ),
//       );
//
//   /// Get chart title
//   Widget getChartTitle({required Object value}) {
//     if (value == 0) {
//       return chartTitleWidget(text: 'Week');
//     } else if (value == 1) {
//       return chartTitleWidget(text: '${kMonths[_selectedDate[1] - 1]} ${_selectedDate[0]}');
//     } else if (value == 2) {
//       return chartTitleWidget(text: '${_selectedDate[0]}');
//     }
//
//     return chartTitleWidget(text: '${kMonths[_selectedDate[1] - 1]} ${_selectedDate[0]}');
//   }
//
//   /// Get bar strings
//   String getBarTitles({
//     required int titleValue,
//     required Object timeRangeValue,
//   }) {
//     if (timeRangeValue == 0) {
//       return kWeekDays[titleValue];
//     } else if (timeRangeValue == 1) {
//       List<int> days = List.generate(monthDays(), (index) => index).toList();
//       // final List<ChartData> selectedMonthChartDataList =
//       // selectedMonthChartData(chartDataList: _monthDayChartDataList, selectedDate: _selectedDate);
//       return days[titleValue].toString();
//     } else if (timeRangeValue == 2) {
//       return kMonths[titleValue];
//     }
//
//     return '';
//   }
//
//   /// Get bar interval
//   double getBarInterval({required Object timeRangeValue}) {
//     if (timeRangeValue == 0) {
//       return 1;
//     } else if (timeRangeValue == 1) {
//       return 3;
//     } else if (timeRangeValue == 2) {
//       return 1;
//     }
//     return 1;
//   }
//
//   /// Get bar chart group data
//   List<BarChartGroupData> getBarChartGroupData({
//     required Object timeRangeValue,
//     required List<ChartData> chartDataList,
//   }) {
//     if (timeRangeValue == 0) {
//       return getWeekGroupData();
//     } else if (timeRangeValue == 1) {
//       return getMonthGroupData();
//     } else if (timeRangeValue == 2) {
//       return getYearGroupData();
//     }
//     return getWeekGroupData();
//   }
//
//   /// Get year group data
//   List<BarChartGroupData> getYearGroupData() => List.generate(
//         kMonths.length,
//         (index) => BarChartGroupData(
//           x: index,
//           barsSpace: 15,
//           barRods: [
//             BarChartRodData(
//               y: monthlyDrinkAverage(
//                       monthDayChartDataList: _provider.getChartDataList,
//                       month: index + 1,
//                       year: _now.year) *
//                   100 /
//                   _provider.getIntakeGoalAmount,
//               colors: [Colors.lightBlueAccent, kPrimaryColor],
//               borderRadius: BorderRadius.zero,
//             )
//           ],
//         ),
//       );
//
//   /// Get month group data
//   // List<BarChartGroupData> getMonthGroupData(List<ChartData> chartDataList) => chartDataList
//   //     .map<BarChartGroupData>(
//   //       (ChartData data) => BarChartGroupData(
//   //         x: data.day,
//   //         barRods: [
//   //           BarChartRodData(
//   //             y: data.percent,
//   //             colors: [Colors.lightBlueAccent, kPrimaryColor],
//   //             borderRadius: BorderRadius.zero,
//   //           )
//   //         ],
//   //       ),
//   //     )
//   //     .toList();
//   List<BarChartGroupData> getMonthGroupData() {
//     final List<ChartData> selectedMonthChartDataList =
//         selectedMonthChartData(chartDataList: _monthDayChartDataList, selectedDate: _selectedDate);
//     return List.generate(
//       selectedMonthChartDataList.length,
//       (index) => BarChartGroupData(
//         x: index + 1,
//         barRods: [
//           BarChartRodData(
//             y: selectedMonthChartDataList[index].percent,
//             colors: [Colors.lightBlueAccent, kPrimaryColor],
//             borderRadius: BorderRadius.zero,
//           )
//         ],
//       ),
//     );
//   }
//
//   //TODO:Get week group data
//   /// Get week group data
//   List<BarChartGroupData> getWeekGroupData() {
//     final List<ChartData> selectedMonthChartDataList =
//         selectedMonthChartData(chartDataList: _monthDayChartDataList, selectedDate: _selectedDate);
//     int weekCount;
//     if (selectedMonthChartDataList.length % 4 == 0) {
//       weekCount = 4;
//     } else {
//       weekCount = 5;
//     }
//
//     List<List<ChartData>> weekChartData = [];
//
//     for (int i = 0; i < weekCount; i++) {
//       for (int i = 0; i < selectedMonthChartDataList.length; i++) {}
//     }
//
//     return List.generate(
//       kWeekDays.length,
//       (index) => BarChartGroupData(
//         x: index,
//         barsSpace: 15,
//         barRods: [
//           BarChartRodData(
//             y: 38,
//             colors: [Colors.lightBlueAccent, kPrimaryColor],
//             borderRadius: BorderRadius.zero,
//           )
//         ],
//       ),
//     );
//   }
// }
