import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:water_reminder/models/cup.dart';
import 'package:water_reminder/models/drunk_amount.dart';
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
    final provider = DataProvider();

    if (provider.getCups.length == 0) {
      for (Cup cup in kCups) {
        provider.addCup = cup;
      }
    }

    provider.setWeight = 70;
    provider.setGender = 0;
    provider.setIntakeGoalAmount = 2800;
    provider.setSoundValue = 2;
    provider.setUnit(0, 0);
    provider.setWakeUpTime(7, 0);
    provider.setBedTime(23, 0);
    provider.addDrunkAmount = DrunkAmount(drunkAmount: 0);
    if (provider.getMonthDayChartDataList.length == 0) {
      for (int i = 1; i <= monthDays(); i++) {
        provider.addMonthDayChartData(
          day: i,
          drunkAmount: 0,
          intakeGoalAmount: 2800,
        );
      }
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hi,\nI\'m your personal hydration companion',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: size.height * 0.03),
            const Text(
              'In order to provide tailored hydration advice,I need to get some basic information. And I\'ll keep this a secret.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: size.height * 0.1),
            Container(
              width: size.width * 0.8,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(kRadius_30),
                gradient: LinearGradient(
                  colors: [Colors.lightBlueAccent, Colors.blue],
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
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'LET\'S GO',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
