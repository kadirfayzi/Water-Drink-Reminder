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

    /// Set initial notifications
    for (int i = 0; i < widget.provider.getScheduleRecords.length; i++) {
      _notificationHelper.scheduledNotification(
        hour: int.parse(widget.provider.getScheduleRecords[i].time.split(":")[0]),
        minutes: int.parse(widget.provider.getScheduleRecords[i].time.split(":")[1]),
        id: widget.provider.getScheduleRecords[i].id,
        title: widget.localize.notificationTitle,
        body: widget.localize.notificationBody,
        sound: 'sound2',
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

    if (percentage.toStringAsFixed(0) == '100') {
      _animationController.stop();
      Future.delayed(
        const Duration(milliseconds: 800),
        () => WidgetsBinding.instance?.addPostFrameCallback(
          (_) => Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                builder: (context) => IntroductionScreen(
                  size: widget.size,
                  provider: widget.provider,
                  localize: widget.localize,
                ),
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
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  widget.provider.getGender == 0
                      ? 'assets/images/boy.png'
                      : 'assets/images/girl.png',
                  scale: 4,
                ),
              ),
            ),
            SizedBox(height: widget.size.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: percentage.toStringAsFixed(0) != '100'
                      ? widget.size.width * 0.275
                      : widget.size.width * 0.35,
                  child: Text(
                    percentage.toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: widget.size.width * 0.185,
                      color: _animationController.value < 0.35 ? Colors.blue : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '%',
                  style: TextStyle(
                    fontSize: widget.size.width * 0.185,
                    color: _animationController.value < 0.3 ? Colors.blue : Colors.black,
                    fontWeight: FontWeight.w600,
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
