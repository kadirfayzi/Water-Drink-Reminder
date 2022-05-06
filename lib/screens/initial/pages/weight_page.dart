import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:water_reminder/provider/data_provider.dart';

import '../../../widgets/weight_picker.dart';

class WeightPage extends StatelessWidget {
  const WeightPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<DataProvider>(
      builder: (context, provider, _) => Column(
        children: [
          Text(
            AppLocalizations.of(context)!.yourWeight,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xff000000),
            ),
          ),
          SizedBox(height: size.height * 0.1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                provider.getGender == 0
                    ? 'assets/images/intro/weight_male.png'
                    : 'assets/images/intro/weight_female.png',
                scale: 3,
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.width * 0.25,
                    height: size.height * 0.25,
                    child: provider.getWeightUnit == 0
                        ? WeightPicker(
                            key: ValueKey(provider.getWeightUnit),
                            childCount: 400,
                          )
                        : const WeightPicker(childCount: 882),
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
        ],
      ),
    );
  }
}
