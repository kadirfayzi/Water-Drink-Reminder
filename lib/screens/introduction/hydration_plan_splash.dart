import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:water_reminder/functions.dart';
import 'package:water_reminder/models/cup.dart';
import 'package:water_reminder/models/schedule_record.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/screens/introduction/introduction_screen.dart';
import 'package:water_reminder/services/notification_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/liquid_progress_indicator/liquid_linear_progress_indicator.dart';

class HydrationPlanSplash extends StatefulWidget {
  const HydrationPlanSplash({
    Key? key,
    required this.provider,
    required this.localize,
    required this.size,
  }) : super(key: key);
  final DataProvider provider;
  final AppLocalizations localize;
  final Size size;
  @override
  State<HydrationPlanSplash> createState() => _HydrationPlanSplashState();
}

List<Cup> defaultCups = [
  Cup(capacity: 100, image: 'assets/images/cups/100-128.png'),
  Cup(capacity: 125, image: 'assets/images/cups/125-128.png'),
  Cup(capacity: 150, image: 'assets/images/cups/150-128.png'),
  Cup(capacity: 175, image: 'assets/images/cups/175-128.png'),
  Cup(capacity: 200, image: 'assets/images/cups/200-128.png'),
  Cup(capacity: 300, image: 'assets/images/cups/300-128.png'),
];

class _HydrationPlanSplashState extends State<HydrationPlanSplash> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late final NotificationHelper _notificationHelper;
  late final Random _random;

  setHydrationPlan() {
    _notificationHelper = NotificationHelper();
    _random = Random();

    /// Set initial schedule records
    int wakeUpHour = widget.provider.getWakeUpTimeHour;
    int minute = widget.provider.getWakeUpTimeMinute;
    int bedHour = widget.provider.getBedTimeHour;
    if (wakeUpHour >= bedHour) bedHour += 24;

    int reminderCount = Functions.calculateReminderCount(
      bedHour: bedHour,
      wakeUpHour: wakeUpHour,
    );

    widget.provider.setHowManyTimes = reminderCount;
    int howMuchEachTime = widget.provider.getIntakeGoalAmount ~/ reminderCount;
    widget.provider.setHowMuchEachTime = howMuchEachTime;

    if (widget.provider.getCups.isEmpty) {
      for (Cup cup in defaultCups) {
        widget.provider.addCup = cup;
      }
    }

    /// Set nearest cup
    final List<Cup> cups = widget.provider.getCups;
    for (Cup cup in cups) {
      if (cup.capacity >= howMuchEachTime) {
        cup.selected = true;
        cup.save();
        break;
      }
    }
    if (cups.any((cup) => cup.selected != true)) {
      cups.last.selected = true;
      cups.last.save();
    }

    for (int i = 0; i <= reminderCount; i++) {
      if (wakeUpHour < bedHour) {
        int tempWakeUpHour = wakeUpHour;
        if (wakeUpHour >= 24) tempWakeUpHour -= 24;

        widget.provider.addScheduleRecord = ScheduleRecord(
          id: _random.nextInt(1000000000),
          time: '${Functions.twoDigits(tempWakeUpHour)}:${Functions.twoDigits(minute)}',
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

    final List<ScheduleRecord> scheduleRecords = widget.provider.getScheduleRecords;

    /// Set initial notifications
    for (int i = 0; i < scheduleRecords.length; i++) {
      _notificationHelper.scheduledNotification(
        hour: int.parse(scheduleRecords[i].time.split(":")[0]),
        minutes: int.parse(scheduleRecords[i].time.split(":")[1]),
        id: scheduleRecords[i].id,
        title: widget.localize.notificationTitle,
        body: widget.localize.notificationBody,
        sound: 'sound0',
      );
    }

    widget.provider.setIsInitialPrefsSet = true;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) => setHydrationPlan());
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    _animationController.addListener(() => setState(() {}));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_animationController.value == 1) {
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
        valueColor: const AlwaysStoppedAnimation(Colors.blue),
        backgroundColor: Colors.white,
        borderColor: Colors.white,
        borderWidth: 0.0,
        direction: Axis.vertical,
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: widget.size.width * 0.95,
              child: Text(
                widget.localize.genHydraPlan,
                style: TextStyle(
                  fontSize: widget.size.width * 0.05,
                  color: _animationController.value < 0.75 ? Colors.blue : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: widget.size.height * 0.05),
            Image.asset(
              widget.provider.getGender == 0
                  ? 'assets/images/intro/male.png'
                  : 'assets/images/intro/female.png',
              scale: 3,
            ),
            SizedBox(height: widget.size.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (_animationController.value * 100).toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: widget.size.width * 0.15,
                    color: _animationController.value < 0.35 ? Colors.blue : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '%',
                  style: TextStyle(
                    fontSize: widget.size.width * 0.15,
                    color: _animationController.value < 0.3 ? Colors.blue : Colors.black,
                    fontWeight: FontWeight.w500,
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
