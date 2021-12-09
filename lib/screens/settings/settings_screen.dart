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
            const SizedBox(height: 10),
            buildTitle(size: size, title: 'General'),

            /// Unit section
            buildTappableRow(
              size: size,
              title: 'Unit',
              content: Text(
                '${kWeightUnitStrings[provider.getWeightUnit]}, ${kCapacityUnitStrings[provider.getCapacityUnit]}',
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
                '${(provider.getIntakeGoalAmount).toStringAsFixed(0)} ${kCapacityUnitStrings[provider.getCapacityUnit]}',
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
                kGenderStrings[provider.getGender],
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
                '${provider.getWeight} ${kWeightUnitStrings[provider.getWeightUnit]}',
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
              onTap: () => wakeupAndBedtimePopup(
                context: context,
                size: size,
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
              onTap: () => wakeupAndBedtimePopup(
                context: context,
                size: size,
                provider: provider,
                isWakeUp: false,
                title: 'Bed time',
                hour: provider.getBedTimeHour,
                minute: provider.getBedTimeMinute,
              ),
            ),
            const SizedBox(height: 10),
            buildTitle(size: size, title: 'Other'),

            /// Reset data section
            buildTappableRow(size: size, title: 'Reset data'),

            /// Feedback section
            buildTappableRow(size: size, title: 'Feedback'),

            /// Rate app section
            buildTappableRow(size: size, title: 'Rate app'),

            /// Share section
            buildTappableRow(size: size, title: 'Share app'),

            /// Privacy policy section
            buildTappableRow(size: size, title: 'Privacy policy'),
            const SizedBox(height: 20),
          ],
        ),
      ));
    });
  }
}
