import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:water_reminder/constants.dart';
import 'package:water_reminder/functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:water_reminder/provider/data_provider.dart';

class WeightPage extends StatefulWidget {
  const WeightPage({
    Key? key,
    required this.size,
    required this.localize,
    required this.provider,
  }) : super(key: key);

  final Size size;
  final AppLocalizations localize;
  final DataProvider provider;

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(
            widget.localize.yourWeight,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: widget.size.height * 0.2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 800),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                Image.asset(
                  widget.provider.getGender == 0
                      ? 'assets/images/boy.png'
                      : 'assets/images/girl.png',
                  scale: 5,
                ),
                SizedBox(width: widget.size.width * 0.1),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: widget.size.width * 0.25,
                      height: widget.size.height * 0.25,
                      child: CupertinoPicker(
                        key: ValueKey(widget.provider.getWeightUnit),
                        scrollController: FixedExtentScrollController(
                          initialItem: widget.provider.getWeight,
                        ),
                        useMagnifier: true,
                        magnification: 1.15,
                        onSelectedItemChanged: (weight) {
                          widget.provider.setTempWeight = weight;
                          if (widget.provider.getWeightUnit == 0) {
                            widget.provider.setWeight = weight;
                            widget.provider.setIntakeGoalAmount =
                                Functions.calculateIntakeGoalAmount(
                              weight: weight,
                              gender: widget.provider.getGender,
                            );
                          } else {
                            int convertedWeight = Functions.lbsToKg(weight);
                            widget.provider.setWeight = convertedWeight;
                            widget.provider.setIntakeGoalAmount =
                                Functions.calculateIntakeGoalAmount(
                              weight: convertedWeight,
                              gender: widget.provider.getGender,
                            );
                          }
                        },
                        itemExtent: 48,
                        children: List.generate(
                          kWeightChildCount[widget.provider.getWeightUnit],
                          (index) => Center(
                            child: Text(
                              index.toString(),
                              style: const TextStyle(
                                fontSize: 35,
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: widget.size.height * 0.02),
                    SizedBox(
                      width: widget.size.width * 0.3,
                      child: CupertinoSlidingSegmentedControl(
                        groupValue: widget.provider.getWeightUnit,
                        children: const {0: Text('kg'), 1: Text('lbs')},
                        onValueChanged: (value) {
                          value as int;
                          widget.provider.setWeightUnit = value;
                          widget.provider.setCapacityUnit = value;
                          widget.provider.setTempWeight = widget.provider.getWeight;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
}
