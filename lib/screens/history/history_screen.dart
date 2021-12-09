import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/functions.dart';
import 'package:water_reminder/models/chart_data_model.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/widgets/elevated_container.dart';
import 'history_helpers.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Object? timeRangeValue = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<DataProvider>(builder: (context, provider, _) {
      return Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.01),
              SizedBox(
                height: size.height * 0.25,
                child: SfCartesianChart(
                    title: ChartTitle(
                      text: 'October 2021',
                      textStyle: const TextStyle(
                        fontSize: 14,
                      ),
                    ),

                    // tooltipBehavior: TooltipBehavior(enable: true),
                    // primaryXAxis: DateTimeAxis(
                    //     // Interval type will be months
                    //     intervalType: DateTimeIntervalType.days,
                    //     interval: 1),
                    primaryYAxis: NumericAxis(
                      maximum: 100,
                      interval: 20,
                      labelStyle: const TextStyle(fontSize: 10),
                      majorGridLines: const MajorGridLines(width: 1, dashArray: <double>[2, 4]),
                      // minorGridLines: const MinorGridLines(
                      //     width: 0.2, color: Colors.grey, dashArray: <double>[3, 3]),
                      // minorTicksPerInterval: 1,
                    ),
                    primaryXAxis: NumericAxis(
                      minimum: 1,
                      maximum: 30,
                      interval: 3,
                      minorTicksPerInterval: 2,
                      labelStyle: const TextStyle(fontSize: 10),
                    ),
                    series: <CartesianSeries<ChartData, dynamic>>[
                      ColumnSeries<ChartData, dynamic>(
                        // dataSource: chartData,
                        dataSource: provider.getMonthDayChartDataList,
                        xValueMapper: (ChartData chartData, _) => chartData.x,
                        yValueMapper: (ChartData chartData, _) => chartData.y,
                        width: 0.8,
                        color: kPrimaryColor,

                        // dataLabelSettings: const DataLabelSettings(isVisible: true),
                      ),
                    ]),
              ),
              // SizedBox(height: size.height * 0.005),

              /// Time range selection

              CupertinoSlidingSegmentedControl(
                groupValue: timeRangeValue,
                children: const {0: Text('Month'), 1: Text('Year')},
                onValueChanged: (value) => setState(() => timeRangeValue = value),
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
                )),
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
                                  child: Center(child: Image.asset('assets/images/3.png')),
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
                            topLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                            bottomLeft: Radius.circular(25),
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
                      child: Image.asset(
                        'assets/images/2.png',
                        scale: 1,
                      ),
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
}
