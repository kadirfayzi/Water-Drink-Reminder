import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/functions.dart';
import 'package:water_reminder/provider/data_provider.dart';

class DailyWaterIntake extends StatefulWidget {
  const DailyWaterIntake({
    Key? key,
    required this.provider,
    required this.localize,
    required this.size,
  }) : super(key: key);
  final DataProvider provider;
  final AppLocalizations localize;
  final Size size;
  @override
  _DailyWaterIntakeState createState() => _DailyWaterIntakeState();
}

class _DailyWaterIntakeState extends State<DailyWaterIntake> {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: widget.size.width * 0.95,
            child: Center(
              child: Text(
                widget.localize.dailyWaterIntake,
                style: TextStyle(
                  fontSize: widget.size.width * 0.05,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: widget.size.height * 0.05),
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
                        : Functions.mlToFlOz(widget.provider.getIntakeGoalAmount)
                            .toStringAsFixed(0),
                    textStyle: TextStyle(
                      fontSize: widget.size.width * 0.15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Text(
                ' ${kCapacityUnitStrings[widget.provider.getCapacityUnit]}',
                style: TextStyle(
                  fontSize: widget.size.width * 0.08,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: widget.size.height * 0.03),
          SizedBox(
            width: widget.size.width * 0.5,
            child: Lottie.asset(
              'assets/lotties/water-bottles.json',
              repeat: false,
            ),
          ),
        ],
      );
}
