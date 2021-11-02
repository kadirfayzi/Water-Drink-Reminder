import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/functions.dart';
import 'package:water_reminder/models/record_model.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/screens/home/home_helpers.dart';
import 'package:water_reminder/screens/home/home_subscreens/tips_screen.dart';
import 'package:water_reminder/widgets/dashed_line.dart';
import 'package:water_reminder/widgets/elevated_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _tip;
  final DateTime _time = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tip = getRandomTip();
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
                Visibility(
                  visible: !provider.getHideTips,
                  child: Row(
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
                              topRight: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                              bottomLeft: Radius.circular(25),
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
                            )),
                      ),
                      SizedBox(width: size.width * 0.02),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.push(context,
                              CupertinoPageRoute(builder: (context) => const TipsScreen())),
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
                          progressBarWidth: 5,
                          trackWidth: 5,
                          shadowWidth: 0,
                        ),
                        customColors: CustomSliderColors(
                          progressBarColor: kPrimaryColor,
                          trackColor: Colors.grey[300],
                        ),
                      ),
                      min: 0,
                      max: provider.getIntakeGoal,
                      initialValue: provider.getDrunkAmount,
                    ),

                    Positioned.fill(
                      child: Center(
                        child: ElevatedContainer(
                          width: size.width * 0.7,
                          height: size.height * 0.3,
                          shape: BoxShape.circle,
                          blurRadius: 3.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '${provider.getDrunkAmount.toStringAsFixed(0)}',
                                      style: const TextStyle(color: Colors.blue),
                                    ),
                                    TextSpan(
                                      text: '/${provider.getIntakeGoal.toStringAsFixed(0)}',
                                    ),
                                    const TextSpan(
                                      text: 'ml',
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: size.height * 0.01),
                              const Text(
                                'Daily Drink Target',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: size.height * 0.03),
                              InkWell(
                                onTap: () {
                                  if (provider.getDrunkAmount + provider.getCupCapacity <=
                                      provider.getIntakeGoal) {
                                    provider.addDrunkAmount = provider.getCupCapacity;
                                  }
                                  provider.addDrinkRecord(DrinkRecord(
                                    image: 'assets/images/cup.png',
                                    time: DateFormat("h:mm a").format(_time),
                                    defaultAmount: provider.getCupCapacity,
                                  ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${provider.getCupCapacity.toStringAsFixed(0)} ml',
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: size.height * 0.01),
                                      Image.asset(
                                        'assets/images/cup.png',
                                        scale: 4,
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

                    Positioned.fill(
                      top: size.height * 0.235,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'assets/images/3.png',
                              color: Colors.grey,
                              scale: 5,
                            ),
                            Image.asset(
                              'assets/images/3.png',
                              color: Colors.blue,
                              scale: 5,
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// Change cup type
                    Positioned.fill(
                      child: Align(
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
                                child: Image.asset('assets/images/cup.png', scale: 8),
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
                  blurRadius: 2.0,
                  borderRadius: BorderRadius.circular(5),
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
                                        children: const [
                                          Text(
                                            '05:00 PM',
                                          ),
                                          Text(
                                            'Next time',
                                            style: TextStyle(color: Colors.grey, fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child:
                                          Text('${provider.getCupCapacity.toStringAsFixed(0)}ml'),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: provider.getDrinkRecords.length > 0 ? true : false,
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
                            provider.getDrinkRecords.length,
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
                                            provider.getDrinkRecords[index].image,
                                            scale: 8,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Text(provider.getDrinkRecords[index].time),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                              '${provider.getDrinkRecords[index].dividedCapacity.toStringAsFixed(0)}ml'),
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
                                                provider.removeDrunkAmount =
                                                    provider.getDrinkRecords[index].dividedCapacity;
                                                provider.deleteDrinkRecord = index;
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
                                  provider.getDrinkRecords[index] != provider.getDrinkRecords.last
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