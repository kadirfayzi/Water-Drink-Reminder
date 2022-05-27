import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/functions.dart';
import 'package:water_reminder/models/record.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/screens/home/home_helpers.dart';
import 'package:water_reminder/widgets/elevated_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/circular_slider/appearance.dart';
import '../../widgets/circular_slider/circular_slider.dart';
import '../../widgets/liquid_progress_indicator/liquid_circular_progress_indicator.dart';
import '../../widgets/odometer/odometer_number.dart';
import '../../widgets/odometer/slide_odometer.dart';
import 'widgets/next_time_row.dart';
import 'widgets/records_column.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final localize = AppLocalizations.of(context)!;
    final List<String> localizedTips = localize.tips.split('.');
    localizedTips.shuffle();

    return Consumer<DataProvider>(
      builder: (context, provider, _) => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        child: Column(
          children: [
            /// Tips
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/images/water-glass-with-light-bulb.png',
                    scale: 1,
                  ),
                ),
                SizedBox(width: size.width * 0.02),
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: kRadius_25,
                        bottomRight: kRadius_25,
                        bottomLeft: kRadius_25,
                      ),
                      color: kPrimaryColor.withOpacity(0.1),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                        child: AnimatedTextKit(
                          repeatForever: true,
                          totalRepeatCount: 1,
                          pause: const Duration(seconds: 10),
                          animatedTexts: localizedTips
                              .map((tip) => TypewriterAnimatedText(
                                    tip,
                                    textStyle: TextStyle(fontSize: size.width * 0.035),
                                    textAlign: TextAlign.center,
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.02),
                Expanded(
                  child: GestureDetector(
                    onTap: () => tipsPopup(
                      context: context,
                      size: size,
                      localize: localize,
                      localizedTips: localizedTips,
                    ),
                    child: Column(
                      children: [
                        Image.asset('assets/images/light.png', scale: 5),
                        Text(
                          localize.moreTips,
                          style: const TextStyle(
                            color: kPrimaryColor,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// Daily Drink Target Circle
            Stack(
              clipBehavior: Clip.none,
              children: [
                SleekCircularSlider(
                  key: ValueKey(provider.getMainStateInitialized),
                  appearance: CircularSliderAppearance(
                    size: size.width * 0.785,
                    customWidths: CustomSliderWidths(
                      progressBarWidth: 8,
                      trackWidth: 8,
                      shadowWidth: 8,
                    ),
                    customColors: CustomSliderColors(
                      hideShadow: true,
                      dynamicGradient: true,
                      progressBarColors: [
                        Colors.blue.withOpacity(0.1),
                        Colors.blue.withOpacity(0.5),
                      ],
                      trackColors: [
                        Colors.grey.withOpacity(0.3),
                        Colors.grey.withOpacity(0.2),
                      ],
                    ),
                  ),
                  min: 0,
                  max: provider.getIntakeGoalAmount,
                  initialValue: provider.getDrankAmount,
                ),
                Positioned.fill(
                  child: Center(
                    child: ElevatedContainer(
                      width: size.width * 0.625,
                      height: size.width * 0.625,
                      blurRadius: 25,
                      shadowColor: Colors.black54,
                      child: LiquidCircularProgressIndicator(
                        value: provider.getDrankAmount / provider.getIntakeGoalAmount,
                        backgroundColor: Colors.white,
                        valueColor: provider.getDrankAmount == 0
                            ? const AlwaysStoppedAnimation(Colors.transparent)
                            : const AlwaysStoppedAnimation(kPrimaryColor),
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              localize.dailyDrinkTarget,
                              style: const TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedSlideOdometerNumber(
                                  odometerNumber: OdometerNumber(provider.getCapacityUnit == 0
                                      ? provider.getDrankAmount.toInt()
                                      : Functions.mlToFlOz(provider.getDrankAmount).toInt()),
                                  duration: const Duration(milliseconds: 500),
                                  letterWidth: 12,
                                  numberTextStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                                Visibility(
                                  visible: provider.getCapacityUnit == 0 ? false : true,
                                  child: const Text(
                                    '.',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: provider.getCapacityUnit == 0 ? false : true,
                                  child: AnimatedSlideOdometerNumber(
                                    odometerNumber: OdometerNumber(provider.getCapacityUnit == 0
                                        ? 0
                                        : int.parse(Functions.mlToFlOz(provider.getDrankAmount)
                                            .toStringAsFixed(1)
                                            .split('.')[1])),
                                    duration: const Duration(milliseconds: 500),
                                    letterWidth: 14,
                                    numberTextStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            '/${provider.getCapacityUnit == 0 ? provider.getIntakeGoalAmount.toStringAsFixed(0) : Functions.mlToFlOz(provider.getIntakeGoalAmount).toStringAsFixed(0)} ',
                                      ),
                                      TextSpan(
                                        text: kCapacityUnitStrings[provider.getCapacityUnit],
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),

                            /// Add water button
                            Container(
                              width: size.width * 0.2,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 0.5,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: kRadius_50,
                                  topRight: kRadius_50,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    spreadRadius: 5,
                                    color: Colors.black26,
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 5,
                                  ),
                                ],
                                gradient: const LinearGradient(
                                  colors: [Colors.white24, Colors.white],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  stops: [0.0, 1.0],
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  final double drankLimit = kDrankLimits[provider.getCapacityUnit];
                                  final double drankAmount = provider.getCapacityUnit == 0
                                      ? provider.getDrankAmount
                                      : Functions.mlToFlOz(provider.getDrankAmount);
                                  if (drankAmount < drankLimit) {
                                    /// Add drunk amount
                                    provider.addDrankAmount =
                                        provider.getDrankAmount + provider.getSelectedCup.capacity;

                                    provider.addRecord(
                                      record: Record(
                                        image: provider.getSelectedCup.image,
                                        time: DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now()),
                                        amount: provider.getSelectedCup.capacity,
                                      ),
                                    );

                                    provider.addToChartData(
                                      day: DateTime.now().day,
                                      month: DateTime.now().month,
                                      year: DateTime.now().year,
                                      drankAmount: provider.getDrankAmount,
                                      intakeGoalAmount: provider.getIntakeGoalAmount,
                                      recordCount: provider.getRecords.length,
                                    );

                                    provider.addToWeekData(
                                      drankAmount: provider.getDrankAmount,
                                      day: DateTime.now().weekday,
                                      intakeGoalAmount: provider.getIntakeGoalAmount,
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 5,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${provider.getCapacityUnit == 0 ? provider.getSelectedCup.capacity.toStringAsFixed(0) : Functions.mlToFlOz(provider.getSelectedCup.capacity).toStringAsFixed(1)} '
                                        '${kCapacityUnitStrings[provider.getCapacityUnit]}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Stack(
                                        children: [
                                          Image.asset(
                                            provider.getSelectedCup.image,
                                            scale: 4.5,
                                            color: Colors.black,
                                          ),
                                          Container(
                                            transform:
                                                getTransformValue(provider.getSelectedCup.image),
                                            child: const Icon(Icons.add, size: 15),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  top: 80,
                  left: -10,
                  right: -10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/drop.png',
                        color: Colors.black54,
                        scale: 2,
                      ),
                      Image.asset(
                        'assets/images/drop.png',
                        color: kPrimaryColor,
                        scale: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Row(
              children: [
                const Expanded(flex: 1, child: SizedBox()),
                Expanded(
                  flex: 6,
                  child: Container(
                    transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.keyboard_double_arrow_up,
                          color: kPrimaryColor,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          localize.confirmDrankWater,
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Switch cup
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () => switchCupPopup(context: context, localize: localize, size: size),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ElevatedContainer(
                          padding: const EdgeInsets.all(8.0),
                          blurRadius: 10,
                          child: Image.asset(provider.getSelectedCup.image, scale: 5),
                        ),
                        const Positioned(
                          top: 28,
                          left: 28,
                          child: ElevatedContainer(
                            blurRadius: 3.0,
                            child: Icon(
                              Icons.change_circle,
                              color: kPrimaryColor,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            /// Today's records
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    localize.todaysRecords,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  /// Add forgotten record
                  InkWell(
                    onTap: () => addForgottenRecordPopup(
                      context: context,
                      localize: localize,
                      size: size,
                    ),
                    child: const ElevatedContainer(
                      child: Icon(
                        Icons.add_circle,
                        size: 30,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(kRadius_10),
                color: kPrimaryColor.withOpacity(0.1),
              ),
              child: Column(
                children: [
                  /// Next time row
                  const NextTimeRow(),
                  const SizedBox(height: 10),

                  /// Records
                  const RecordsColumn(),
                  Visibility(
                    visible: provider.getRecords.isNotEmpty ? true : false,
                    child: const SizedBox(height: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Matrix4? getTransformValue(String cupImageString) {
    switch (cupImageString) {
      case 'assets/images/cups/100-128.png':
        return Matrix4.translationValues(3.5, 6.0, 0.0);
      case 'assets/images/cups/125-128.png':
        return Matrix4.translationValues(3.5, 6.0, 0.0);
      case 'assets/images/cups/150-128.png':
        return Matrix4.translationValues(3.0, 6.0, 0.0);
      case 'assets/images/cups/175-128.png':
        return Matrix4.translationValues(7.0, 6.0, 0.0);
      case 'assets/images/cups/200-128.png':
        return Matrix4.translationValues(7.0, 7.0, 0.0);
      case 'assets/images/cups/300-128.png':
        return Matrix4.translationValues(5.0, 7.0, 0.0);
      default:
        return Matrix4.translationValues(6.0, 7.0, 0.0);
    }
  }
}
