import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/models/cup.dart';
import 'package:water_reminder/models/drunk_amount.dart';
import 'package:water_reminder/models/record.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/widgets/build_dialog.dart';
import 'package:water_reminder/widgets/elevated_container.dart';

/// Edit record popup dialog
Future<dynamic> editRecordPopup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
  required int recordIndex,
}) {
  int selectedCupDivisionIndex =
      provider.getRecords[recordIndex].cupDivisionIndex;

  final Record record = provider.getRecords[recordIndex];
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => BuildDialog(
          heightPercent: 0.45,
          onTapOK: () {
            // provider.removeDrunkAmount = record.dividedCapacity;
            provider.removeDrunkAmount = DrunkAmount(
                drunkAmount: provider.getDrunkAmount - record.dividedCapacity);
            provider.editRecord(
              recordIndex,
              Record(
                image: 'assets/images/cup.png',
                time: record.time,
                defaultAmount: record.defaultAmount,
                cupDivisionIndex: selectedCupDivisionIndex,
              ),
            );

            // provider.addOrRemoveDrunkAmount =
            //     (record.defaultAmount * (selectedCupDivisionIndex + 1)) / 4;

            Navigator.pop(context);
          },
          content: Container(
            height: size.height * 0.4,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      const Text(
                        'Intake at ',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        record.time,
                        style: const TextStyle(
                          fontSize: 18,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Image.asset('assets/images/cup.png', scale: 2),
                SizedBox(height: size.height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    4,
                    (index) => GestureDetector(
                      onTap: () =>
                          setState(() => selectedCupDivisionIndex = index),
                      child: Column(
                        children: [
                          ElevatedContainer(
                            width: 40,
                            height: 40,
                            blurRadius: 2,
                            color: selectedCupDivisionIndex == index
                                ? kPrimaryColor
                                : Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: kRadius_25,
                              topRight: kRadius_25,
                              bottomRight: kRadius_25,
                            ),
                            child: Center(
                              child: Text(
                                kCupDivisionStrings[index],
                                style: TextStyle(
                                  color: selectedCupDivisionIndex == index
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${((record.defaultAmount * (index + 1)) / 4).toStringAsFixed(0)}ml',
                            style: TextStyle(
                              color: selectedCupDivisionIndex == index
                                  ? Colors.black
                                  : Colors.grey,
                            ),
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
      );
    },
  );
}

/// Switch cup popup dialog
Future<dynamic> switchCup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
}) {
  int selectedIndex = provider.getSelectedCupIndex;
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => BuildDialog(
        heightPercent: 0.5,
        content: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Switch Cup',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Container(
              width: size.width,
              height: size.height * 0.35,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: GridView.count(
                physics: const AlwaysScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 20,
                children: List.generate(
                  provider.getCups.length + 1,
                  (index) => index == provider.getCups.length
                      ? InkWell(
                          onTap: () => addCustomCup(
                            context: context,
                            provider: provider,
                            size: size,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                'assets/images/cups/custom-128.png',
                                scale: 3.5,
                                color: Colors.grey,
                              ),
                              const Text('Customize')
                            ],
                          ),
                        )
                      : InkWell(
                          onTap: () => setState(() => selectedIndex = index),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                provider.getCups[index].image,
                                scale: 3.5,
                                color: selectedIndex == index
                                    ? kPrimaryColor
                                    : Colors.grey,
                              ),
                              Text(
                                '${provider.getCups[index].capacity.toStringAsFixed(0)}ml',
                              )
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
        onTapOK: () {
          provider.setSelectedCup = selectedIndex;
          Navigator.pop(context);
        },
      ),
    ),
  );
}

/// Add custom cup
Future<dynamic> addCustomCup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
}) {
  final TextEditingController controller = TextEditingController();
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => BuildDialog(
        heightPercent: 0.25,
        content: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'Customize your drinking cup',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
            ),
            Container(
              width: size.width,
              height: size.height * 0.15,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/cups/custom-128.png', scale: 3.5),
                  SizedBox(width: size.width * 0.05),
                  SizedBox(
                    width: size.width * 0.35,
                    child: TextField(
                      controller: controller,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 3,
                      decoration: const InputDecoration(counterText: ''),
                      cursorHeight: 25,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(width: size.width * 0.05),
                  const Text('ml'),
                ],
              ),
            ),
          ],
        ),
        onTapOK: () {
          provider.addCup = Cup(
              capacity: double.parse(controller.value.text),
              image: 'assets/images/cups/custom-128.png',
              selected: false);
          Navigator.pop(context);
        },
      ),
    ),
  );
}

/// Add forgotten record popup dialog
Future<dynamic> addForgottenRecordPopup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
}) {
  final List<double> waterAmounts = [for (double i = 50; i <= 1500; i += 25) i];
  double waterAmount = waterAmounts.elementAt(5);
  DateTime time = DateTime.now();
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => BuildDialog(
          heightPercent: 0.4,
          onTapOK: () {
            if (provider.getDrunkAmount + waterAmount <=
                provider.getIntakeGoalAmount) {
              provider.addDrunkAmount = DrunkAmount(
                  drunkAmount: provider.getDrunkAmount + waterAmount);
            }

            provider.addRecord(
              Record(
                image: 'assets/images/cup.png',
                time: DateFormat("h:mm a").format(time),
                defaultAmount: waterAmount,
              ),
              forgottenRecord: true,
            );
            Navigator.pop(context);
          },
          content: SizedBox(
            height: size.height * 0.35,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Add a record of drinking water in the past that you forgot to confirm',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Icon(
                            Icons.access_time,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: CupertinoTheme(
                            data: const CupertinoThemeData(
                              textTheme: CupertinoTextThemeData(
                                dateTimePickerTextStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            child: CupertinoDatePicker(
                              initialDateTime: time,
                              mode: CupertinoDatePickerMode.time,
                              use24hFormat: true,
                              onDateTimeChanged: (selectedTime) =>
                                  setState(() => time = selectedTime),
                            ),
                          ),
                        ),
                        SizedBox(width: size.width * 0.1),
                        Expanded(child: Image.asset('assets/images/cup.png')),
                        Expanded(
                          flex: 2,
                          child: CupertinoPicker(
                            itemExtent: 35,
                            onSelectedItemChanged: (selectedIndex) => setState(
                                () =>
                                    waterAmount = waterAmounts[selectedIndex]),
                            scrollController:
                                FixedExtentScrollController(initialItem: 5),
                            looping: true,
                            children: List.generate(
                              waterAmounts.length,
                              (index) => Center(
                                child: Text(
                                  waterAmounts[index].toStringAsFixed(0),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'ml',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
