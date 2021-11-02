import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/models/record_model.dart';
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
  int selectedCupDivisionIndex = provider.getDrinkRecords[recordIndex].cupDivisionIndex;

  final DrinkRecord record = provider.getDrinkRecords[recordIndex];
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => BuildDialog(
          heightPercent: 0.45,
          onTapOK: () {
            provider.removeDrunkAmount = record.dividedCapacity;
            provider.editDrinkRecord(
              recordIndex,
              DrinkRecord(
                image: 'assets/images/cup.png',
                time: record.time,
                defaultAmount: record.defaultAmount,
                cupDivisionIndex: selectedCupDivisionIndex,
              ),
            );

            provider.addDrunkAmount = (record.defaultAmount * (selectedCupDivisionIndex + 1)) / 4;

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
                      onTap: () => setState(() => selectedCupDivisionIndex = index),
                      child: Column(
                        children: [
                          ElevatedContainer(
                            width: 40,
                            height: 40,
                            blurRadius: 2,
                            color: selectedCupDivisionIndex == index ? kPrimaryColor : Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                              bottomRight: Radius.circular(25),
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
                              color: selectedCupDivisionIndex == index ? Colors.black : Colors.grey,
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
  double cupCapacityValue = provider.getCupCapacity;
  int? selectedIndex;
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => BuildDialog(
        heightPercent: 0.55,
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
              height: size.height * 0.415,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: GridView.count(
                physics: const AlwaysScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 20,
                children: List.generate(
                  kCups.length,
                  (index) => InkWell(
                    onTap: () => setState(() {
                      cupCapacityValue = kCups[index].capacity;
                      selectedIndex = index;
                    }),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          kCups[index].image,
                          scale: 6,
                          color: selectedIndex == index ? null : Colors.grey,
                        ),
                        Text(
                          '${kCups[index].capacity.toStringAsFixed(0)}ml',
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
          provider.setCupCapacity = cupCapacityValue;
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
            if (provider.getDrunkAmount + waterAmount <= provider.getIntakeGoal) {
              provider.addDrunkAmount = waterAmount;
            }
            provider.addDrinkRecord(
              DrinkRecord(
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
                            onSelectedItemChanged: (selectedIndex) =>
                                setState(() => waterAmount = waterAmounts[selectedIndex]),
                            scrollController: FixedExtentScrollController(initialItem: 5),
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
