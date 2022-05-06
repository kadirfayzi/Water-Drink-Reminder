import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/provider/data_provider.dart';

import '../../../constants.dart';

class WeeklyCompletion extends StatelessWidget {
  const WeeklyCompletion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final localize = AppLocalizations.of(context)!;
    String weekDayString(int day) => DateFormat.E(
          Localizations.localeOf(context).languageCode,
        ).format(DateTime(DateTime.now().year, DateTime.now().month, day + 3));
    return Consumer<DataProvider>(
      builder: (context, provider, _) => Container(
        width: size.width * 0.95,
        height: size.height * 0.2,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topRight: kRadius_50,
            bottomLeft: kRadius_50,
          ),
          color: kPrimaryColor.withOpacity(0.1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    localize.weeklyCompletion,
                    style: TextStyle(
                      fontSize: size.width * 0.04,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '${provider.weeklyPercent.toStringAsFixed(2)}%',
                    style: TextStyle(
                      fontSize: size.width * 0.04,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: provider.getWeekDataList
                    .map(
                      (weekData) => Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: size.width * 0.12,
                              height: size.width * 0.12,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.water_drop,
                                  size: size.width * 0.085,
                                  color: weekData.drankAmount > 0 ? kPrimaryColor : Colors.black26,
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.01),
                            Text(
                              weekDayString(weekData.day),
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: size.width * 0.03,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
