import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/functions.dart';
import 'package:water_reminder/models/cup.dart';
import 'package:water_reminder/models/record.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Tips popup
Future<dynamic> tipsPopup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
  required AppLocalizations localize,
  required List<String> localizedTips,
}) {
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => Dismissible(
      key: const Key('key'),
      direction: DismissDirection.vertical,
      onDismissed: (_) => Navigator.pop(context),
      child: CupertinoActionSheet(
        title: Text(localize.howToDrinkWaterCorrectly),
        actions: [
          SizedBox(
            height: size.height * 0.625,
            child: Material(
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: localizedTips
                      .map((tip) => Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Image.asset(
                                        'assets/images/water-glass-with-light-bulb.png',
                                        scale: 15,
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.02),
                                    Expanded(
                                      flex: 5,
                                      child: Text(tip),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 5),
                            ],
                          ))
                      .toList(),
                ),
              ),
            ),
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(localize.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    ),
  );
}

/// Edit or delete record popup dialog
Future<dynamic> editOrDeleteSelectedRecordPopup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
  required Record record,
  required AppLocalizations localize,
}) {
  DateTime now = DateTime.now();
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => Dismissible(
        key: const Key('key'),
        direction: DismissDirection.vertical,
        onDismissed: (_) => Navigator.pop(context),
        child: CupertinoActionSheet(
          title: Text(localize.editOrDeleteRecord),
          actions: [
            /// Edit
            CupertinoActionSheetAction(
              child: Text(localize.edit),
              onPressed: () => editRecordPopup(
                context: context,
                provider: provider,
                size: size,
                record: record,
                localize: localize,
              ),
            ),

            /// Delete
            CupertinoActionSheetAction(
              child: Text(
                localize.delete,
                style: const TextStyle(color: Colors.red),
              ),
              onPressed: () {
                if ((provider.getDrankAmount -
                        provider.getRecords
                            .where((record) => record.key == record.key)
                            .first
                            .amount) >=
                    0) {
                  provider.addDrankAmount = provider.getDrankAmount -
                      provider.getRecords
                          .where((_record) => _record.key == record.key)
                          .first
                          .amount;
                }

                provider.deleteRecord = record.key;

                provider.addToChartData(
                  day: now.day,
                  month: now.month,
                  year: now.year,
                  drankAmount: provider.getDrankAmount,
                  intakeGoalAmount: provider.getIntakeGoalAmount,
                  recordCount: provider.getRecords.length,
                );
                provider.addToWeekData(
                  drankAmount: provider.getDrankAmount,
                  day: now.weekday,
                  intakeGoalAmount: provider.getIntakeGoalAmount,
                );

                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(localize.cancel),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    ),
  );
}

/// Edit record popup dialog
Future<dynamic> editRecordPopup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
  required Record record,
  required AppLocalizations localize,
}) {
  final List<double> waterAmountsML = [for (double i = 50; i <= 1000; i += 25) i];
  final List<double> waterAmountsOZ = [for (double i = 1.5; i <= 36; i += 1.5) i];
  double waterAmountML = waterAmountsML.elementAt(6);
  double waterAmountOZ = waterAmountsOZ.elementAt(3);

  DateTime time = DateFormat("yyyy-MM-dd HH:mm").parse(record.time);
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => Dismissible(
        key: const Key('key'),
        direction: DismissDirection.vertical,
        onDismissed: (_) => Navigator.pop(context),
        child: CupertinoActionSheet(
          title: Text(localize.editRecord),
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
                                color: kPrimaryColor,
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
                          onSelectedItemChanged: (selectedIndex) => provider.getCapacityUnit == 0
                              ? setState(() => waterAmountML = waterAmountsML[selectedIndex])
                              : setState(() => waterAmountOZ = waterAmountsOZ[selectedIndex]),
                          scrollController: FixedExtentScrollController(
                              initialItem: provider.getCapacityUnit == 0 ? 6 : 3),
                          looping: true,
                          children: List.generate(
                            provider.getCapacityUnit == 0
                                ? waterAmountsML.length
                                : waterAmountsOZ.length,
                            (index) => Center(
                              child: Text(
                                provider.getCapacityUnit == 0
                                    ? waterAmountsML[index].toStringAsFixed(0)
                                    : waterAmountsOZ[index].toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          kCapacityUnitStrings[provider.getCapacityUnit],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CupertinoActionSheetAction(
              child: Text(localize.save),
              onPressed: () {
                final double drankLimit = kDrankLimits[provider.getCapacityUnit];
                final double drankAmount = provider.getCapacityUnit == 0
                    ? provider.getDrankAmount
                    : mlToFlOz(provider.getDrankAmount);
                if (drankAmount < drankLimit) {
                  if (provider.getCapacityUnit == 0) {
                    provider.addDrankAmount =
                        provider.getDrankAmount + waterAmountML - record.amount;
                    provider.editRecord(
                      recordKey: record.key,
                      amount: waterAmountML,
                      time: DateFormat("yyyy-MM-dd HH:mm").format(time),
                    );
                  } else {
                    final double convertedWaterAmount = flOzToMl(waterAmountOZ);
                    provider.addDrankAmount =
                        provider.getDrankAmount + convertedWaterAmount - record.amount;
                    provider.editRecord(
                      recordKey: record.key,
                      amount: convertedWaterAmount,
                      time: DateFormat("yyyy-MM-dd HH:mm").format(time),
                    );
                  }

                  provider.addToChartData(
                    day: time.day,
                    month: time.month,
                    year: time.year,
                    drankAmount: provider.getDrankAmount,
                    intakeGoalAmount: provider.getIntakeGoalAmount,
                    recordCount: provider.getRecords.length,
                  );

                  provider.addToWeekData(
                    drankAmount: provider.getDrankAmount + waterAmountML - record.amount,
                    day: time.weekday,
                    intakeGoalAmount: provider.getIntakeGoalAmount,
                  );
                }
                Navigator.of(context)
                  ..pop()
                  ..pop();
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(localize.cancel),
            onPressed: () => Navigator.of(context)
              ..pop()
              ..pop(),
          ),
        ),
      ),
    ),
  );
}

/// Switch cup popup dialog
Future<dynamic> switchCup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
  required AppLocalizations localize,
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
          title: Text(localize.switchCup),
          actions: [
            Material(
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
                        ? AnimationConfiguration.staggeredGrid(
                            position: index,
                            columnCount: 3,
                            duration: const Duration(milliseconds: 500),
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: GestureDetector(
                                  onTap: () => addCustomCup(
                                    context: context,
                                    provider: provider,
                                    size: size,
                                    localize: localize,
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
                                        localize.customize,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : AnimationConfiguration.staggeredGrid(
                            position: index,
                            columnCount: 3,
                            duration: const Duration(milliseconds: 500),
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: GestureDetector(
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
                                        '${provider.getCapacityUnit == 0 ? provider.getCups[index].capacity.toStringAsFixed(0) : mlToFlOz(provider.getCups[index].capacity).toStringAsFixed(1)} '
                                        '${kCapacityUnitStrings[provider.getCapacityUnit]}',
                                        style: TextStyle(
                                          color:
                                              selectedIndex == index ? kPrimaryColor : Colors.grey,
                                          fontSize: 15,
                                        ),
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
            ),
            CupertinoActionSheetAction(
              child: Text(localize.save),
              onPressed: () {
                provider.setSelectedCup = selectedIndex;
                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(localize.cancel),
            onPressed: () => Navigator.pop(context),
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
  required AppLocalizations localize,
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
          title: Text(localize.customizeYourDrinkingCup),
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
                      Text(kCapacityUnitStrings[provider.getCapacityUnit]),
                    ],
                  ),
                ),
              ),
            ),
            CupertinoActionSheetAction(
              child: Text(localize.save),
              onPressed: () {
                provider.addCup = Cup(
                  capacity: double.parse(controller.value.text),
                  image: 'assets/images/cups/custom-128.png',
                  selected: false,
                );
                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(localize.cancel),
            onPressed: () => Navigator.pop(context),
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
  required AppLocalizations localize,
}) {
  final List<double> waterAmountsML = [for (double i = 50; i <= 1000; i += 25) i];
  final List<double> waterAmountsOZ = [for (double i = 1.5; i <= 36; i += 1.5) i];
  double waterAmountML = waterAmountsML.elementAt(6);
  double waterAmountOZ = waterAmountsOZ.elementAt(3);

  DateTime time = DateTime.now();
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => Dismissible(
        key: const Key('key'),
        direction: DismissDirection.vertical,
        onDismissed: (_) => Navigator.pop(context),
        child: CupertinoActionSheet(
          title: Text(localize.addForgottenDrinkingRecord),
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
                                color: kPrimaryColor,
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
                          onSelectedItemChanged: (selectedIndex) => provider.getCapacityUnit == 0
                              ? setState(() => waterAmountML = waterAmountsML[selectedIndex])
                              : setState(() => waterAmountOZ = waterAmountsOZ[selectedIndex]),
                          scrollController: FixedExtentScrollController(
                              initialItem: provider.getCapacityUnit == 0 ? 6 : 3),
                          looping: true,
                          children: List.generate(
                            provider.getCapacityUnit == 0
                                ? waterAmountsML.length
                                : waterAmountsOZ.length,
                            (index) => Center(
                              child: Text(
                                provider.getCapacityUnit == 0
                                    ? waterAmountsML[index].toStringAsFixed(0)
                                    : waterAmountsOZ[index].toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          kCapacityUnitStrings[provider.getCapacityUnit],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CupertinoActionSheetAction(
              child: Text(localize.save),
              onPressed: () {
                final double drankLimit = kDrankLimits[provider.getCapacityUnit];
                final double drankAmount = provider.getCapacityUnit == 0
                    ? provider.getDrankAmount
                    : mlToFlOz(provider.getDrankAmount);

                if (drankAmount < drankLimit) {
                  if (provider.getCapacityUnit == 0) {
                    provider.addDrankAmount = provider.getDrankAmount + waterAmountML;

                    provider.addRecord(
                      record: Record(
                        image: 'assets/images/cups/custom-128.png',
                        time: DateFormat("yyyy-MM-dd HH:mm").format(time),
                        amount: waterAmountML,
                      ),
                      forgottenRecord: true,
                    );
                  } else {
                    final double convertedWaterAmount = flOzToMl(waterAmountOZ);
                    provider.addDrankAmount = provider.getDrankAmount + convertedWaterAmount;

                    provider.addRecord(
                      record: Record(
                        image: 'assets/images/cups/custom-128.png',
                        time: DateFormat("yyyy-MM-dd HH:mm").format(time),
                        amount: convertedWaterAmount,
                      ),
                      forgottenRecord: true,
                    );
                  }

                  provider.addToChartData(
                    day: time.day,
                    month: time.month,
                    year: time.year,
                    drankAmount: provider.getDrankAmount,
                    intakeGoalAmount: provider.getIntakeGoalAmount,
                    recordCount: provider.getRecords.length,
                  );

                  provider.addToWeekData(
                    drankAmount: provider.getDrankAmount,
                    day: time.weekday,
                    intakeGoalAmount: provider.getIntakeGoalAmount,
                  );
                }

                Navigator.pop(context);
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(localize.cancel),
            onPressed: () => Navigator.pop(context),
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
  required AppLocalizations localize,
}) {
  final DateTime now = DateTime.now();
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => Dismissible(
        key: const Key('key'),
        direction: DismissDirection.vertical,
        onDismissed: (_) => Navigator.pop(context),
        child: CupertinoActionSheet(
          title: Text(localize.areYouSureYouWantToClearAllRecords),
          actions: [
            CupertinoActionSheetAction(
              child: Text(
                localize.delete,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                provider.deleteAllRecords();
                provider.removeAllDrunkAmount();
                provider.addToChartData(
                  day: now.day,
                  month: now.month,
                  year: now.year,
                  drankAmount: provider.getDrankAmount,
                  intakeGoalAmount: provider.getIntakeGoalAmount,
                  recordCount: 0,
                );
                provider.addToWeekData(
                  drankAmount: provider.getDrankAmount,
                  day: now.weekday,
                  intakeGoalAmount: provider.getIntakeGoalAmount,
                );
                Navigator.pop(context);
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(localize.cancel),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    ),
  );
}
