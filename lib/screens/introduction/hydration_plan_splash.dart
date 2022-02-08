import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/functions.dart';
import 'package:water_reminder/models/schedule_record.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/screens/introduction/introduction_screen.dart';

class HydrationPlanSplash extends StatefulWidget {
  const HydrationPlanSplash({Key? key}) : super(key: key);

  @override
  State<HydrationPlanSplash> createState() => _HydrationPlanSplashState();
}

class _HydrationPlanSplashState extends State<HydrationPlanSplash>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  setHydrationPlan() {
    final provider = DataProvider();
    if (provider.getWeightUnit == 0) {
      provider.setIntakeGoalAmount =
          calculateIntakeGoalAmount(provider.getWeight);
    } else {
      final int weight = lbsToKg(provider.getWeight);
      provider.setIntakeGoalAmount = calculateIntakeGoalAmount(weight);
    }

    int reminderCount = calculateReminderCount(
      provider.getBedTimeHour,
      provider.getWakeUpTimeHour,
    );

    int hour = provider.getWakeUpTimeHour;
    int minute = provider.getWakeUpTimeMinute;
    for (int i = 0; i <= reminderCount; i++) {
      if (hour <= provider.getBedTimeHour) {
        provider.addScheduleRecord = ScheduleRecord(
          time: '${twoDigits(hour)}:${twoDigits(minute)}',
          isSet: true,
        );
      }
      minute += 30;
      hour += 1;
      if (minute >= 60) {
        hour += 1;
        minute -= 60;
      }
    }

    provider.setIsInitialPrefsSet = true;
  }

  @override
  void initState() {
    super.initState();
    setHydrationPlan();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    _animationController.addListener(() => setState(() {}));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = _animationController.value * 100;
    final size = MediaQuery.of(context).size;

    if (percentage.toStringAsFixed(0) == '100') {
      _animationController.stop();
      Future.delayed(
        const Duration(milliseconds: 800),
        () => WidgetsBinding.instance?.addPostFrameCallback(
          (_) => Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                builder: (context) => const IntroductionScreen(),
              ),
              (route) => false),
        ),
      );
    }

    return Scaffold(
      body: LiquidLinearProgressIndicator(
        value: _animationController.value,
        valueColor: const AlwaysStoppedAnimation(
          Colors.blue,
        ), // Defaults to the current Theme's accentColor.
        backgroundColor:
            Colors.white, // Defaults to the current Theme's backgroundColor.
        borderColor: Colors.white,
        borderWidth: 0.0,
        direction: Axis
            .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Generating your hydration plan...',
              style: TextStyle(
                fontSize: 20,
                color: _animationController.value < 0.7
                    ? Colors.blue
                    : Colors.white,
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  Provider.of<DataProvider>(context, listen: false).getGender ==
                          0
                      ? 'assets/images/boy.png'
                      : 'assets/images/girl.png',
                  scale: 4,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: percentage.toStringAsFixed(0) != '100'
                      ? size.width * 0.275
                      : size.width * 0.35,
                  child: Text(
                    percentage.toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: size.width * 0.2,
                      color: _animationController.value < 0.35
                          ? Colors.blue
                          : Colors.white,
                    ),
                  ),
                ),
                Text(
                  '%',
                  style: TextStyle(
                    fontSize: size.width * 0.2,
                    color: _animationController.value < 0.3
                        ? Colors.blue
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
