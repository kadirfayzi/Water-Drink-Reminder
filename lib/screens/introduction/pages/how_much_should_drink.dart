import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/functions.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HowMuchShouldDrink extends StatefulWidget {
  const HowMuchShouldDrink({Key? key, required this.provider}) : super(key: key);
  final DataProvider provider;

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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size.width * 0.5,
          height: size.width * 0.5,
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
                        fontSize: size.width * 0.08,
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Text(
                      '~ ${widget.provider.getCapacityUnit == 0 ? howMuchEachTime : mlToFlOz(howMuchEachTime.toDouble()).toStringAsFixed(0)}'
                      ' ${kCapacityUnitStrings[widget.provider.getCapacityUnit]}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.05,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: size.height * 0.05),
        Text(
          AppLocalizations.of(context)!.howMuchShouldDrink,
          style: TextStyle(
            fontSize: size.width * 0.06,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: size.height * 0.03),
        Text(
          AppLocalizations.of(context)!.timesADay('$howManyTimes'),
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[700],
          ),
        ),
        Text(
          AppLocalizations.of(context)!.eachTime(
              '~ ${widget.provider.getCapacityUnit == 0 ? howMuchEachTime : mlToFlOz(howMuchEachTime.toDouble()).toStringAsFixed(0)}'
              ' ${kCapacityUnitStrings[widget.provider.getCapacityUnit]}'),
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
