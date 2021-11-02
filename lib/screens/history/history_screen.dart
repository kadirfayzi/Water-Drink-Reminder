import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/functions.dart';
import 'package:water_reminder/models/chart_data_model.dart';
import 'package:water_reminder/widgets/elevated_container.dart';
import 'package:water_reminder/widgets/sliding_switch.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.01),
            SizedBox(
              height: size.height * 0.28,
              child: SfCartesianChart(
                  title: ChartTitle(
                      text: 'October 2021',
                      textStyle: const TextStyle(
                        fontSize: 14,
                      )),

                  // tooltipBehavior: TooltipBehavior(enable: true),
                  // primaryXAxis: DateTimeAxis(
                  //     // Interval type will be months
                  //     intervalType: DateTimeIntervalType.days,
                  //     interval: 1),
                  primaryYAxis: NumericAxis(
                    maximum: 100,
                    interval: 20,
                    majorGridLines: const MajorGridLines(width: 1, dashArray: <double>[2, 4]),
                    // minorGridLines: const MinorGridLines(
                    //     width: 1, color: Colors.green, dashArray: <double>[5, 5]),
                    // minorTicksPerInterval: 2,
                  ),
                  primaryXAxis: NumericAxis(
                    maximum: 30,
                    interval: 5,
                    // minorTicksPerInterval: 1,
                  ),
                  series: <CartesianSeries<ChartData, dynamic>>[
                    ColumnSeries<ChartData, dynamic>(
                      dataSource: chartData,
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
            SlidingSwitch(
              value: false,
              width: size.width * 0.3,
              height: size.height * 0.035,
              onChanged: (value) {},
              onTap: () {},
              onSwipe: () {},
              textLeft: 'Month',
              textRight: 'Year',
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
                              )),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.01),
            const Align(
              alignment: Alignment.centerLeft,
              heightFactor: 2,
              widthFactor: 2.35,
              child: Text(
                'Drink Water Report',
                style: TextStyle(fontSize: 18),
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
  }

  SizedBox buildReportRow({
    required Size size,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return SizedBox(
      height: size.height * 0.0625,
      width: size.width * 0.95,
      child: Row(
        children: [
          Expanded(child: Icon(Icons.circle, size: 12, color: iconColor)),
          Expanded(flex: 6, child: Text(title)),
          Expanded(
            flex: 3,
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: kPrimaryColor,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTimeRangeSelectionButton({
    required Size size,
    required String title,
    required Color color,
    required Color textColor,
    required Function() onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size.width * 0.15,
          height: size.height * 0.03,
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: kPrimaryColor, width: 1.5),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 13, color: textColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

final List<ChartData> chartData = [
  ChartData(1, 35),
  ChartData(12, 58),
  ChartData(3, 34),
  ChartData(4, 100),
  ChartData(15, 40),
  ChartData(6, 35),
  ChartData(27, 38),
  ChartData(18, 44),
  ChartData(29, 90),
  ChartData(21, 40),
];
