import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:water_reminder/l10n/l10n.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/screens/settings/settings_helpers.dart';

import '../../functions.dart';

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
            buildTitle(size: size, title: AppLocalizations.of(context)!.reminderSettings),

            /// Reminder schedule section
            buildTappableRow(
              size: size,
              title: AppLocalizations.of(context)!.reminderSchedule,
              onTap: () => reminderSchedulePopup(context: context, provider: provider, size: size),
            ),

            /// Reminder sound section
            buildTappableRow(
              size: size,
              title: AppLocalizations.of(context)!.reminderSound,
              onTap: () => setSoundPopup(context: context, provider: provider, size: size),
            ),
            const SizedBox(height: 10),
            buildTitle(size: size, title: AppLocalizations.of(context)!.general),

            /// Unit section
            buildTappableRow(
              size: size,
              title: AppLocalizations.of(context)!.unit,
              content: Text(
                '${kWeightUnitStrings[provider.getWeightUnit]}, ${kCapacityUnitStrings[provider.getCapacityUnit]}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: kPrimaryColor,
                ),
              ),
              contentVisible: true,
              onTap: () => setUnitPopup(
                context: context,
                provider: provider,
                size: size,
              ),
            ),

            /// Intake goal section
            buildTappableRow(
              size: size,
              title: AppLocalizations.of(context)!.intakeGoal,
              content: Text(
                '${(provider.getIntakeGoalAmount).toStringAsFixed(0)} ${kCapacityUnitStrings[provider.getCapacityUnit]}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: kPrimaryColor,
                ),
              ),
              contentVisible: true,
              onTap: () => setIntakeGoalPopup(
                context: context,
                provider: provider,
                size: size,
              ),
            ),

            /// Language section
            buildTappableRow(
              size: size,
              title: AppLocalizations.of(context)!.langWordTranslate,
              content: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.language,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    L10n.getFlag(AppLocalizations.of(context)!.localeName),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
              contentVisible: true,
              onTap: () => setLanguagePopup(context: context, provider: provider, size: size),
            ),
            SizedBox(height: size.height * 0.01),

            /// Personal information section
            buildTitle(size: size, title: 'Personal information'),

            /// Gender section
            buildTappableRow(
              size: size,
              title: AppLocalizations.of(context)!.gender,
              content: Text(
                provider.getGender == 0
                    ? AppLocalizations.of(context)!.male
                    : AppLocalizations.of(context)!.female,
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
              title: AppLocalizations.of(context)!.weight,
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
              title: AppLocalizations.of(context)!.wakeUpTime,
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
                hour: provider.getWakeUpTimeHour,
                minute: provider.getWakeUpTimeMinute,
              ),
            ),

            /// Bed time section
            buildTappableRow(
              size: size,
              title: AppLocalizations.of(context)!.bedTime,
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
                hour: provider.getBedTimeHour,
                minute: provider.getBedTimeMinute,
              ),
            ),
            const SizedBox(height: 10),
            buildTitle(size: size, title: AppLocalizations.of(context)!.other),

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
