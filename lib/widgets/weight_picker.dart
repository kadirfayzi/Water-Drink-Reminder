import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/provider/data_provider.dart';

import '../constants.dart';
import '../functions.dart';

class WeightPicker extends StatelessWidget {
  const WeightPicker({
    Key? key,
    required this.childCount,
  }) : super(key: key);
  final int childCount;

  @override
  Widget build(BuildContext context) => Consumer<DataProvider>(
        builder: (context, provider, _) => CupertinoPicker.builder(
          scrollController: FixedExtentScrollController(initialItem: provider.getWeight),
          itemExtent: 45,
          onSelectedItemChanged: (weight) {
            provider.setTempWeight = weight;
            if (provider.getWeightUnit == 0) {
              provider.setWeight = weight;
              provider.setIntakeGoalAmount = Functions.calculateIntakeGoalAmount(
                weight: weight,
                gender: provider.getGender,
              );
            } else {
              int convertedWeight = Functions.lbsToKg(weight);
              provider.setWeight = convertedWeight;
              provider.setIntakeGoalAmount = Functions.calculateIntakeGoalAmount(
                weight: convertedWeight,
                gender: provider.getGender,
              );
            }
          },
          childCount: childCount,
          itemBuilder: (context, index) => Text(
            index.toString(),
            style: const TextStyle(
              fontSize: 35,
              color: kPrimaryColor,
            ),
          ),
        ),
      );
}
