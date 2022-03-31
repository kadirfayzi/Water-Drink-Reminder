import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:water_reminder/models/cup.dart';
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
  setInitialSettingsValue() {
    final DataProvider provider = DataProvider();
    final DateTime now = DateTime.now();
    provider.setLangCode = ui.window.locale.languageCode;

    if (provider.getCups.isEmpty) {
      for (Cup cup in kCups) {
        provider.addCup = cup;
      }
    }

    provider.setWeight = 70;
    provider.setGender = 0;
    provider.setIntakeGoalAmount = 2800;
    provider.setSoundValue = 2;
    provider.setWeightUnit = 0;
    provider.setCapacityUnit = 0;
    provider.setWakeUpTime(7, 0);
    provider.setBedTime(23, 0);
    provider.addDrankAmount = 0;
    if (provider.getChartDataList.isEmpty) {
      int currentMonthDaysCount = getCurrentMonthDaysCount(now: now);
      for (int i = 1; i <= currentMonthDaysCount; i++) {
        provider.addToChartData(
          day: i,
          month: now.month,
          year: now.year,
          drankAmount: 0,
          intakeGoalAmount: 2800,
          recordCount: 0,
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
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
            opacity: 0.25,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 800),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                Text(
                  AppLocalizations.of(context)!.appGreeting1,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Text(
                  AppLocalizations.of(context)!.appGreeting2,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: size.height * 0.1),
                Container(
                  width: size.width * 0.8,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(kRadius_30),
                    gradient: LinearGradient(
                      colors: [kPrimaryColor, Colors.blue],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(0.5, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),
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
                          AppLocalizations.of(context)!.letsGo,
                          style: const TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
