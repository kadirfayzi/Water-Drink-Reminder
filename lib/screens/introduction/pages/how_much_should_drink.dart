import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/functions.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HowMuchShouldDrink extends StatefulWidget {
  const HowMuchShouldDrink({
    Key? key,
    required this.provider,
    required this.localize,
    required this.size,
  }) : super(key: key);
  final DataProvider provider;
  final AppLocalizations localize;
  final Size size;

  @override
  _HowMuchShouldDrinkState createState() => _HowMuchShouldDrinkState();
}

class _HowMuchShouldDrinkState extends State<HowMuchShouldDrink> {
  late int howManyTimes;
  late int howMuchEachTime;
  setHowMuchShouldDrink() {
    int wakeUpHour = widget.provider.getWakeUpTimeHour;
    int bedHour = widget.provider.getBedTimeHour;
    if (wakeUpHour >= bedHour) bedHour += 24;
    howManyTimes = (bedHour - wakeUpHour) ~/ 1.5;
    howMuchEachTime = widget.provider.getIntakeGoalAmount ~/ howManyTimes;
  }

  @override
  void initState() {
    super.initState();
    setHowMuchShouldDrink();
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: widget.size.width * 0.5,
            height: widget.size.width * 0.5,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Lottie.asset(
                    'assets/lotties/water-glass.json',
                    repeat: false,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'x$howManyTimes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.size.width * 0.08,
                        ),
                      ),
                      SizedBox(height: widget.size.height * 0.01),
                      Text(
                        '~ ${widget.provider.getCapacityUnit == 0 ? howMuchEachTime : mlToFlOz(howMuchEachTime.toDouble()).toStringAsFixed(0)}'
                        ' ${kCapacityUnitStrings[widget.provider.getCapacityUnit]}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.size.width * 0.05,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: widget.size.height * 0.05),
          SizedBox(
            width: widget.size.width * 0.95,
            child: Center(
              child: Text(
                widget.localize.howMuchShouldDrink,
                style: TextStyle(
                  fontSize: widget.size.width * 0.06,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: widget.size.height * 0.03),
          Text(
            widget.localize.timesADay('$howManyTimes'),
            style: TextStyle(
              fontSize: widget.size.width * 0.05,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            widget.localize.eachTime(
                '~ ${widget.provider.getCapacityUnit == 0 ? howMuchEachTime : mlToFlOz(howMuchEachTime.toDouble()).toStringAsFixed(0)}'
                ' ${kCapacityUnitStrings[widget.provider.getCapacityUnit]}'),
            style: TextStyle(
              fontSize: widget.size.width * 0.05,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      );
}
