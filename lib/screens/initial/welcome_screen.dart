import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:water_reminder/provider/data_provider.dart';

import '../../constants.dart';
import '../../functions.dart';
import 'initial_preferences_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  void setInitialSettingsValue() {
    final DataProvider provider = DataProvider();
    final DateTime now = DateTime.now();
    provider.setLangCode = ui.window.locale.languageCode;
    provider.setWeight = 70;
    provider.setGender = 0;
    provider.setIntakeGoalAmount = 2800;
    provider.setSoundValue = 0;
    provider.setWeightUnit = 0;
    provider.setCapacityUnit = 0;
    provider.setWakeUpTime(7, 0);
    provider.setBedTime(23, 0);
    provider.addDrankAmount = 0;
    if (provider.getChartDataList.isEmpty) {
      int currentMonthDaysCount = Functions.getCurrentMonthDaysCount(now: now);
      for (int i = 1; i <= currentMonthDaysCount; i++) {
        provider.addToChartData(
          day: i,
          month: now.month,
          year: now.year,
          drankAmount: 0,
          intakeGoalAmount: 2800,
          recordCount: 0,
          addMonth: true,
        );
      }
    }

    /// Set initial weekdays
    for (int i = 1; i <= 7; i++) {
      provider.addToWeekData(
        drankAmount: 0,
        day: i,
        intakeGoalAmount: 2800,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    setInitialSettingsValue();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final localize = AppLocalizations.of(context)!;
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
            opacity: 0.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width * 0.95,
                child: Text(
                  localize.appGreeting1,
                  style: TextStyle(
                    fontSize: size.width * 0.065,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              SizedBox(
                width: size.width * 0.95,
                child: Text(
                  localize.appGreeting2,
                  style: TextStyle(
                    fontSize: size.width * 0.04,
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: size.height * 0.1),
              Container(
                width: size.width * 0.8,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(kRadius_30),
                  color: kPrimaryColor,
                ),
                child: InkWell(
                  borderRadius: const BorderRadius.all(kRadius_30),
                  onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (ctx) => const InitialPreferences(),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        localize.letsGo,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width * 0.05,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
