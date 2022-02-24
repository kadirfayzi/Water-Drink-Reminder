import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/functions.dart';
import 'package:water_reminder/models/schedule_record.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/services/notification_service.dart';
import 'package:water_reminder/widgets/build_dialog.dart';

/// Build Custom Title For Settings
Widget buildTitle({
  required Size size,
  required String title,
}) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[500],
            fontSize: 15,
          ),
        ),
        SizedBox(height: size.height * 0.0125),
        Container(
          width: size.width * 0.4,
          height: 0.625,
          color: Colors.grey[400],
        ),
      ],
    ),
  );
}

/// Build custom inkwell for setting's item
Widget buildTappableRow({
  required Size size,
  required String title,
  Widget? content,
  bool contentVisible = false,
  Function()? onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: size.height * 0.06,
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            contentVisible
                ? content!
                : const Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Colors.grey,
                  ),
          ],
        ),
      ),
    ),
  );
}

/// Build custom row for reminder mode popup dialog
Row buildReminderModeRow(int index, int selectedIndex) {
  return Row(
    children: [
      Icon(
        kReminderModeIcons[index],
        size: 25,
        color: selectedIndex == index ? kPrimaryColor : Colors.grey,
      ),
      const SizedBox(width: 15),
      Text(
        kReminderModeStrings[index],
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

/// Unit popup dialog
Future<dynamic> unitPopup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
}) {
  dynamic weightUnitValue = provider.getWeightUnit;
  dynamic capacityUnitValue = provider.getCapacityUnit;
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => BuildDialog(
          heightPercent: 0.3,
          onTapOK: () {
            provider.setUnit(weightUnitValue, capacityUnitValue);
            Navigator.pop(context);
          },
          content: Container(
            height: size.height * 0.25,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Unit',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Weight',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.3,
                      child: CupertinoSlidingSegmentedControl(
                        groupValue: weightUnitValue,
                        children: const {0: Text('kg'), 1: Text('lbs')},
                        onValueChanged: (value) => setState(() => weightUnitValue = value),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Capacity',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.3,
                      child: CupertinoSlidingSegmentedControl(
                        groupValue: capacityUnitValue,
                        children: const {0: Text('ml'), 1: Text('fl oz')},
                        onValueChanged: (value) => setState(() => capacityUnitValue = value),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// Intake goal popup dialog
Future<dynamic> intakeGoalPopup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
}) {
  double intakeGoalValue = provider.getIntakeGoalAmount;
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => BuildDialog(
          heightPercent: 0.35,
          onTapOK: () {
            /// if capacity unit = ml
            if (provider.getCapacityUnit == 0) {
              provider.setIntakeGoalAmount = intakeGoalValue;
            } else {
              /// else if capacity unit = fl oz, convert to ml then assign it
              provider.setIntakeGoalAmount = flOzToMl(intakeGoalValue);
            }

            Navigator.pop(context);
          },
          content: Container(
            height: size.height * 0.25,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Adjust intake goal',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      intakeGoalValue.toStringAsFixed(0),
                      style: const TextStyle(fontSize: 30, color: kPrimaryColor),
                    ),
                    Text(
                      kCapacityUnitStrings[provider.getCapacityUnit],
                      style: const TextStyle(color: kPrimaryColor),
                    ),
                    SizedBox(width: size.width * 0.05),
                    InkWell(
                      onTap: () => setState(
                          () => intakeGoalValue = calculateIntakeGoalAmount(provider.getWeight)),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          CupertinoIcons.arrow_clockwise,
                          size: 25,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                SliderTheme(
                  data: const SliderThemeData(
                    trackHeight: 2,
                    inactiveTrackColor: Colors.grey,
                    thumbColor: Colors.white,
                    activeTickMarkColor: Colors.transparent,
                    inactiveTickMarkColor: Colors.transparent,
                    thumbShape: RoundSliderThumbShape(
                      elevation: 5,
                      enabledThumbRadius: 15,
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CupertinoSlider(
                      value: intakeGoalValue,
                      onChanged: (value) => setState(() => intakeGoalValue = value),
                      min: provider.getCapacityUnit == 0 ? 800 : mlToFlOz(800),
                      max: provider.getCapacityUnit == 0 ? 6000 : mlToFlOz(6000),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// Gender selection popup dialog
Future<dynamic> genderSelectionPopup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
}) {
  dynamic genderValue = provider.getGender;
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => BuildDialog(
          heightPercent: 0.325,
          onTapOK: () {
            provider.setGender = genderValue;
            Navigator.pop(context);
          },
          content: Container(
            height: size.height * 0.2,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Gender',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Column(
                  children: [
                    Row(
                      children: [
                        Transform.scale(
                          scale: 1.5,
                          child: Radio(
                            value: 0,
                            groupValue: genderValue,
                            onChanged: (value) => setState(() => genderValue = value),
                            activeColor: kPrimaryColor,
                          ),
                        ),
                        const Text('Male'),
                      ],
                    ),
                    Row(
                      children: [
                        Transform.scale(
                          scale: 1.5,
                          child: Radio(
                            value: 1,
                            groupValue: genderValue,
                            onChanged: (value) => setState(() => genderValue = value),
                            activeColor: kPrimaryColor,
                          ),
                        ),
                        const Text('Female'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// Update weight popup dialog
Future<dynamic> weightSelectionPopup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
}) {
  int weight = provider.getWeight;

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => BuildDialog(
          heightPercent: 0.35,
          onTapOK: () {
            if (provider.getWeightUnit == 1) weight = kgToLbs(weight);
            provider.setWeight = weight;
            provider.setIntakeGoalAmount = calculateIntakeGoalAmount(weight);
            Navigator.pop(context);
          },
          content: Container(
            height: size.height * 0.3,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Weight',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width * 0.2,
                        height: size.height * 0.3,
                        child: CupertinoPicker.builder(
                          scrollController: FixedExtentScrollController(initialItem: weight),
                          itemExtent: 40,
                          onSelectedItemChanged: (value) => setState(() => weight = value),
                          childCount: provider.getWeightUnit == 0 ? 400 : 882,
                          itemBuilder: (context, index) => Text(
                            index.toString(),
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                      Text(
                        provider.getWeightUnit == 0 ? 'kg' : 'lbs',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// Wake up and bed time popup
Future<dynamic> wakeupAndBedtimePopup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
  required bool isWakeUp,
  required String title,
  required int hour,
  required int minute,
}) {
  final now = DateTime.now();
  DateTime time = DateTime.utc(
    now.year,
    now.month,
    now.day,
    hour,
    minute,
  );

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => BuildDialog(
          heightPercent: 0.4,
          onTapOK: () {
            final _notificationHelper = NotificationHelper();
            _notificationHelper.cancelAll();
            provider.deleteAllScheduleRecords();

            final _random = Random();
            int wakeUpHour = provider.getWakeUpTimeHour;
            int wakeUpMinute = provider.getWakeUpTimeMinute;
            int bedHour = provider.getBedTimeHour;

            if (isWakeUp) {
              provider.setWakeUpTime(time.hour, time.minute);
              wakeUpHour = time.hour;
              wakeUpMinute = time.minute;
            } else {
              provider.setBedTime(time.hour, time.minute);
              bedHour = time.hour;
            }

            if (wakeUpHour >= bedHour) bedHour += 24;

            int reminderCount = calculateReminderCount(
              bedHour: bedHour,
              wakeUpHour: wakeUpHour,
            );

            for (int i = 0; i <= reminderCount; i++) {
              if (wakeUpHour < bedHour) {
                int tempWakeUpHour = wakeUpHour;
                if (wakeUpHour >= 24) tempWakeUpHour -= 24;

                provider.addScheduleRecord = ScheduleRecord(
                  id: _random.nextInt(1000000000),
                  time: '${twoDigits(tempWakeUpHour)}:${twoDigits(wakeUpMinute)}',
                  isSet: true,
                );
              }
              wakeUpMinute += 30;
              wakeUpHour += 1;
              if (wakeUpMinute >= 60) {
                wakeUpHour += 1;
                wakeUpMinute -= 60;
              }
            }

            /// Set notifications for given time
            for (int i = 0; i < provider.getScheduleRecords.length; i++) {
              _notificationHelper.scheduledNotification(
                hour: int.parse(provider.getScheduleRecords[i].time.split(":")[0]),
                minutes: int.parse(provider.getScheduleRecords[i].time.split(":")[1]),
                id: provider.getScheduleRecords[i].id,
                sound: 'sound${provider.getSoundValue}',
              );
            }

            Navigator.pop(context);
          },
          content: SizedBox(
            height: size.height * 0.35,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: CupertinoTheme(
                      data: const CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: TextStyle(
                            fontSize: 25,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      child: SizedBox(
                        width: size.width * 0.3,
                        child: CupertinoDatePicker(
                          initialDateTime: time,
                          mode: CupertinoDatePickerMode.time,
                          use24hFormat: true,
                          onDateTimeChanged: (selectedTime) => setState(() => time = selectedTime),
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
    },
  );
}

/// Reminder schedule set time popup dialog
Future<dynamic> setTimePopup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
}) {
  DateTime _time = DateTime.now();
  final _random = Random();
  final _notificationHelper = NotificationHelper();
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => BuildDialog(
          heightPercent: 0.4,
          onTapOK: () {
            final int id = _random.nextInt(1000000000);

            /// Add new schedule record
            provider.addScheduleRecord = ScheduleRecord(
              id: id,
              time: '${twoDigits(_time.hour)}:${twoDigits(_time.minute)}',
              isSet: true,
            );

            /// Set new notification
            _notificationHelper.scheduledNotification(
              hour: _time.hour,
              minutes: _time.minute,
              id: id,
              sound: 'sound${provider.getSoundValue}',
            );
            Navigator.pop(context);
          },
          content: SizedBox(
            height: size.height * 0.35,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Set time',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: CupertinoTheme(
                      data: const CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: TextStyle(
                            fontSize: 25,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      child: CupertinoDatePicker(
                        initialDateTime: _time,
                        mode: CupertinoDatePickerMode.time,
                        use24hFormat: true,
                        onDateTimeChanged: (selectedTime) => setState(() => _time = selectedTime),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
