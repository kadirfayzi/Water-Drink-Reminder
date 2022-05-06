import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/provider/data_provider.dart';

class WakeupTimePage extends StatelessWidget {
  const WakeupTimePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final localize = AppLocalizations.of(context)!;
    return Consumer<DataProvider>(
      builder: (context, provider, _) => Column(
        children: [
          Text(
            localize.wakeUpTime,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xff000000),
            ),
          ),
          SizedBox(height: size.height * 0.1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                provider.getGender == 0
                    ? 'assets/images/intro/wakeup_male.png'
                    : 'assets/images/intro/wakeup_female.png',
                scale: 3,
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: size.width * 0.35,
                height: size.height * 0.25,
                child: CupertinoTheme(
                  data: const CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        fontSize: 28,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    initialDateTime: DateTime.utc(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      provider.getWakeUpTimeHour,
                      provider.getWakeUpTimeMinute,
                    ),
                    mode: CupertinoDatePickerMode.time,
                    use24hFormat: true,
                    onDateTimeChanged: (selectedTime) => provider.setWakeUpTime(
                      selectedTime.hour,
                      selectedTime.minute,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
