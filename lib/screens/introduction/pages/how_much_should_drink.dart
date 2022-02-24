import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:water_reminder/provider/data_provider.dart';

class HowMuchShouldDrink extends StatefulWidget {
  const HowMuchShouldDrink({Key? key}) : super(key: key);

  @override
  _HowMuchShouldDrinkState createState() => _HowMuchShouldDrinkState();
}

class _HowMuchShouldDrinkState extends State<HowMuchShouldDrink> {
  late int howManyTimes;
  late int howMuchEachTime;
  setHowMuchShouldDrink() {
    final provider = DataProvider();
    int wakeUpHour = provider.getWakeUpTimeHour;
    int bedHour = provider.getBedTimeHour;
    if (wakeUpHour >= bedHour) bedHour += 24;
    howManyTimes = (bedHour - wakeUpHour) ~/ 1.5;
    howMuchEachTime = provider.getIntakeGoalAmount ~/ howManyTimes;
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
                      '$howMuchEachTime ml',
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
          'How much should you drink',
          style: TextStyle(
            fontSize: size.width * 0.06,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: size.height * 0.03),
        Text(
          '$howManyTimes times a day',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[700],
          ),
        ),
        Text(
          '$howMuchEachTime ml each time',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
