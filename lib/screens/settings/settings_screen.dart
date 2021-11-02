import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/screens/settings/settings_subscreens/reminder_schedule.dart';
import 'package:water_reminder/screens/settings/settings_subscreens/reminder_sound.dart';
import 'package:water_reminder/screens/settings/settings_helpers.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool switch1 = false;
  bool switch2 = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<DataProvider>(builder: (context, provider, _) {
      return Scrollbar(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitle(size: size, title: 'Reminder settings'),

            /// Reminder schedule section
            buildTappableRow(
              size: size,
              title: 'Reminder schedule',
              onTap: () => Navigator.push(
                  context, CupertinoPageRoute(builder: (ctx) => const ReminderSchedule())),
            ),

            /// Reminder sound section
            buildTappableRow(
              size: size,
              title: 'Reminder sound',
              onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(builder: (ctx) => const ReminderSound()),
              ),
            ),

            /// Reminder mode section
            buildTappableRow(
              size: size,
              title: 'Reminder mode',
              content: Text(
                kReminderModeStrings[provider.getReminderMode],
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: kPrimaryColor,
                ),
              ),
              contentVisible: true,
              onTap: () => reminderModePopup(
                context: context,
                provider: provider,
                size: size,
              ),
            ),

            /// Further reminder section
            SwitchListTile(
              value: switch1,
              onChanged: (value) => setState(() => switch1 = value),
              title: const Text(
                'Further reminder',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              subtitle: const Text(
                'Still remind when your goal is achieved',
                style: TextStyle(fontSize: 12),
              ),
              activeColor: kPrimaryColor,
              activeTrackColor: kSecondaryColor,
            ),
            const SizedBox(height: 10),
            buildTitle(size: size, title: 'General'),

            /// Remove ADS section
            buildTappableRow(size: size, title: 'Remove ADS'),

            /// Unit section
            buildTappableRow(
              size: size,
              title: 'Unit',
              content: Text(
                '${kWeightUnitStrings[provider.getWeightUnit ? 1 : 0]}, ${kCapacityUnitStrings[provider.getCapacityUnit ? 1 : 0]}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: kPrimaryColor,
                ),
              ),
              contentVisible: true,
              onTap: () => unitPopup(
                context: context,
                provider: provider,
                size: size,
              ),
            ),

            /// Intake goal section
            buildTappableRow(
              size: size,
              title: 'Intake goal',
              content: Text(
                '${(provider.getIntakeGoal).toStringAsFixed(0)} ${kCapacityUnitStrings[provider.getCapacityUnit ? 1 : 0]}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: kPrimaryColor,
                ),
              ),
              contentVisible: true,
              onTap: () => intakeGoalPopup(
                context: context,
                provider: provider,
                size: size,
              ),
            ),

            /// Language section
            buildTappableRow(
              size: size,
              title: 'Language',
              content: const Text(
                'Default',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: kPrimaryColor,
                ),
              ),
              contentVisible: true,
            ),
            SizedBox(height: size.height * 0.01),

            /// Personal information section
            buildTitle(size: size, title: 'Personal information'),

            /// Gender section
            buildTappableRow(
              size: size,
              title: 'Gender',
              content: Text(
                kGenderStrings[provider.getGender ? 1 : 0],
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: kPrimaryColor,
                ),
              ),
              contentVisible: true,
              onTap: () => genderSelectionPopup(
                context: context,
                provider: provider,
                size: size,
              ),
            ),

            /// Weight section
            buildTappableRow(
              size: size,
              title: 'Weight',
              content: Text(
                '${provider.getWeight} ${kWeightUnitStrings[provider.getWeightUnit ? 1 : 0]}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: kPrimaryColor,
                ),
              ),
              contentVisible: true,
              onTap: () => weightSelectionPopup(
                context: context,
                provider: provider,
                size: size,
              ),
            ),

            /// Wake-up time section
            buildTappableRow(
              size: size,
              title: 'Wake-up time',
              content: Text(
                '${twoDigits(provider.getWakeUpTimeHour)}:${twoDigits(provider.getWakeUpTimeMinute)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: kPrimaryColor,
                ),
              ),
              contentVisible: true,
              onTap: () => wakeUpAndBedTimePopup(
                context: context,
                provider: provider,
                isWakeUp: true,
                title: 'Wake-up time',
                hour: provider.getWakeUpTimeHour,
                minute: provider.getWakeUpTimeMinute,
              ),
            ),

            /// Bed time section
            buildTappableRow(
              size: size,
              title: 'Bed time',
              content: Text(
                '${twoDigits(provider.getBedTimeHour)}:${twoDigits(provider.getBedTimeMinute)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: kPrimaryColor,
                ),
              ),
              contentVisible: true,
              onTap: () => wakeUpAndBedTimePopup(
                context: context,
                provider: provider,
                isWakeUp: false,
                title: 'Bed time',
                hour: provider.getBedTimeHour,
                minute: provider.getBedTimeMinute,
              ),
            ),
            const SizedBox(height: 10),
            buildTitle(size: size, title: 'Other'),

            /// Hide tips section
            SwitchListTile(
              value: provider.getHideTips,
              onChanged: (value) => setState(() => provider.setHideTips = value),
              title: const Text(
                'Hide tips on how to drink water',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              activeColor: kPrimaryColor,
              activeTrackColor: kSecondaryColor,
            ),
            buildTappableRow(size: size, title: 'Why does Drink Water Reminder not work?'),

            /// Reset data section
            buildTappableRow(size: size, title: 'Reset data'),

            /// Feedback section
            buildTappableRow(size: size, title: 'Feedback'),

            /// Share section
            buildTappableRow(size: size, title: 'Share'),

            /// Privacy policy section
            buildTappableRow(size: size, title: 'Privacy policy'),
          ],
        ),
      ));
    });
  }
}
