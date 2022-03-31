import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:water_reminder/functions.dart';
import 'package:water_reminder/models/schedule_record.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/screens/introduction/introduction_screen.dart';
import 'package:water_reminder/services/notification_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/liquid_progress_indicator/liquid_linear_progress_indicator.dart';

class HydrationPlanSplash extends StatefulWidget {
  const HydrationPlanSplash({Key? key}) : super(key: key);

  @override
  State<HydrationPlanSplash> createState() => _HydrationPlanSplashState();
}

class _HydrationPlanSplashState extends State<HydrationPlanSplash> with TickerProviderStateMixin {
  late AnimationController _animationController;

  late final DataProvider _provider;
  late final NotificationHelper _notificationHelper;
  late final Random _random;

  setHydrationPlan() {
    _provider = DataProvider();
    _notificationHelper = NotificationHelper();
    _random = Random();

    /// Set initial schedule records
    int wakeUpHour = _provider.getWakeUpTimeHour;
    int minute = _provider.getWakeUpTimeMinute;
    int bedHour = _provider.getBedTimeHour;
    if (wakeUpHour >= bedHour) bedHour += 24;

    int reminderCount = calculateReminderCount(
      bedHour: bedHour,
      wakeUpHour: wakeUpHour,
    );

    for (int i = 0; i <= reminderCount; i++) {
      if (wakeUpHour < bedHour) {
        int tempWakeUpHour = wakeUpHour;
        if (wakeUpHour >= 24) tempWakeUpHour -= 24;

        _provider.addScheduleRecord = ScheduleRecord(
          id: _random.nextInt(1000000000),
          time: '${twoDigits(tempWakeUpHour)}:${twoDigits(minute)}',
          isSet: true,
        );
      }
      minute += 30;
      wakeUpHour += 1;
      if (minute >= 60) {
        wakeUpHour += 1;
        minute -= 60;
      }
    }

    /// Set initial notifications
    for (int i = 0; i < _provider.getScheduleRecords.length; i++) {
      _notificationHelper.scheduledNotification(
        hour: int.parse(_provider.getScheduleRecords[i].time.split(":")[0]),
        minutes: int.parse(_provider.getScheduleRecords[i].time.split(":")[1]),
        id: _provider.getScheduleRecords[i].id,
        sound: 'sound2',
      );
    }

    _provider.setIsInitialPrefsSet = true;
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
        ),
        backgroundColor: Colors.white,
        borderColor: Colors.white,
        borderWidth: 0.0,
        direction: Axis.vertical,
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.genHydraPlan,
              style: TextStyle(
                fontSize: 20,
                color: _animationController.value < 0.7 ? Colors.blue : Colors.white,
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
                  _provider.getGender == 0 ? 'assets/images/boy.png' : 'assets/images/girl.png',
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
                      color: _animationController.value < 0.35 ? Colors.blue : Colors.white,
                    ),
                  ),
                ),
                Text(
                  '%',
                  style: TextStyle(
                    fontSize: size.width * 0.2,
                    color: _animationController.value < 0.3 ? Colors.blue : Colors.white,
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
