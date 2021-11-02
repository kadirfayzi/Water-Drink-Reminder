import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/widgets/build_dialog.dart';
import 'package:water_reminder/widgets/sliding_switch.dart';

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
            contentVisible ? content! : const SizedBox(),
          ],
        ),
      ),
    ),
  );
}

/// Reminder mode popup dialog
Future<dynamic> reminderModePopup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      int selectedIndex = provider.getReminderMode;
      return StatefulBuilder(
        builder: (context, setState) => BuildDialog(
          heightPercent: 0.425,
          onTapOK: () {
            Navigator.pop(context);
            provider.setReminderMode = selectedIndex;
          },
          content: SizedBox(
            height: size.height * 0.375,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => InkWell(
                  onTap: () => setState(() => selectedIndex = index),
                  child: SizedBox(
                    height: size.height * 0.06,
                    width: size.width * 0.6,
                    child: buildReminderModeRow(index, selectedIndex),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
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
  bool weightUnitValue = provider.getWeightUnit;
  bool capacityUnitValue = provider.getCapacityUnit;
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => BuildDialog(
          heightPercent: 0.3,
          onTapOK: () {
            provider.setWeightUnit = weightUnitValue;
            provider.setCapacityUnit = capacityUnitValue;
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
                buildUnitRow(
                  size: size,
                  title: 'Weight',
                  switchValue: provider.getWeightUnit,
                  switchTextLeft: 'kg',
                  switchTextRight: 'lbs',
                  value: provider.getWeightUnit,
                  onChanged: (value) => setState(() => weightUnitValue = value),
                ),
                SizedBox(height: size.height * 0.01),
                buildUnitRow(
                  size: size,
                  title: 'Capacity',
                  switchValue: provider.getCapacityUnit,
                  switchTextLeft: 'ml',
                  switchTextRight: 'fl oz',
                  value: provider.getCapacityUnit,
                  onChanged: (value) => setState(() => capacityUnitValue = value),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// Build custom row for unit popup dialog
Row buildUnitRow({
  required Size size,
  required String title,
  required bool switchValue,
  required String switchTextLeft,
  required String switchTextRight,
  required bool value,
  required Function(bool) onChanged,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          color: Colors.black,
        ),
      ),
      SlidingSwitch(
        value: value,
        width: size.width * 0.3,
        height: size.height * 0.045,
        onChanged: onChanged,
        onTap: () {},
        onSwipe: () {},
        textLeft: switchTextLeft,
        textRight: switchTextRight,
        buttonTextSize: 14,
      ),
    ],
  );
}

/// Intake goal popup dialog
Future<dynamic> intakeGoalPopup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
}) {
  double intakeGoalValue = provider.getIntakeGoal;
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => BuildDialog(
          heightPercent: 0.3,
          onTapOK: () {
            provider.setIntakeGoal = intakeGoalValue;
            Navigator.pop(context);
          },
          content: Container(
            height: size.height * 0.25,
            padding: const EdgeInsets.all(20),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,

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
                      kCapacityUnitStrings[provider.getCapacityUnit ? 1 : 0],
                      style: const TextStyle(color: kPrimaryColor),
                    ),
                    SizedBox(width: size.width * 0.05),
                    InkWell(
                      onTap: () => setState(() => intakeGoalValue = kIntakeGoalDefaultValue),
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
                      )),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CupertinoSlider(
                      value: intakeGoalValue,
                      onChanged: (value) => setState(() => intakeGoalValue = value),
                      min: 800,
                      max: 4500,
                      divisions: 74,
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
  bool genderValue = provider.getGender;
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => BuildDialog(
          heightPercent: 0.25,
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
                SizedBox(height: size.height * 0.05),
                SlidingSwitch(
                  value: genderValue,
                  width: size.width * 0.5,
                  height: size.height * 0.045,
                  onChanged: (value) => setState(() => genderValue = value),
                  onTap: () {},
                  onSwipe: () {},
                  textLeft: 'Male',
                  textRight: 'Female',
                  buttonTextSize: 14,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// Weight selection popup dialog
Future<dynamic> weightSelectionPopup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
}) {
  int weightValue = provider.getWeight;

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => BuildDialog(
          heightPercent: 0.35,
          onTapOK: () {
            provider.setWeight = weightValue;
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
                          scrollController: FixedExtentScrollController(initialItem: weightValue),
                          itemExtent: 40,
                          onSelectedItemChanged: (value) => setState(() => weightValue = value),
                          childCount: 400,
                          itemBuilder: (context, index) => Text(
                            index.toString(),
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                      const Text(
                        'Kg',
                        style: TextStyle(
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

/// Convert hour and minutes to two digits if they are one digits
String twoDigits(int n) => n.toString().padLeft(2, "0");

/// Wake-up amd bed time popup dialog
wakeUpAndBedTimePopup({
  required BuildContext context,
  required DataProvider provider,
  required int hour,
  required int minute,
  required String title,
  required bool isWakeUp,
}) async {
  final TimeOfDay? timeOfDay = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(
      hour: hour,
      minute: minute,
    ),
    initialEntryMode: TimePickerEntryMode.dial,
    helpText: title,
  );
  if (timeOfDay != null) {
    if (isWakeUp) {
      provider.setWakeUpTimeHour = timeOfDay.hour;
      provider.setWakeUpTimeMinute = timeOfDay.minute;
    } else {
      provider.setBedTimeHour = timeOfDay.hour;
      provider.setBedTimeMinute = timeOfDay.minute;
    }
  }
}
