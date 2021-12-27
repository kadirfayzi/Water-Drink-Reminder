import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/provider/data_provider.dart';

class DailyWaterIntake extends StatefulWidget {
  const DailyWaterIntake({Key? key}) : super(key: key);

  @override
  _DailyWaterIntakeState createState() => _DailyWaterIntakeState();
}

class _DailyWaterIntakeState extends State<DailyWaterIntake> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Your proper daily water intake',
          style: TextStyle(
            fontSize: size.width * 0.06,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: size.height * 0.05),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            AnimatedTextKit(
              totalRepeatCount: 1,
              animatedTexts: [
                WavyAnimatedText(
                  '${Provider.of<DataProvider>(context, listen: false).getIntakeGoalAmount.toStringAsFixed(0)}',
                  textStyle: TextStyle(
                    fontSize: size.width * 0.15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Text(
              kCapacityUnitStrings[
                  Provider.of<DataProvider>(context, listen: false)
                      .getCapacityUnit],
              style: TextStyle(
                fontSize: size.width * 0.08,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        SizedBox(height: size.height * 0.03),
        SizedBox(
          width: size.width * 0.5,
          child: Lottie.asset(
            'assets/lotties/water-bottles.json',
            repeat: false,
          ),
        ),
      ],
    );
  }
}
