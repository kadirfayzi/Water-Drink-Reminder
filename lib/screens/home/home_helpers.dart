import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/models/cup.dart';
import 'package:water_reminder/models/record.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/widgets/build_dialog.dart';
import 'package:water_reminder/widgets/elevated_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Tips popup
Future<dynamic> tipsPopup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
}) {
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => Dismissible(
      key: const Key('key'),
      direction: DismissDirection.vertical,
      onDismissed: (_) => Navigator.pop(context),
      child: CupertinoActionSheet(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                child: const Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.transparent,
                ),
                onTap: () {},
              ),
            ),
            const Text(
              'How to drink water correctly ?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                child: Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.grey[600],
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            height: size.height * 0.7,
            child: Scaffold(
              body: Scrollbar(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: size.height * 0.7,
                    child: ListView(
                      children: List.generate(
                        tips.length,
                        (index) => ElevatedContainer(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 15,
                          ),
                          shape: BoxShape.rectangle,
                          blurRadius: 1.5,
                          child: Row(
                            children: [
                              Expanded(
                                child: Image.asset(
                                  'assets/images/1.png',
                                  scale: 5,
                                ),
                              ),
                              SizedBox(width: size.width * 0.02),
                              Expanded(
                                flex: 5,
                                child: Text(tips[index]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

/// Edit record popup dialog
Future<dynamic> editRecordPopup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
  required int recordIndex,
}) {
  int selectedCupDivisionIndex = provider.getRecords[recordIndex].cupDivisionIndex;

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
            provider.addDrunkAmount = provider.getDrunkAmount - record.dividedCapacity;
            provider.editRecord(
              recordIndex,
              Record(
                image: 'assets/images/cup.png',
                time: record.time,
                defaultAmount: record.defaultAmount,
                cupDivisionIndex: selectedCupDivisionIndex,
              ),
            );
            Navigator.pop(context);
          },
          content: Container(
            height: size.height * 0.4,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
  int selectedIndex = provider.getSelectedCupIndex;
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => Dismissible(
        key: const Key('key'),
        direction: DismissDirection.vertical,
        onDismissed: (_) => Navigator.pop(context),
        child: CupertinoActionSheet(
          title: Text(
            AppLocalizations.of(context)!.switchCup,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            Material(
              child: SizedBox(
                height: size.height * 0.5,
                child: Container(
                  width: size.width,
                  height: size.height * 0.45,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: GridView.count(
                    physics: const AlwaysScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: 15,
                    children: List.generate(
                      provider.getCups.length + 1,
                      (index) => index == provider.getCups.length
                          ? GestureDetector(
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
                                  Text(
                                    AppLocalizations.of(context)!.customize,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                  )
                                ],
                              ),
                            )
                          : GestureDetector(
                              onTap: () => setState(() => selectedIndex = index),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    provider.getCups[index].image,
                                    scale: 3.5,
                                    color: selectedIndex == index ? kPrimaryColor : Colors.grey,
                                  ),
                                  Text(
                                    '${provider.getCups[index].capacity.toStringAsFixed(0)} ml',
                                    style: TextStyle(
                                      color: selectedIndex == index ? kPrimaryColor : Colors.grey,
                                      fontSize: 15,
                                    ),
                                  )
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            )
          ],
          cancelButton: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoActionSheetAction(
                child: Text(AppLocalizations.of(context)!.save),
                onPressed: () {
                  provider.setSelectedCup = selectedIndex;
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              CupertinoActionSheetAction(
                child: Text(AppLocalizations.of(context)!.cancel),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
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
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => Dismissible(
        key: const Key('key'),
        direction: DismissDirection.vertical,
        onDismissed: (_) => Navigator.pop(context),
        child: CupertinoActionSheet(
          title: Text(
            AppLocalizations.of(context)!.customizeYourDrinkingCup,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            Material(
              child: SizedBox(
                height: size.height * 0.25,
                child: Container(
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
              ),
            )
          ],
          cancelButton: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoActionSheetAction(
                child: Text(AppLocalizations.of(context)!.save),
                onPressed: () {
                  provider.addCup = Cup(
                    capacity: double.parse(controller.value.text),
                    image: 'assets/images/cups/custom-128.png',
                    selected: false,
                  );
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              CupertinoActionSheetAction(
                child: Text(AppLocalizations.of(context)!.cancel),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
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
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => Dismissible(
        key: const Key('key'),
        direction: DismissDirection.vertical,
        onDismissed: (_) => Navigator.pop(context),
        child: CupertinoActionSheet(
          title: Text(
            AppLocalizations.of(context)!.addForgottenDrinkingRecord,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            Material(
              child: SizedBox(
                height: size.height * 0.4,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Icon(
                          Icons.access_time,
                          size: 32,
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
                      Expanded(
                        child: Image.asset(
                          'assets/images/cups/custom-128.png',
                          color: Colors.grey,
                          scale: 4,
                        ),
                      ),
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
            )
          ],
          cancelButton: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoActionSheetAction(
                child: Text(AppLocalizations.of(context)!.save),
                onPressed: () {
                  provider.addDrunkAmount = provider.getDrunkAmount + waterAmount;

                  provider.addRecord(
                    Record(
                      image: 'assets/images/cups/custom-128.png',
                      time: DateFormat("h:mm a").format(time),
                      defaultAmount: waterAmount,
                    ),
                    forgottenRecord: true,
                  );
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              CupertinoActionSheetAction(
                child: Text(AppLocalizations.of(context)!.cancel),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Clear all records
Future<dynamic> clearAllRecords({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
}) {
  final DateTime now = DateTime.now();
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => BuildDialog(
        heightPercent: 0.25,
        content: const Center(
          child: Text(
            'Are you sure you want to clear all records ?',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        onTapOK: () {
          provider.deleteAllRecords();
          provider.removeAllDrunkAmount();
          provider.addToChartData(
            day: now.day,
            month: now.month,
            year: now.year,
            drunkAmount: provider.getDrunkAmount,
            intakeGoalAmount: provider.getIntakeGoalAmount,
            recordCount: 0,
          );
          Navigator.pop(context);
        },
      ),
    ),
  );
}
