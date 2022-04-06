import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/functions.dart';
import 'package:water_reminder/models/schedule_record.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/services/notification_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:water_reminder/l10n/l10n.dart';

import '../../widgets/elevated_container.dart';

/// Build Custom Title For Settings
Widget buildTitle({
  required Size size,
  required String title,
}) =>
    Padding(
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

/// Build custom inkwell for setting's item
Widget buildTappableRow({
  required Size size,
  required String title,
  required IconData icon,
  Widget? content,
  bool contentVisible = false,
  Function()? onTap,
}) =>
    Material(
      color: Colors.transparent,
      child: InkWell(
        highlightColor: Colors.grey.shade300,
        splashColor: Colors.grey.shade300,
        onTap: onTap,
        child: Container(
          height: size.height * 0.06,
          width: size.width,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: Colors.grey, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
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
      ),
    );

/// Reminder schedule popup dialog
Future<dynamic> reminderSchedulePopup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
  required AppLocalizations localize,
}) {
  final NotificationHelper _notificationHelper = NotificationHelper();
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => Dismissible(
      key: const Key('key'),
      direction: DismissDirection.vertical,
      onDismissed: (_) => Navigator.pop(context),
      child: CupertinoActionSheet(
        title: Text(localize.reminderSchedule),
        actions: [
          SizedBox(
            height: size.height * 0.725,
            child: Scaffold(
              body: SizedBox(
                height: size.height * 0.725,
                child: ListView(
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
                                          _notificationHelper
                                              .cancel(provider.getScheduleRecords[index].id);
                                        } else {
                                          _notificationHelper.scheduledNotification(
                                            hour: int.parse(provider.getScheduleRecords[index].time
                                                .split(":")[0]),
                                            minutes: int.parse(provider
                                                .getScheduleRecords[index].time
                                                .split(":")[1]),
                                            id: provider.getScheduleRecords[index].id,
                                            sound: 'sound${provider.getSoundValue}',
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
                                      _notificationHelper
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
              ),

              /// Add new schedule record
              floatingActionButton: ElevatedContainer(
                color: kPrimaryColor,
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () => setReminderTimePopup(
                    context: context,
                    provider: provider,
                    size: size,
                    localize: localize,
                  ),
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
  );
}

/// Set sound popup dialog
Future<dynamic> setSoundPopup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
  required AppLocalizations localize,
}) {
  final AudioPlayer _player = AudioPlayer();
  final NotificationHelper _notificationHelper = NotificationHelper();
  int selectedSoundValue = provider.getSoundValue;
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => Dismissible(
        key: const Key('key'),
        direction: DismissDirection.vertical,
        onDismissed: (_) => Navigator.pop(context),
        child: CupertinoActionSheet(
          title: Text(localize.selectSound),
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
                        await _player.setAsset('assets/sounds/$selectedSoundValue.mp3');
                        _player.play();
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
                _notificationHelper.cancelAll();
                provider.setSoundValue = selectedSoundValue;
                for (int i = 0; i < provider.getScheduleRecords.length; i++) {
                  _notificationHelper.scheduledNotification(
                    hour: int.parse(provider.getScheduleRecords[i].time.split(":")[0]),
                    minutes: int.parse(provider.getScheduleRecords[i].time.split(":")[1]),
                    id: provider.getScheduleRecords[i].id,
                    sound: 'sound$selectedSoundValue',
                  );
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
Future<dynamic> setUnitPopup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
  required AppLocalizations localize,
}) {
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
          title: Text(localize.selectUnits),
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
Future<dynamic> setIntakeGoalPopup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
  required AppLocalizations localize,
}) {
  double intakeGoalValue = provider.getIntakeGoalAmount;
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => Dismissible(
        key: const Key('key'),
        direction: DismissDirection.vertical,
        onDismissed: (_) => Navigator.pop(context),
        child: CupertinoActionSheet(
          title: Text(localize.adjustIntakeGoal),
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
                              : mlToFlOz(intakeGoalValue).toStringAsFixed(0),
                          style: const TextStyle(fontSize: 30, color: kPrimaryColor),
                        ),
                        Text(
                          ' ${kCapacityUnitStrings[provider.getCapacityUnit]}',
                          style: const TextStyle(color: kPrimaryColor),
                        ),
                        SizedBox(width: size.width * 0.05),
                        InkWell(
                          onTap: () => setState(
                            () => intakeGoalValue = calculateIntakeGoalAmount(
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
                                value: mlToFlOz(intakeGoalValue),
                                onChanged: (value) {
                                  setState(() => intakeGoalValue = flOzToMl(value));
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
Future<dynamic> setLanguagePopup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
  required AppLocalizations localize,
}) {
  List<String> languages = ['English', 'Türkçe', 'Español', 'Deutsch'];
  String selectedLangCode = provider.getLangCode;
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => Dismissible(
        key: const Key('key'),
        direction: DismissDirection.vertical,
        onDismissed: (_) => Navigator.pop(context),
        child: CupertinoActionSheet(
          title: Text(localize.selectLanguage),
          actions: [
            Column(
              children: List.generate(
                L10n.all.length,
                (index) => Container(
                  color: selectedLangCode == L10n.all[index].languageCode
                      ? Colors.white
                      : Colors.grey.shade200,
                  child: CupertinoActionSheetAction(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(languages[index]),
                        Text(L10n.getFlag(L10n.all[index].languageCode)),
                      ],
                    ),
                    onPressed: () =>
                        setState(() => selectedLangCode = L10n.all[index].languageCode),
                  ),
                ),
              ),
            ),
            CupertinoActionSheetAction(
              child: Text(localize.save),
              onPressed: () {
                provider.setLangCode = selectedLangCode;
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
Future<dynamic> genderSelectionPopup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
  required AppLocalizations localize,
}) {
  dynamic genderValue = provider.getGender;
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => Dismissible(
        key: const Key('key'),
        direction: DismissDirection.vertical,
        onDismissed: (_) => Navigator.pop(context),
        child: CupertinoActionSheet(
          title: Text(localize.selectGender),
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
                          Container(
                            decoration: BoxDecoration(
                              color: genderValue == 0 ? Colors.grey : Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Image.asset(
                                'assets/images/boy.png',
                                scale: 10,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          Text(
                            localize.male,
                            style: TextStyle(
                              color: genderValue == 0 ? kPrimaryColor : Colors.grey[400],
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
                          Container(
                            decoration: BoxDecoration(
                              color: genderValue == 1 ? Colors.grey : Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Image.asset(
                                'assets/images/girl.png',
                                scale: 10,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          Text(
                            localize.female,
                            style: TextStyle(
                              color: genderValue == 1 ? kPrimaryColor : Colors.grey[400],
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
                provider.setIntakeGoalAmount = calculateIntakeGoalAmount(
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
Future<dynamic> weightSelectionPopup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
  required AppLocalizations localize,
}) {
  int weight = provider.getWeight;
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => Dismissible(
      key: const Key('key'),
      direction: DismissDirection.vertical,
      onDismissed: (_) => Navigator.pop(context),
      child: CupertinoActionSheet(
        title: Text(localize.selectWeight),
        actions: [
          Material(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.width * 0.2,
                  height: size.height * 0.3,
                  child: CupertinoPicker.builder(
                    scrollController: FixedExtentScrollController(initialItem: weight),
                    itemExtent: 40,
                    onSelectedItemChanged: (value) => weight = value,
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
          CupertinoActionSheetAction(
            child: Text(localize.save),
            onPressed: () {
              if (provider.getWeightUnit == 1) weight = kgToLbs(weight);
              provider.setWeight = weight;
              provider.setIntakeGoalAmount = calculateIntakeGoalAmount(
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
  required DataProvider provider,
  required Size size,
  required bool isWakeUp,
  required int hour,
  required int minute,
  required AppLocalizations localize,
}) {
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
                final NotificationHelper _notificationHelper = NotificationHelper();
                _notificationHelper.cancelAll();
                provider.deleteAllScheduleRecords();

                final Random _random = Random();
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
Future<dynamic> setReminderTimePopup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
  required AppLocalizations localize,
}) {
  DateTime _time = DateTime.now();
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => Dismissible(
        key: const Key('key'),
        direction: DismissDirection.vertical,
        onDismissed: (_) => Navigator.pop(context),
        child: CupertinoActionSheet(
          title: Text(localize.setNewReminder),
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
                              initialDateTime: _time,
                              mode: CupertinoDatePickerMode.time,
                              use24hFormat: true,
                              onDateTimeChanged: (selectedTime) =>
                                  setState(() => _time = selectedTime),
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
                final NotificationHelper _notificationHelper = NotificationHelper();
                final int id = Random().nextInt(1000000000);

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
