import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/provider/data_provider.dart';

import '../../../constants.dart';
import '../../../functions.dart';
import 'report_row.dart';

class DrinkWaterReport extends StatelessWidget {
  const DrinkWaterReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final localize = AppLocalizations.of(context)!;
    return Consumer<DataProvider>(
      builder: (context, provider, _) => Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: Text(
                localize.drinkWaterReport,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Container(
            width: size.width * 0.95,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: kPrimaryColor.withOpacity(0.1),
            ),
            child: Column(
              children: [
                ReportRow(
                  size: size,
                  iconColor: Colors.green,
                  title: localize.weeklyAverage,
                  content:
                      '${provider.getCapacityUnit == 0 ? provider.weeklyAverage.toStringAsFixed(0) : Functions.mlToFlOz(provider.weeklyAverage).toStringAsFixed(1)} '
                      '${kCapacityUnitStrings[provider.getCapacityUnit]} / ${localize.day}',
                ),
                Divider(
                  thickness: 1,
                  indent: size.width * 0.05,
                  endIndent: size.width * 0.05,
                ),
                ReportRow(
                  size: size,
                  iconColor: kPrimaryColor,
                  title: localize.monthlyAverage,
                  content:
                      '${provider.getCapacityUnit == 0 ? provider.monthlyAverage.toStringAsFixed(0) : Functions.mlToFlOz(provider.monthlyAverage).toStringAsFixed(1)} '
                      '${kCapacityUnitStrings[provider.getCapacityUnit]} / ${localize.day}',
                ),
                Divider(
                  thickness: 1,
                  indent: size.width * 0.05,
                  endIndent: size.width * 0.05,
                ),
                ReportRow(
                  size: size,
                  iconColor: Colors.orange,
                  title: localize.averageCompletion,
                  content: '${provider.averageCompletion}%',
                ),
                Divider(
                  thickness: 1,
                  indent: size.width * 0.05,
                  endIndent: size.width * 0.05,
                ),
                ReportRow(
                  size: size,
                  iconColor: Colors.red,
                  title: localize.drinkFrequency,
                  content: '${provider.drinkFrequency} ${localize.times} / ${localize.day}',
                ),
                SizedBox(height: size.height * 0.01),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
