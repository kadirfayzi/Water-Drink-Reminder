import 'dart:async';
import 'dart:ui';
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
import '../../widgets/glassmorphism.dart';
import '../../widgets/liquid_progress_indicator/liquid_circular_progress_indicator.dart';
import '../../widgets/odometer/odometer_number.dart';
import '../../widgets/odometer/slide_odometer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _drinkWaterButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<DataProvider>(
      builder: (context, provider, _) {
        return Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
                      child: GlassmorphicContainer(
                        height: size.height * 0.085,
                        borderRadius: const BorderRadius.only(
                          topRight: kRadius_25,
                          bottomRight: kRadius_25,
                          bottomLeft: kRadius_25,
                        ),
                        blur: 10,
                        linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.blue.withOpacity(0.1),
                            Colors.blue.withOpacity(0.05),
                          ],
                          stops: const [0.1, 1],
                        ),
                        child: Center(
                          child: AnimatedTextKit(
                            repeatForever: true,
                            pause: const Duration(seconds: 5),
                            animatedTexts: List.generate(
                              tips.length,
                              (index) => TypewriterAnimatedText(
                                tips[index],
                                textAlign: TextAlign.center,
                              ),
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
                          provider: provider,
                          size: size,
                        ),
                        child: Column(
                          children: [
                            Image.asset('assets/images/light.png', scale: 5),
                            Text(
                              AppLocalizations.of(context)!.moreTips,
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
                SizedBox(height: size.height * 0.03),

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
                                  AppLocalizations.of(context)!.dailyDrinkTarget,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: size.height * 0.01),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AnimatedSlideOdometerNumber(
                                      odometerNumber: OdometerNumber(provider.getCapacityUnit == 0
                                          ? provider.getDrankAmount.toInt()
                                          : mlToFlOz(provider.getDrankAmount).toInt()),
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
                                            : int.parse(mlToFlOz(provider.getDrankAmount)
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
                                                '/${provider.getCapacityUnit == 0 ? provider.getIntakeGoalAmount.toStringAsFixed(0) : mlToFlOz(provider.getIntakeGoalAmount).toStringAsFixed(0)} ',
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
                                SizedBox(height: size.height * 0.03),

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
                                    boxShadow: [
                                      BoxShadow(
                                        spreadRadius: _drinkWaterButtonPressed ? 0 : 5,
                                        color: Colors.black26,
                                        offset: const Offset(0.0, 1.0), //(x,y)
                                        blurRadius: _drinkWaterButtonPressed ? 0 : 5,
                                      ),
                                    ],
                                    gradient: const LinearGradient(
                                      colors: [
                                        Colors.white24,
                                        Colors.white,
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      stops: [0.0, 1.0],
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: !_drinkWaterButtonPressed
                                        ? () {
                                            setState(() => _drinkWaterButtonPressed = true);

                                            final double drankLimit =
                                                kDrankLimits[provider.getCapacityUnit];
                                            final double drankAmount = provider.getCapacityUnit == 0
                                                ? provider.getDrankAmount
                                                : mlToFlOz(provider.getDrankAmount);
                                            if (drankAmount < drankLimit) {
                                              /// Add drunk amount
                                              provider.addDrankAmount = provider.getDrankAmount +
                                                  provider.getSelectedCup.capacity;

                                              provider.addRecord(
                                                Record(
                                                  image: provider.getSelectedCup.image,
                                                  time: DateFormat("yyyy-MM-dd HH:mm")
                                                      .format(DateTime.now()),
                                                  defaultAmount: provider.getSelectedCup.capacity,
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
                                            Future.delayed(
                                              const Duration(milliseconds: 150),
                                              () =>
                                                  setState(() => _drinkWaterButtonPressed = false),
                                            );
                                          }
                                        : () {},
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 20,
                                        bottom: 5,
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${provider.getCapacityUnit == 0 ? provider.getSelectedCup.capacity.toStringAsFixed(0) : mlToFlOz(provider.getSelectedCup.capacity).toStringAsFixed(1)} '
                                            '${kCapacityUnitStrings[provider.getCapacityUnit]}',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(height: size.height * 0.01),
                                          Stack(
                                            children: [
                                              Image.asset(
                                                provider.getSelectedCup.image,
                                                scale: 4.5,
                                                color: Colors.black,
                                              ),
                                              const Positioned.fill(
                                                  child: Icon(
                                                Icons.add,
                                                size: 15,
                                              )),
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
                      top: size.height * 0.1,
                      left: size.width * -0.03,
                      right: size.width * -0.03,
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
                              AppLocalizations.of(context)!.confirmDrankWater,
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
                        onTap: () => switchCup(
                          context: context,
                          provider: provider,
                          size: size,
                        ),
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
                                  size: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.05),

                /// Today's records
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.todaysRecords,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    /// Add forgotten record
                    InkWell(
                      onTap: () => addForgottenRecordPopup(
                        context: context,
                        provider: provider,
                        size: size,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: Icon(Icons.add, size: 25),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.01),

                ClipRRect(
                  borderRadius: const BorderRadius.all(kRadius_10),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 20),
                    child: Container(
                      width: size.width,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.blue.shade200.withOpacity(0.1),
                            Colors.blue.shade200.withOpacity(0.05),
                          ],
                          stops: const [0.1, 1],
                        ),
                      ),
                      child: Column(
                        children: [
                          /// Next time row
                          nextTimeRow(size, context, provider),

                          /// Records
                          recordsColumn(provider, size, context),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// /// /// /// //
  /// Next time row
  /// /// /// /// //
  SizedBox nextTimeRow(
    Size size,
    BuildContext context,
    DataProvider provider,
  ) =>
      SizedBox(
        height: size.height * 0.1,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(kRadius_5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// First row
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.grey),
                      SizedBox(width: size.width * 0.04),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.nextTime,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            provider.getNextDrinkTime,
                            style: const TextStyle(
                              color: kPrimaryColor,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  /// Second row
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  '${provider.getCapacityUnit == 0 ? provider.getSelectedCup.capacity.toStringAsFixed(0) : mlToFlOz(provider.getSelectedCup.capacity).toStringAsFixed(1)} ',
                            ),
                            TextSpan(
                              text: kCapacityUnitStrings[provider.getCapacityUnit],
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: size.width * 0.05),
                      provider.getRecords.isNotEmpty
                          ? IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(Icons.delete),
                              onPressed: () => clearAllRecords(
                                context: context,
                                provider: provider,
                                size: size,
                              ),
                            )
                          : Container(),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Visibility(
              visible: provider.getRecords.isNotEmpty ? true : false,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    children: const [
                      Icon(Icons.water_drop, size: 5, color: Colors.black54),
                      SizedBox(height: 5),
                      Icon(Icons.water_drop, size: 5, color: Colors.black54),
                      SizedBox(height: 5),
                      Icon(Icons.water_drop, size: 5, color: Colors.black54),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  /// /// /// /// //
  /// Records Column
  /// /// /// /// //
  Column recordsColumn(
    DataProvider provider,
    Size size,
    BuildContext context,
  ) =>
      Column(
        children: List.generate(
          provider.getRecords.length,
          (index) => SizedBox(
            height: size.height * 0.08,
            child: Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    highlightColor: Colors.grey.shade300,
                    splashColor: Colors.grey.shade300,
                    borderRadius: const BorderRadius.all(kRadius_5),
                    onTap: () => editOrDeleteSelectedRecordPopup(
                      context: context,
                      provider: provider,
                      size: size,
                      recordIndex: index,
                      now: DateTime.now(),
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 20,
                        top: 12,
                        bottom: 12,
                      ),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(kRadius_5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                provider.getRecords.reversed.toList()[index].image,
                                scale: 7,
                              ),
                              SizedBox(width: size.width * 0.05),
                              Text(provider.getRecords.reversed.toList()[index].time.split(' ')[1]),
                            ],
                          ),
                          Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          '${provider.getCapacityUnit == 0 ? provider.getRecords.reversed.toList()[index].dividedCapacity.toStringAsFixed(0) : mlToFlOz(provider.getRecords.reversed.toList()[index].dividedCapacity).toStringAsFixed(1)} ',
                                    ),
                                    TextSpan(
                                      text: kCapacityUnitStrings[provider.getCapacityUnit],
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: size.width * 0.08),
                              Column(
                                children: const [
                                  Icon(Icons.water_drop, size: 5),
                                  Icon(Icons.water_drop, size: 5),
                                  Icon(Icons.water_drop, size: 5),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                provider.getRecords.reversed.toList()[index] != provider.getRecords.first
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: Column(
                            children: const [
                              Icon(Icons.water_drop, size: 5, color: Colors.black54),
                              SizedBox(height: 5),
                              Icon(Icons.water_drop, size: 5, color: Colors.black54),
                              SizedBox(height: 5),
                              Icon(Icons.water_drop, size: 5, color: Colors.black54),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      );
}
