import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/functions.dart';
import 'package:water_reminder/models/drunk_amount.dart';
import 'package:water_reminder/models/record.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/screens/home/home_helpers.dart';
import 'package:water_reminder/screens/home/home_subscreens/tips_screen.dart';
import 'package:water_reminder/widgets/dashed_line.dart';
import 'package:water_reminder/widgets/elevated_container.dart';

import '../../widgets/circular_slider/appearance.dart';
import '../../widgets/circular_slider/circular_slider.dart';
import '../../widgets/liquid_progress_indicator/liquid_circular_progress_indicator.dart';
import '../../widgets/sliding_number.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _tip;
  final DateTime _now = DateTime.now();
  bool _buttonPressed = false;

  String _nextTime = '';

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (mounted) {
        setState(() => _nextTime = calculateNextDrinkTime(
            scheduleRecords: Provider.of<DataProvider>(context, listen: false).getScheduleRecords));
      }
    });
    _tip = getRandomTip();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<DataProvider>(
      builder: (context, provider, _) {
        return Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                /// Tips
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/images/1.png',
                        scale: 1,
                      ),
                    ),
                    SizedBox(width: size.width * 0.02),
                    Expanded(
                      flex: 3,
                      child: ElevatedContainer(
                        height: size.height * 0.085,
                        color: kSecondaryColor,
                        shadowColor: kSecondaryColor,
                        shape: BoxShape.rectangle,
                        padding: const EdgeInsets.all(8.0),
                        blurRadius: 0.0,
                        borderRadius: const BorderRadius.only(
                          topRight: kRadius_25,
                          bottomRight: kRadius_25,
                          bottomLeft: kRadius_25,
                        ),
                        child: Center(
                          child: Text(
                            _tip,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: size.width * 0.02),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                            context, CupertinoPageRoute(builder: (context) => const TipsScreen())),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/light.png',
                              scale: 5,
                            ),
                            const Text(
                              'More tips',
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 13,
                              ),
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
                      appearance: CircularSliderAppearance(
                        size: size.width * 0.8,
                        customWidths: CustomSliderWidths(
                          progressBarWidth: 8,
                          trackWidth: 8,
                          shadowWidth: 8,
                        ),
                        customColors: CustomSliderColors(
                            progressBarColors: [Colors.blue[600]!, Colors.lightBlueAccent],
                            trackColors: [Colors.grey[350]!, Colors.grey[200]!]),
                      ),
                      min: 0,
                      max: provider.getIntakeGoalAmount,
                      initialValue: provider.getDrunkAmount,
                    ),
                    Positioned.fill(
                      child: Center(
                        child: ElevatedContainer(
                          width: size.width * 0.685,
                          height: size.width * 0.685,
                          blurRadius: _buttonPressed ? 2 : 10,
                          child: LiquidCircularProgressIndicator(
                            value: provider.getDrunkAmount / provider.getIntakeGoalAmount,
                            backgroundColor: Colors.white,
                            valueColor: provider.getDrunkAmount == 0
                                ? const AlwaysStoppedAnimation(Colors.transparent)
                                : const AlwaysStoppedAnimation(kPrimaryColor),
                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SlidingNumber(
                                      number: provider.getDrunkAmount.toInt(),
                                      style: TextStyle(
                                        color: (provider.getDrunkAmount /
                                                    provider.getIntakeGoalAmount) >
                                                0.525
                                            ? kSecondaryColor
                                            : kPrimaryColor,
                                        fontSize: 22,
                                      ),
                                      duration: const Duration(milliseconds: 1000),
                                      curve: Curves.easeOutQuint,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                '/${provider.getIntakeGoalAmount.toStringAsFixed(0)} ',
                                          ),
                                          TextSpan(
                                            text: kCapacityUnitStrings[provider.getCapacityUnit],
                                            style: const TextStyle(fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  'Daily Drink Target',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        (provider.getDrunkAmount / provider.getIntakeGoalAmount) >
                                                0.615
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                                SizedBox(height: size.height * 0.03),
                                InkWell(
                                  onTap: !_buttonPressed
                                      ? () {
                                          setState(() => _buttonPressed = true);

                                          /// Add drunk amount
                                          provider.addDrunkAmount = DrunkAmount(
                                            drunkAmount: provider.getDrunkAmount +
                                                provider.getSelectedCup.capacity,
                                          );

                                          provider.addRecord(
                                            Record(
                                              image: provider.getSelectedCup.image,
                                              time: DateFormat("yyyy-MM-dd HH:mm").format(_now),
                                              defaultAmount: provider.getSelectedCup.capacity,
                                            ),
                                          );

                                          double drunkAmountForChart = provider.getDrunkAmount;
                                          if (provider.getDrunkAmount >
                                              provider.getIntakeGoalAmount) {
                                            drunkAmountForChart = provider.getIntakeGoalAmount;
                                          }
                                          provider.addMonthDayChartData(
                                            day: _now.day,
                                            drunkAmount: drunkAmountForChart,
                                            intakeGoalAmount: provider.getIntakeGoalAmount,
                                          );

                                          Future.delayed(
                                            const Duration(milliseconds: 150),
                                            () => setState(() => _buttonPressed = false),
                                          );
                                        }
                                      : () {},
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${provider.getSelectedCup.capacity.toStringAsFixed(0)} '
                                          '${kCapacityUnitStrings[provider.getCapacityUnit]}',
                                          style: TextStyle(
                                            color: (provider.getDrunkAmount /
                                                        provider.getIntakeGoalAmount) >
                                                    0.5
                                                ? Colors.white
                                                : Colors.black54,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: size.height * 0.01),
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Image.asset(
                                              provider.getSelectedCup.image,
                                              scale: 3,
                                            ),
                                            const Icon(Icons.add),
                                          ],
                                        ),
                                      ],
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
                            color: Colors.grey,
                            scale: 2,
                          ),
                          Image.asset(
                            'assets/images/drop.png',
                            color: Colors.blue,
                            scale: 2,
                          ),
                        ],
                      ),
                    ),
                    Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Icon(
                            Icons.arrow_drop_up,
                            color: Colors.black54,
                          ),
                          Text(
                            'Confirm that you have just drunk water',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                /// Switch cup
                Align(
                  alignment: Alignment.bottomRight,
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
                          blurRadius: 3.0,
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
                SizedBox(height: size.height * 0.05),

                /// Today's records
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(
                        'Today\'s Records',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Material(
                      child: InkWell(
                        onTap: () => addForgottenRecordPopup(
                          context: context,
                          provider: provider,
                          size: size,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Icon(Icons.add, size: 25),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                ElevatedContainer(
                  width: size.width,
                  shape: BoxShape.rectangle,
                  blurRadius: 2.5,
                  padding: const EdgeInsets.all(10),
                  child: Material(
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.085,
                          child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Expanded(
                                      flex: 2,
                                      child: Icon(
                                        Icons.access_time,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(_nextTime),
                                          const Text(
                                            'Next time',
                                            style: TextStyle(color: Colors.grey, fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                          '${provider.getSelectedCup.capacity.toStringAsFixed(0)} '
                                          '${kCapacityUnitStrings[provider.getCapacityUnit]}'),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: provider.getRecords.length != 0
                                          ? InkWell(
                                              child: const Icon(Icons.refresh),
                                              onTap: () => clearAllRecords(
                                                context: context,
                                                provider: provider,
                                                size: size,
                                              ),
                                            )
                                          : Container(),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: provider.getRecords.length > 0 ? true : false,
                                child: Expanded(
                                  child: Row(
                                    children: const [
                                      Expanded(flex: 2, child: DashedLine()),
                                      Expanded(flex: 9, child: SizedBox()),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: List.generate(
                            provider.getRecords.length,
                            (index) => SizedBox(
                              height: size.height * 0.0685,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Image.asset(
                                            provider.getRecords[index].image,
                                            scale: 8,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child:
                                              Text(provider.getRecords[index].time.split(' ')[1]),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                              '${provider.getRecords[index].dividedCapacity.toStringAsFixed(0)} '
                                              '${kCapacityUnitStrings[provider.getCapacityUnit]}'),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: PopupMenuButton<dynamic>(
                                            padding: const EdgeInsets.all(0),
                                            tooltip: 'Edit/Delete Record',
                                            icon: const Icon(
                                              Icons.more_vert,
                                              color: Colors.grey,
                                              size: 20,
                                            ),
                                            onSelected: (value) {
                                              if (value == 0) {
                                                editRecordPopup(
                                                  context: context,
                                                  provider: provider,
                                                  size: size,
                                                  recordIndex: index,
                                                );
                                              } else {
                                                if ((provider.getDrunkAmount -
                                                        provider
                                                            .getRecords[index].dividedCapacity) >=
                                                    0) {
                                                  provider.addDrunkAmount = DrunkAmount(
                                                      drunkAmount: provider.getDrunkAmount -
                                                          provider
                                                              .getRecords[index].dividedCapacity);
                                                }

                                                provider.deleteRecord = index;

                                                provider.addMonthDayChartData(
                                                  day: _now.day,
                                                  drunkAmount: provider.getDrunkAmount,
                                                  intakeGoalAmount: provider.getIntakeGoalAmount,
                                                );
                                              }
                                            },
                                            itemBuilder: (ctx) => [
                                              PopupMenuItem(
                                                value: 0,
                                                height: size.height * 0.025,
                                                child: const Text(
                                                  'Edit',
                                                  style: TextStyle(fontSize: 14),
                                                ),
                                              ),
                                              const PopupMenuDivider(),
                                              PopupMenuItem(
                                                value: 1,
                                                height: size.height * 0.025,
                                                child: const Text(
                                                  'Delete',
                                                  style: TextStyle(fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  provider.getRecords[index] != provider.getRecords.last
                                      ? Expanded(
                                          child: Row(
                                            children: const [
                                              Expanded(flex: 2, child: DashedLine()),
                                              Expanded(flex: 9, child: SizedBox()),
                                            ],
                                          ),
                                        )
                                      : const Expanded(child: SizedBox()),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
}
