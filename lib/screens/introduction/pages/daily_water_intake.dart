import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/functions.dart';
import 'package:water_reminder/provider/data_provider.dart';

class DailyWaterIntake extends StatefulWidget {
  const DailyWaterIntake({Key? key, required this.provider}) : super(key: key);
  final DataProvider provider;
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
          AppLocalizations.of(context)!.dailyWaterIntake,
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
                  widget.provider.getCapacityUnit == 0
                      ? widget.provider.getIntakeGoalAmount.toStringAsFixed(0)
                      : mlToFlOz(widget.provider.getIntakeGoalAmount).toStringAsFixed(0),
                  textStyle: TextStyle(
                    fontSize: size.width * 0.15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Text(
              ' ${kCapacityUnitStrings[widget.provider.getCapacityUnit]}',
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
