import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:water_reminder/provider/data_provider.dart';

class BedTimePage extends StatefulWidget {
  const BedTimePage({
    Key? key,
    required this.size,
    required this.localize,
    required this.provider,
  }) : super(key: key);

  final Size size;
  final AppLocalizations localize;
  final DataProvider provider;

  @override
  State<BedTimePage> createState() => _BedTimePageState();
}

class _BedTimePageState extends State<BedTimePage> {
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(
            widget.localize.bedTime,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: widget.size.height * 0.2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 800),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                Image.asset(
                  widget.provider.getGender == 0
                      ? 'assets/images/boy.png'
                      : 'assets/images/girl.png',
                  scale: 5,
                ),
                SizedBox(width: widget.size.width * 0.1),
                SizedBox(
                  width: widget.size.width * 0.35,
                  height: widget.size.height * 0.25,
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
                        widget.provider.getBedTimeHour,
                        widget.provider.getBedTimeMinute,
                      ),
                      mode: CupertinoDatePickerMode.time,
                      use24hFormat: true,
                      onDateTimeChanged: (selectedTime) => widget.provider.setBedTime(
                        selectedTime.hour,
                        selectedTime.minute,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
