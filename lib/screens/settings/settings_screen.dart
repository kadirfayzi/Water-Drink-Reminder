import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:water_reminder/l10n/l10n.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/screens/settings/settings_helpers.dart';

import '../../functions.dart';
import 'widgets/build_title.dart';
import 'widgets/tappable_row.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  PackageInfo? _packageInfo;

  setPackageInfo() =>
      PackageInfo.fromPlatform().then((value) => setState(() => _packageInfo = value));

  @override
  void initState() {
    super.initState();
    setPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final localize = AppLocalizations.of(context)!;
    return Consumer<DataProvider>(
      builder: (context, provider, _) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildTitle(
              size: size,
              title: localize.reminderSettings,
            ),

            /// Reminder schedule section
            TappableRow(
              size: size,
              title: localize.reminderSchedule,
              icon: const Icon(Icons.schedule, color: Colors.grey, size: 20),
              onTap: () => reminderSchedulePopup(context: context),
            ),

            /// Reminder sound section
            TappableRow(
              size: size,
              title: localize.reminderSound,
              icon: const Icon(
                Icons.notifications_active_outlined,
                color: Colors.grey,
                size: 20,
              ),
              onTap: () => setSoundPopup(context: context),
            ),
            const SizedBox(height: 10),
            BuildTitle(
              size: size,
              title: localize.general,
            ),

            /// Unit section
            TappableRow(
              size: size,
              title: localize.unit,
              icon: const Icon(
                Icons.ad_units_outlined,
                color: Colors.grey,
                size: 20,
              ),
              content: Text(
                '${kWeightUnitStrings[provider.getWeightUnit]}, '
                '${kCapacityUnitStrings[provider.getCapacityUnit]}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: kPrimaryColor,
                ),
              ),
              contentVisible: true,
              onTap: () => setUnitPopup(context: context),
            ),

            /// Intake goal section
            TappableRow(
              size: size,
              title: localize.intakeGoal,
              icon: const Icon(
                Icons.flag_outlined,
                color: Colors.grey,
                size: 20,
              ),
              content: Text(
                '${provider.getCapacityUnit == 0 ? (provider.getIntakeGoalAmount).toStringAsFixed(0) : Functions.mlToFlOz(provider.getIntakeGoalAmount).toStringAsFixed(0)}'
                ' ${kCapacityUnitStrings[provider.getCapacityUnit]}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: kPrimaryColor,
                ),
              ),
              contentVisible: true,
              onTap: () => setIntakeGoalPopup(context: context),
            ),

            /// Language section
            TappableRow(
              size: size,
              title: localize.langWordTranslate,
              icon: const Icon(
                Icons.language,
                color: Colors.grey,
                size: 20,
              ),
              content: Row(
                children: [
                  Text(
                    localize.language,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    L10n.getFlag(localize.localeName),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
              contentVisible: true,
              onTap: () => setLanguagePopup(context: context),
            ),
            const SizedBox(height: 10),

            /// Personal information section
            BuildTitle(
              size: size,
              title: localize.personalInformation,
            ),

            /// Gender section
            TappableRow(
              size: size,
              title: localize.gender,
              icon: Stack(
                children: const [
                  Positioned(
                    top: -4,
                    left: 2,
                    child: Icon(
                      Icons.male,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                  Positioned(
                    child: Icon(
                      Icons.female,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                ],
              ),
              content: Text(
                provider.getGender == 0 ? localize.male : localize.female,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: kPrimaryColor,
                ),
              ),
              contentVisible: true,
              onTap: () => genderSelectionPopup(context: context),
            ),

            /// Weight section
            TappableRow(
              size: size,
              title: localize.weight,
              icon: const Icon(
                Icons.scale_outlined,
                color: Colors.grey,
                size: 20,
              ),
              content: Text(
                '${provider.getWeight} ${kWeightUnitStrings[provider.getWeightUnit]}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: kPrimaryColor,
                ),
              ),
              contentVisible: true,
              onTap: () => weightSelectionPopup(context: context),
            ),

            /// Wake-up time section
            TappableRow(
              size: size,
              title: localize.wakeUpTime,
              icon: const Icon(
                Icons.timer_outlined,
                color: Colors.grey,
                size: 20,
              ),
              content: Text(
                '${Functions.twoDigits(provider.getWakeUpTimeHour)}:${Functions.twoDigits(provider.getWakeUpTimeMinute)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: kPrimaryColor,
                ),
              ),
              contentVisible: true,
              onTap: () => wakeupAndBedtimePopup(
                context: context,
                isWakeUp: true,
                hour: provider.getWakeUpTimeHour,
                minute: provider.getWakeUpTimeMinute,
              ),
            ),

            /// Bed time section
            TappableRow(
              size: size,
              title: localize.bedTime,
              icon: const Icon(
                Icons.bedtime_outlined,
                color: Colors.grey,
                size: 20,
              ),
              content: Text(
                '${Functions.twoDigits(provider.getBedTimeHour)}:${Functions.twoDigits(provider.getBedTimeMinute)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: kPrimaryColor,
                ),
              ),
              contentVisible: true,
              onTap: () => wakeupAndBedtimePopup(
                context: context,
                isWakeUp: false,
                hour: provider.getBedTimeHour,
                minute: provider.getBedTimeMinute,
              ),
            ),
            const SizedBox(height: 10),
            BuildTitle(
              size: size,
              title: localize.other,
            ),

            /// Feedback section
            TappableRow(
              size: size,
              title: localize.feedback,
              icon: const Icon(
                Icons.feedback_outlined,
                color: Colors.grey,
                size: 20,
              ),
              onTap: () async {
                final Uri uri = Uri(
                  scheme: 'mailto',
                  path: kEmail,
                  query:
                      'subject=${_packageInfo?.appName}&body=${localize.appVersion} ${_packageInfo?.version}',
                );

                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {
                  throw 'Could not launch $uri';
                }
              },
            ),

            /// Rate app section
            TappableRow(
              size: size,
              title: localize.rateApp,
              icon: const Icon(
                Icons.star_border,
                color: Colors.grey,
                size: 20,
              ),
            ),

            /// Share section
            TappableRow(
              size: size,
              title: localize.shareApp,
              icon: const Icon(
                Icons.share,
                color: Colors.grey,
                size: 20,
              ),
              onTap: () => Share.share('check out my website https://example.com',
                  subject: 'Look what I made!'),
            ),

            const SizedBox(height: 40),
            Center(
              child: Text('${localize.version} ${_packageInfo?.version}'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
