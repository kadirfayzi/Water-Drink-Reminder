import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
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
    return Consumer<DataProvider>(
      builder: (context, provider, _) => Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTitle(size: size, title: AppLocalizations.of(context)!.reminderSettings),

              /// Reminder schedule section
              buildTappableRow(
                size: size,
                title: AppLocalizations.of(context)!.reminderSchedule,
                onTap: () =>
                    reminderSchedulePopup(context: context, provider: provider, size: size),
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
                  '${provider.getCapacityUnit == 0 ? (provider.getIntakeGoalAmount).toStringAsFixed(0) : mlToFlOz(provider.getIntakeGoalAmount).toStringAsFixed(0)}'
                  ' ${kCapacityUnitStrings[provider.getCapacityUnit]}',
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
              buildTitle(size: size, title: AppLocalizations.of(context)!.personalInformation),

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

              /// Feedback section
              buildTappableRow(
                size: size,
                title: AppLocalizations.of(context)!.feedback,
                onTap: () async {
                  final Uri params = Uri(
                    scheme: 'mailto',
                    path: kEmail,
                    query:
                        'subject=${_packageInfo?.appName}&body=${AppLocalizations.of(context)!.appVersion} ${_packageInfo?.version}',
                  );

                  var url = params.toString();
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),

              /// Rate app section
              buildTappableRow(size: size, title: AppLocalizations.of(context)!.rateApp),

              /// Share section
              buildTappableRow(
                size: size,
                title: AppLocalizations.of(context)!.shareApp,
                onTap: () => Share.share('check out my website https://example.com',
                    subject: 'Look what I made!'),
              ),

              SizedBox(height: size.height * 0.05),
              Center(
                child: Text('${AppLocalizations.of(context)!.version} ${_packageInfo?.version}'),
              ),
              SizedBox(height: size.height * 0.08),
            ],
          ),
        ),
      ),
    );
  }
}
