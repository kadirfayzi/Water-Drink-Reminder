import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/provider/data_provider.dart';

class BedTimePage extends StatefulWidget {
  const BedTimePage({Key? key}) : super(key: key);

  @override
  State<BedTimePage> createState() => _BedTimePageState();
}

class _BedTimePageState extends State<BedTimePage> {
  final _now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<DataProvider>(
      builder: (context, provider, _) => Column(
        children: [
          const Text(
            'Bedtime',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: size.height * 0.2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                provider.getGender == 0 ? 'assets/images/boy.png' : 'assets/images/girl.png',
                scale: 5,
              ),
              SizedBox(width: size.width * 0.1),
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
                      _now.year,
                      _now.month,
                      _now.day,
                      provider.getBedTimeHour,
                      provider.getBedTimeMinute,
                    ),
                    mode: CupertinoDatePickerMode.time,
                    use24hFormat: true,
                    onDateTimeChanged: (selectedTime) => provider.setBedTime(
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
