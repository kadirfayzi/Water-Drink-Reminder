import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/functions.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HowMuchShouldDrink extends StatelessWidget {
  const HowMuchShouldDrink({
    Key? key,
    required this.provider,
    required this.localize,
    required this.size,
  }) : super(key: key);
  final DataProvider provider;
  final AppLocalizations localize;
  final Size size;

  @override
  Widget build(BuildContext context) => Column(
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
                        'x${provider.getHowManyTimes}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width * 0.08,
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Text(
                        '~ ${provider.getCapacityUnit == 0 ? provider.getHowMuchEachTime : Functions.mlToFlOz(provider.getHowMuchEachTime.toDouble()).toStringAsFixed(0)}'
                        ' ${kCapacityUnitStrings[provider.getCapacityUnit]}',
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
          SizedBox(
            width: size.width * 0.95,
            child: Center(
              child: Text(
                localize.howMuchShouldDrink,
                style: TextStyle(
                  fontSize: size.width * 0.06,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.03),
          Text(
            localize.timesADay('${provider.getHowManyTimes}'),
            style: TextStyle(
              fontSize: size.width * 0.05,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            localize.eachTime(
                '~ ${provider.getCapacityUnit == 0 ? provider.getHowMuchEachTime : Functions.mlToFlOz(provider.getHowMuchEachTime.toDouble()).toStringAsFixed(0)}'
                ' ${kCapacityUnitStrings[provider.getCapacityUnit]}'),
            style: TextStyle(
              fontSize: size.width * 0.05,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      );
}
