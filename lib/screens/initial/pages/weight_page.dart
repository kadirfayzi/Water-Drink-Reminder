import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/constants.dart';
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
            const Text(
              'Your Weight',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: size.height * 0.2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  provider.getGender == 0
                      ? 'assets/images/boy.png'
                      : 'assets/images/girl.png',
                  scale: 5,
                ),
                SizedBox(width: size.width * 0.1),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width * 0.25,
                      height: size.height * 0.2,
                      child: CupertinoPicker(
                        key: ValueKey<Object>(provider.getWeightUnit),
                        onSelectedItemChanged: (weight) =>
                            provider.setWeight(weight, provider.getWeightUnit),
                        itemExtent: 48,
                        scrollController: FixedExtentScrollController(
                          initialItem: provider.getWeight,
                        ),
                        children: List.generate(
                          kWeightChildCount[provider.getWeightUnit],
                          (index) => Center(
                            child: Text(
                              index.toString(),
                              style: const TextStyle(
                                fontSize: 35,
                                color: Colors.blue,
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
                        onValueChanged: (value) =>
                            provider.setUnit(value as int, 0),
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
