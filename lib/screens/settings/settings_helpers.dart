import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/functions.dart';
import 'package:water_reminder/models/schedule_record.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/services/notification_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:water_reminder/l10n/l10n.dart';

import '../../widgets/elevated_container.dart';

/// Reminder schedule popup dialog
Future<dynamic> reminderSchedulePopup({required BuildContext context}) {
  final size = MediaQuery.of(context).size;
  final localize = AppLocalizations.of(context)!;
  final NotificationHelper notificationHelper = NotificationHelper();
  return showCupertinoModalPopup(
    context: context,
    builder: (context) => Dismissible(
      key: const Key('key'),
      direction: DismissDirection.vertical,
      onDismissed: (_) => Navigator.pop(context),
      child: Consumer<DataProvider>(
        builder: (context, provider, _) => CupertinoActionSheet(
          title: Text(
            localize.reminderSchedule,
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            SizedBox(
              height: size.height * 0.725,
              child: Scaffold(
                body: ListView(
                  children: List.generate(
                    provider.getScheduleRecords.length,
                    (index) => Padding(
                      padding: index == provider.getScheduleRecords.length - 1
                          ? EdgeInsets.only(bottom: size.height * 0.1)
                          : const EdgeInsets.all(0),
                      child: Column(
                        children: [
                          Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent,
                              splashColor: Colors.transparent,
                            ),
                            child: ExpansionTile(
                              key: GlobalKey(),
                              childrenPadding: const EdgeInsets.all(10),
                              backgroundColor: Colors.grey[200],
                              collapsedIconColor: Colors.grey,
                              title: Container(
                                height: size.height * 0.06,
                                width: size.width,
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      provider.getScheduleRecords[index].time,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                    CupertinoSwitch(
                                      value: provider.getScheduleRecords[index].isSet,
                                      onChanged: (isSet) {
                                        /// set or reset notification
                                        if (!isSet) {
                                          notificationHelper
                                              .cancel(provider.getScheduleRecords[index].id);
                                        } else {
                                          notificationHelper.scheduledNotification(
                                            hour: int.parse(provider.getScheduleRecords[index].time
                                                .split(":")[0]),
                                            minutes: int.parse(provider
                                                .getScheduleRecords[index].time
                                                .split(":")[1]),
                                            id: provider.getScheduleRecords[index].id,
                                            title: localize.notificationTitle,
                                            body: localize.notificationBody,
                                            sound: 'sound${provider.getSelectedSoundValue}',
                                          );
                                        }

                                        /// Edit schedule record
                                        provider.editScheduleRecord(
                                          index,
                                          ScheduleRecord(
                                            id: provider.getScheduleRecords[index].id,
                                            time: provider.getScheduleRecords[index].time,
                                            isSet: isSet,
                                          ),
                                        );
                                      },
                                      activeColor: kPrimaryColor,
                                    )
                                  ],
                                ),
                              ),
                              children: [
                                Material(
                                  elevation: 0.5,
                                  borderRadius: const BorderRadius.all(kRadius_5),
                                  child: InkWell(
                                    borderRadius: const BorderRadius.all(kRadius_5),
                                    onTap: () {
                                      /// Delete schedule record and notification
                                      notificationHelper
                                          .cancel(provider.getScheduleRecords[index].id);
                                      provider.deleteScheduleRecord = index;
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      width: size.width,
                                      child: Text(
                                        localize.delete,
                                        style: TextStyle(
                                          color: Colors.red[600],
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(indent: 10, endIndent: 10),
                        ],
                      ),
                    ),
                  ),
                ),

                /// Add new schedule record
                floatingActionButton: ElevatedContainer(
                  color: kPrimaryColor,
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () => setReminderTimePopup(context: context),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              ),
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(localize.close),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    ),
  );
}

/// Set reminder sound popup dialog
Future<dynamic> setSoundPopup({required BuildContext context}) {
  final size = MediaQuery.of(context).size;
  final localize = AppLocalizations.of(context)!;
  final AudioPlayer player = AudioPlayer();
  final NotificationHelper notificationHelper = NotificationHelper();
  int selectedSoundValue = Provider.of<DataProvider>(context, listen: false).getSelectedSoundValue;
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => Dismissible(
        key: const Key('key'),
        direction: DismissDirection.vertical,
        onDismissed: (_) => Navigator.pop(context),
        child: CupertinoActionSheet(
          title: Text(
            localize.selectSound,
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            Column(
              children: List.generate(
                kSounds.length,
                (index) => Container(
                  height: size.height * 0.08,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade300,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.grey,
                      highlightColor: Colors.grey,
                      onTap: () async {
                        setState(() => selectedSoundValue = index);
                        await player.setAsset('assets/sounds/$selectedSoundValue.mp3');
                        player.play();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              kSounds[index],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Icon(
                              selectedSoundValue == index ? Icons.check_circle_rounded : null,
                              color: kPrimaryColor,
                              size: 30,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                final provider = Provider.of<DataProvider>(context, listen: false);
                notificationHelper.cancelAll();
                provider.setSoundValue = selectedSoundValue;
                if (provider.getScheduleRecords.isNotEmpty) {
                  for (int i = 0; i < provider.getScheduleRecords.length; i++) {
                    notificationHelper.scheduledNotification(
                      hour: int.parse(provider.getScheduleRecords[i].time.split(":")[0]),
                      minutes: int.parse(provider.getScheduleRecords[i].time.split(":")[1]),
                      id: provider.getScheduleRecords[i].id,
                      title: localize.notificationTitle,
                      body: localize.notificationBody,
                      sound: 'sound$selectedSoundValue',
                    );
                  }
                }

                Navigator.pop(context);
              },
              child: Text(localize.save),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(localize.cancel),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    ),
  );
}

/// Unit popup dialog
Future<dynamic> setUnitPopup({required BuildContext context}) {
  final size = MediaQuery.of(context).size;
  final localize = AppLocalizations.of(context)!;
  final provider = Provider.of<DataProvider>(context, listen: false);
  dynamic selectedWeightUnitValue = provider.getWeightUnit;
  dynamic selectedCapacityUnitValue = provider.getCapacityUnit;
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => Dismissible(
        key: const Key('key'),
        direction: DismissDirection.vertical,
        onDismissed: (_) => Navigator.pop(context),
        child: CupertinoActionSheet(
          title: Text(
            localize.selectUnits,
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            Material(
              child: Container(
                height: size.height * 0.185,
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localize.weight,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.3,
                          child: CupertinoSlidingSegmentedControl(
                            groupValue: selectedWeightUnitValue,
                            children: const {0: Text('kg'), 1: Text('lbs')},
                            onValueChanged: (value) =>
                                setState(() => selectedWeightUnitValue = value),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localize.capacity,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.3,
                          child: CupertinoSlidingSegmentedControl(
                            groupValue: selectedCapacityUnitValue,
                            children: const {0: Text('ml'), 1: Text('fl oz')},
                            onValueChanged: (value) =>
                                setState(() => selectedCapacityUnitValue = value),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                provider.setWeightUnit = selectedWeightUnitValue;
                provider.setCapacityUnit = selectedCapacityUnitValue;
                Navigator.pop(context);
              },
              child: Text(localize.save),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(localize.cancel),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    ),
  );
}

/// Intake goal popup dialog
Future<dynamic> setIntakeGoalPopup({required BuildContext context}) {
  final size = MediaQuery.of(context).size;
  final localize = AppLocalizations.of(context)!;
  final provider = Provider.of<DataProvider>(context, listen: false);
  double intakeGoalValue = provider.getIntakeGoalAmount;
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => Dismissible(
        key: const Key('key'),
        direction: DismissDirection.vertical,
        onDismissed: (_) => Navigator.pop(context),
        child: CupertinoActionSheet(
          title: Text(
            localize.adjustIntakeGoal,
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            Material(
              child: Container(
                height: size.height * 0.285,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          provider.getCapacityUnit == 0
                              ? intakeGoalValue.toStringAsFixed(0)
                              : Functions.mlToFlOz(intakeGoalValue).toStringAsFixed(0),
                          style: const TextStyle(fontSize: 30, color: kPrimaryColor),
                        ),
                        Text(
                          ' ${kCapacityUnitStrings[provider.getCapacityUnit]}',
                          style: const TextStyle(color: kPrimaryColor),
                        ),
                        SizedBox(width: size.width * 0.05),
                        InkWell(
                          onTap: () => setState(
                            () => intakeGoalValue = Functions.calculateIntakeGoalAmount(
                              weight: provider.getWeight,
                              gender: provider.getGender,
                            ),
                          ),
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
                        child: provider.getCapacityUnit == 0
                            ? CupertinoSlider(
                                value: intakeGoalValue,
                                onChanged: (value) => setState(() => intakeGoalValue = value),
                                min: 500,
                                max: 10000,
                              )
                            : CupertinoSlider(
                                value: Functions.mlToFlOz(intakeGoalValue),
                                onChanged: (value) {
                                  setState(() => intakeGoalValue = Functions.flOzToMl(value));
                                },
                                min: 16,
                                max: 338,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                provider.setIntakeGoalAmount = intakeGoalValue.roundToDouble();
                Navigator.pop(context);
              },
              child: Text(localize.save),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(localize.cancel),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    ),
  );
}

/// Set language popup dialog
Future<dynamic> setLanguagePopup({required BuildContext context}) {
  final localize = AppLocalizations.of(context)!;
  final NotificationHelper notificationHelper = NotificationHelper();
  final provider = Provider.of<DataProvider>(context, listen: false);
  String selectedLangCode = provider.getLangCode;

  return showCupertinoModalPopup(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => Dismissible(
        key: const Key('key'),
        direction: DismissDirection.vertical,
        onDismissed: (_) => Navigator.pop(context),
        child: CupertinoActionSheet(
          title: Text(
            localize.selectLanguage,
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            Column(
              children: L10n.all
                  .map((e) => Container(
                        color: selectedLangCode == e.languageCode
                            ? Colors.white
                            : Colors.grey.shade200,
                        child: CupertinoActionSheetAction(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(L10n.getName(e.languageCode)),
                                Text(L10n.getFlag(e.languageCode)),
                              ],
                            ),
                          ),
                          onPressed: () => setState(() => selectedLangCode = e.languageCode),
                        ),
                      ))
                  .toList(),
            ),
            CupertinoActionSheetAction(
              child: Text(localize.save),
              onPressed: () {
                notificationHelper.cancelAll();
                provider.setLangCode = selectedLangCode;

                if (provider.getScheduleRecords.isNotEmpty) {
                  for (int i = 0; i < provider.getScheduleRecords.length; i++) {
                    notificationHelper.scheduledNotification(
                      hour: int.parse(provider.getScheduleRecords[i].time.split(":")[0]),
                      minutes: int.parse(provider.getScheduleRecords[i].time.split(":")[1]),
                      id: provider.getScheduleRecords[i].id,
                      title: L10n.getNotificationTitle(selectedLangCode),
                      body: L10n.getNotificationBody(selectedLangCode),
                      sound: 'sound${provider.getSelectedSoundValue}',
                    );
                  }
                }

                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(localize.cancel),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    ),
  );
}

/// Gender selection popup dialog
Future<dynamic> genderSelectionPopup({required BuildContext context}) {
  final size = MediaQuery.of(context).size;
  final localize = AppLocalizations.of(context)!;
  final provider = Provider.of<DataProvider>(context, listen: false);
  dynamic genderValue = provider.getGender;
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => Dismissible(
        key: const Key('key'),
        direction: DismissDirection.vertical,
        onDismissed: (_) => Navigator.pop(context),
        child: CupertinoActionSheet(
          title: Text(
            localize.selectGender,
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            Material(
              child: Padding(
                padding: EdgeInsets.all(size.width * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => genderValue = 0),
                      child: Column(
                        children: [
                          Opacity(
                            opacity: genderValue == 0 ? 1 : 0.3,
                            child: Image.asset(
                              'assets/images/intro/male.png',
                              scale: 5,
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          Text(
                            localize.male,
                            style: TextStyle(
                              color: genderValue == 0 ? kPrimaryColor : Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: size.width * 0.1),
                    GestureDetector(
                      onTap: () => setState(() => genderValue = 1),
                      child: Column(
                        children: [
                          Opacity(
                            opacity: genderValue == 1 ? 1 : 0.3,
                            child: Image.asset(
                              'assets/images/intro/female.png',
                              scale: 5,
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          Text(
                            localize.female,
                            style: TextStyle(
                              color: genderValue == 1 ? kPrimaryColor : Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                provider.setGender = genderValue;
                provider.setIntakeGoalAmount = Functions.calculateIntakeGoalAmount(
                  weight: provider.getWeight,
                  gender: genderValue,
                );
                Navigator.pop(context);
              },
              child: Text(localize.save),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(localize.cancel),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    ),
  );
}

/// Edit weight popup dialog
Future<dynamic> weightSelectionPopup({required BuildContext context}) {
  final size = MediaQuery.of(context).size;
  final localize = AppLocalizations.of(context)!;
  final provider = Provider.of<DataProvider>(context, listen: false);
  int weight = provider.getWeight;
  int childCount = provider.getWeightUnit == 0 ? 400 : 882;
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => Dismissible(
      key: const Key('key'),
      direction: DismissDirection.vertical,
      onDismissed: (_) => Navigator.pop(context),
      child: CupertinoActionSheet(
        title: Text(
          localize.selectWeight,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          Material(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  provider.getGender == 0
                      ? 'assets/images/intro/weight_male.png'
                      : 'assets/images/intro/weight_female.png',
                  scale: 4,
                ),
                SizedBox(
                  width: size.width * 0.2,
                  height: size.height * 0.3,
                  child: CupertinoPicker.builder(
                    scrollController: FixedExtentScrollController(initialItem: weight),
                    itemExtent: 40,
                    onSelectedItemChanged: (value) => weight = value,
                    childCount: childCount,
                    itemBuilder: (context, index) => Text(
                      index.toString(),
                      style: const TextStyle(
                        fontSize: 35,
                        color: kPrimaryColor,
                      ),
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
          CupertinoActionSheetAction(
            child: Text(localize.save),
            onPressed: () {
              if (provider.getWeightUnit == 1) weight = Functions.kgToLbs(weight);
              provider.setWeight = weight;
              provider.setIntakeGoalAmount = Functions.calculateIntakeGoalAmount(
                weight: weight,
                gender: provider.getGender,
              );
              Navigator.pop(context);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(localize.cancel),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    ),
  );
}

/// Wake up and bed time popup
Future<dynamic> wakeupAndBedtimePopup({
  required BuildContext context,
  required bool isWakeUp,
  required int hour,
  required int minute,
}) {
  final size = MediaQuery.of(context).size;
  final localize = AppLocalizations.of(context)!;
  final provider = Provider.of<DataProvider>(context, listen: false);
  final DateTime now = DateTime.now();
  DateTime time = DateTime.utc(
    now.year,
    now.month,
    now.day,
    hour,
    minute,
  );
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => Dismissible(
        key: const Key('key'),
        direction: DismissDirection.vertical,
        onDismissed: (_) => Navigator.pop(context),
        child: CupertinoActionSheet(
          title: Text(
            isWakeUp ? localize.wakeUpTime : localize.bedTime,
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            Material(
              child: SizedBox(
                height: size.height * 0.35,
                child: Row(
                  children: [
                    isWakeUp
                        ? Image.asset(
                            provider.getGender == 0
                                ? 'assets/images/intro/wakeup_male.png'
                                : 'assets/images/intro/wakeup_female.png',
                            scale: 3,
                          )
                        : Image.asset(
                            provider.getGender == 0
                                ? 'assets/images/intro/sleep_male.png'
                                : 'assets/images/intro/sleep_female.png',
                            scale: 3,
                          ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: CupertinoTheme(
                          data: const CupertinoThemeData(
                            textTheme: CupertinoTextThemeData(
                              dateTimePickerTextStyle: TextStyle(
                                fontSize: 25,
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                          child: CupertinoDatePicker(
                            initialDateTime: time,
                            mode: CupertinoDatePickerMode.time,
                            use24hFormat: true,
                            onDateTimeChanged: (selectedTime) =>
                                setState(() => time = selectedTime),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CupertinoActionSheetAction(
              child: Text(localize.save),
              onPressed: () {
                final NotificationHelper notificationHelper = NotificationHelper();
                notificationHelper.cancelAll();
                provider.deleteAllScheduleRecords();

                final Random random = Random();
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

                int reminderCount = Functions.calculateReminderCount(
                  bedHour: bedHour,
                  wakeUpHour: wakeUpHour,
                );

                for (int i = 0; i <= reminderCount; i++) {
                  if (wakeUpHour < bedHour) {
                    int tempWakeUpHour = wakeUpHour;
                    if (wakeUpHour >= 24) tempWakeUpHour -= 24;

                    provider.addScheduleRecord = ScheduleRecord(
                      id: random.nextInt(1000000000),
                      time:
                          '${Functions.twoDigits(tempWakeUpHour)}:${Functions.twoDigits(wakeUpMinute)}',
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
                  notificationHelper.scheduledNotification(
                    hour: int.parse(provider.getScheduleRecords[i].time.split(":")[0]),
                    minutes: int.parse(provider.getScheduleRecords[i].time.split(":")[1]),
                    id: provider.getScheduleRecords[i].id,
                    title: localize.notificationTitle,
                    body: localize.notificationBody,
                    sound: 'sound${provider.getSelectedSoundValue}',
                  );
                }
                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(localize.cancel),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    ),
  );
}

/// Reminder schedule set time popup dialog
Future<dynamic> setReminderTimePopup({required BuildContext context}) {
  final size = MediaQuery.of(context).size;
  final localize = AppLocalizations.of(context)!;
  DateTime time = DateTime.now();
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => Dismissible(
        key: const Key('key'),
        direction: DismissDirection.vertical,
        onDismissed: (_) => Navigator.pop(context),
        child: CupertinoActionSheet(
          title: Text(
            localize.setNewReminder,
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            Material(
              child: SizedBox(
                height: size.height * 0.35,
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: CupertinoTheme(
                          data: const CupertinoThemeData(
                            textTheme: CupertinoTextThemeData(
                              dateTimePickerTextStyle: TextStyle(
                                fontSize: 25,
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                          child: SizedBox(
                            width: size.width * 0.3,
                            child: CupertinoDatePicker(
                              initialDateTime: time,
                              mode: CupertinoDatePickerMode.time,
                              use24hFormat: true,
                              onDateTimeChanged: (selectedTime) =>
                                  setState(() => time = selectedTime),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CupertinoActionSheetAction(
              child: Text(localize.save),
              onPressed: () {
                final NotificationHelper notificationHelper = NotificationHelper();
                final int id = Random().nextInt(1000000000);
                final provider = Provider.of<DataProvider>(context, listen: false);

                /// Add new schedule record
                provider.addScheduleRecord = ScheduleRecord(
                  id: id,
                  time: '${Functions.twoDigits(time.hour)}:${Functions.twoDigits(time.minute)}',
                  isSet: true,
                );

                /// Set new notification
                notificationHelper.scheduledNotification(
                  hour: time.hour,
                  minutes: time.minute,
                  id: id,
                  title: localize.notificationTitle,
                  body: localize.notificationBody,
                  sound: 'sound${provider.getSelectedSoundValue}',
                );
                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(localize.cancel),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    ),
  );
}
