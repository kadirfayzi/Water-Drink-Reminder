import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:water_reminder/provider/data_provider.dart';

class WeightPage extends StatefulWidget {
  const WeightPage({Key? key}) : super(key: key);

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<DataProvider>(
      builder: (context, provider, _) {
        return Column(
          children: [
            Text(
              AppLocalizations.of(context)!.yourWeight,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: size.height * 0.2),
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
                    provider.getGender == 0 ? 'assets/images/boy.png' : 'assets/images/girl.png',
                    scale: 5,
                  ),
                  SizedBox(width: size.width * 0.1),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width * 0.25,
                        height: size.height * 0.25,
                        child: CupertinoPicker(
                          key: ValueKey(provider.getWeightUnit),
                          scrollController: FixedExtentScrollController(
                            initialItem: provider.getWeight,
                          ),
                          useMagnifier: true,
                          magnification: 1.15,
                          onSelectedItemChanged: (weight) {
                            provider.setTempWeight = weight;
                            if (provider.getWeightUnit == 0) {
                              provider.setWeight = weight;
                              provider.setIntakeGoalAmount = calculateIntakeGoalAmount(weight);
                            } else {
                              int convertedWeight = lbsToKg(weight);
                              provider.setWeight = convertedWeight;
                              provider.setIntakeGoalAmount =
                                  calculateIntakeGoalAmount(convertedWeight);
                            }
                          },
                          itemExtent: 48,
                          children: List.generate(
                            kWeightChildCount[provider.getWeightUnit],
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
                      SizedBox(height: size.height * 0.02),
                      SizedBox(
                        width: size.width * 0.3,
                        child: CupertinoSlidingSegmentedControl(
                          groupValue: provider.getWeightUnit,
                          children: const {0: Text('kg'), 1: Text('lbs')},
                          onValueChanged: (value) {
                            value as int;
                            provider.setWeightUnit = value;
                            provider.setCapacityUnit = value;
                            provider.setTempWeight = provider.getWeight;
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
      },
    );
  }
}
