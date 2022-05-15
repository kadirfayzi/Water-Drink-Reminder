import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/functions.dart';
import 'package:water_reminder/models/cup.dart';
import 'package:water_reminder/models/record.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Tips popup
Future<dynamic> tipsPopup({
  required BuildContext context,
  required AppLocalizations localize,
  required Size size,
  required List<String> localizedTips,
}) {
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => Dismissible(
      key: const Key('key'),
      direction: DismissDirection.vertical,
      onDismissed: (_) => Navigator.pop(context),
      child: CupertinoActionSheet(
        title: Text(
          localize.howToDrinkWaterCorrectly,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          SizedBox(
            height: 500,
            child: Material(
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: localizedTips
                      .map((tip) => Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 15,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(Icons.water_drop_outlined, color: Colors.grey),
                                    SizedBox(width: size.width * 0.8, child: Text(tip)),
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
  required Record record,
}) {
  final localize = AppLocalizations.of(context)!;
  DateTime now = DateTime.now();
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => Dismissible(
        key: const Key('key'),
        direction: DismissDirection.vertical,
        onDismissed: (_) => Navigator.pop(context),
        child: Consumer<DataProvider>(
          builder: (context, provider, _) {
            return CupertinoActionSheet(
              title: Text(
                localize.editOrDeleteRecord,
                style: const TextStyle(color: Colors.black),
              ),
              actions: [
                /// Edit record
                CupertinoActionSheetAction(
                  child: Text(localize.edit),
                  onPressed: () => provider.getCapacityUnit == 0
                      ? editRecordPopupML(
                          context: context,
                          record: record,
                          localize: localize,
                        )
                      : editRecordPopupFLOZ(
                          context: context,
                          record: record,
                          localize: localize,
                        ),
                ),

                /// Delete record
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
                          provider.getRecords.where((item) => item.key == record.key).first.amount;
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
            );
          },
        ),
      ),
    ),
  );
}

/// Edit record popup dialog ml
Future<dynamic> editRecordPopupML({
  required BuildContext context,
  required Record record,
  required AppLocalizations localize,
}) {
  final size = MediaQuery.of(context).size;
  final List<double> waterAmounts = [for (double i = 0; i <= 1500; i++) i];
  double waterAmount = record.amount;

  DateTime time = DateFormat("yyyy-MM-dd HH:mm").parse(record.time);

  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => Dismissible(
        key: const Key('key'),
        direction: DismissDirection.vertical,
        onDismissed: (_) => Navigator.pop(context),
        child: CupertinoActionSheet(
          title: Text(
            localize.editRecord,
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            Material(
              child: SizedBox(
                height: 300,
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
                        child: CupertinoPicker.builder(
                          childCount: waterAmounts.length,
                          itemExtent: 35,
                          onSelectedItemChanged: (selectedIndex) =>
                              setState(() => waterAmount = waterAmounts[selectedIndex]),
                          scrollController: FixedExtentScrollController(
                            initialItem:
                                waterAmounts.indexWhere((amount) => amount == record.amount),
                          ),
                          // looping: true,
                          itemBuilder: (BuildContext context, int index) => Center(
                            child: Text(
                              index.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          kCapacityUnitStrings[0],
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
                final provider = Provider.of<DataProvider>(context, listen: false);
                final double drankLimit = kDrankLimits[0];
                final double drankAmount = provider.getDrankAmount;
                if (drankAmount < drankLimit) {
                  provider.addDrankAmount = provider.getDrankAmount + waterAmount - record.amount;
                  provider.editRecord(
                    recordKey: record.key,
                    amount: waterAmount,
                    time: DateFormat("yyyy-MM-dd HH:mm").format(time),
                  );

                  provider.addToChartData(
                    day: time.day,
                    month: time.month,
                    year: time.year,
                    drankAmount: provider.getDrankAmount,
                    intakeGoalAmount: provider.getIntakeGoalAmount,
                    recordCount: provider.getRecords.length,
                  );

                  provider.addToWeekData(
                    drankAmount: provider.getDrankAmount + waterAmount - record.amount,
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

/// Edit record popup dialog fl-oz
Future<dynamic> editRecordPopupFLOZ({
  required BuildContext context,
  required Record record,
  required AppLocalizations localize,
}) {
  final size = MediaQuery.of(context).size;

  List<double> waterAmounts = [for (double i = 0; i <= 50; i += 0.1) i];
  double waterAmount = double.parse(Functions.mlToFlOz(record.amount).toStringAsFixed(1));
  DateTime time = DateFormat("yyyy-MM-dd HH:mm").parse(record.time);

  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => Dismissible(
        key: const Key('key'),
        direction: DismissDirection.vertical,
        onDismissed: (_) => Navigator.pop(context),
        child: CupertinoActionSheet(
          title: Text(
            localize.editRecord,
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            Material(
              child: SizedBox(
                height: 300,
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
                        child: CupertinoPicker.builder(
                          childCount: waterAmounts.length,
                          itemExtent: 35,
                          onSelectedItemChanged: (selectedIndex) =>
                              setState(() => waterAmount = waterAmounts[selectedIndex]),
                          scrollController: FixedExtentScrollController(
                            initialItem: waterAmounts.indexWhere((amount) =>
                                amount.toStringAsFixed(1) ==
                                Functions.mlToFlOz(record.amount).toStringAsFixed(1)),
                          ),
                          // looping: true,
                          itemBuilder: (context, index) => Center(
                            child: Text(
                              waterAmounts[index].toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 20,
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          kCapacityUnitStrings[1],
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
                final provider = Provider.of<DataProvider>(context, listen: false);
                final double drankLimit = kDrankLimits[1];
                final double drankAmount =
                    double.parse(Functions.mlToFlOz(provider.getDrankAmount).toStringAsFixed(0));

                if (drankAmount < drankLimit) {
                  final double convertedWaterAmount =
                      double.parse(Functions.flOzToMl(waterAmount).toStringAsFixed(0));

                  provider.addDrankAmount =
                      provider.getDrankAmount + convertedWaterAmount - record.amount;
                  provider.editRecord(
                    recordKey: record.key,
                    amount: convertedWaterAmount,
                    time: DateFormat("yyyy-MM-dd HH:mm").format(time),
                  );

                  provider.addToChartData(
                    day: time.day,
                    month: time.month,
                    year: time.year,
                    drankAmount: provider.getDrankAmount,
                    intakeGoalAmount: provider.getIntakeGoalAmount,
                    recordCount: provider.getRecords.length,
                  );

                  provider.addToWeekData(
                    drankAmount: provider.getDrankAmount + waterAmount - record.amount,
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
Future<dynamic> switchCupPopup({
  required BuildContext context,
  required Size size,
  required AppLocalizations localize,
}) {
  int selectedIndex = Provider.of<DataProvider>(context, listen: false).getSelectedCupIndex;

  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => Dismissible(
        key: const Key('key'),
        direction: DismissDirection.vertical,
        onDismissed: (_) => Navigator.pop(context),
        child: Consumer<DataProvider>(
          builder: (context, provider, _) => CupertinoActionSheet(
            title: Text(
              localize.switchCup,
              style: const TextStyle(color: Colors.black),
            ),
            actions: [
              Material(
                child: Container(
                  width: size.width,
                  height: size.height * 0.45,
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                  child: GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: provider.getCups.length + 1,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 15,
                    ),
                    itemBuilder: (BuildContext context, int index) => index ==
                            provider.getCups.length
                        ? GestureDetector(
                            onTap: () => addCustomCupPopup(
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
                                    color: Colors.black,
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
                                  '${provider.getCapacityUnit == 0 ? provider.getCups[index].capacity.toStringAsFixed(0) : Functions.mlToFlOz(provider.getCups[index].capacity).toStringAsFixed(1)} '
                                  '${kCapacityUnitStrings[provider.getCapacityUnit]}',
                                  style: TextStyle(
                                    color: selectedIndex == index ? kPrimaryColor : Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),

              /// Save selected cup
              CupertinoActionSheetAction(
                child: Text(localize.save),
                onPressed: () {
                  provider.setSelectedCup = selectedIndex;
                  Navigator.pop(context);
                },
              ),

              /// Delete selected cup
              Visibility(
                visible: provider.getCups[selectedIndex].removable ? true : false,
                child: CupertinoActionSheetAction(
                  child: Text(
                    localize.delete,
                    style: const TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    provider.setSelectedCup = selectedIndex - 1;
                    provider.deleteCup = provider.getCups[selectedIndex].key;
                    setState(() => selectedIndex -= 1);
                  },
                ),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(localize.cancel),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Add custom cup
Future<dynamic> addCustomCupPopup({
  required BuildContext context,
  required DataProvider provider,
  required Size size,
  required AppLocalizations localize,
}) {
  final List<double> waterAmountsML = [for (double i = 0; i <= 1500; i++) i];
  final List<double> waterAmountsOZ = [for (double i = 0; i <= 50; i += 0.1) i];
  double waterAmountML = waterAmountsML.elementAt(200);
  double waterAmountOZ = waterAmountsOZ.elementAt(70);
  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => Dismissible(
        key: const Key('key'),
        direction: DismissDirection.vertical,
        onDismissed: (_) => Navigator.pop(context),
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: CupertinoActionSheet(
            title: Text(
              localize.customizeYourDrinkingCup,
              style: const TextStyle(color: Colors.black),
            ),
            actions: [
              Material(
                child: Container(
                  width: size.width,
                  height: size.height * 0.3,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/cups/custom-128.png', scale: 3.5),
                      SizedBox(width: size.width * 0.05),
                      SizedBox(
                        width: size.width * 0.35,
                        child: CupertinoPicker.builder(
                          itemExtent: 35,
                          onSelectedItemChanged: (selectedIndex) => provider.getCapacityUnit == 0
                              ? setState(() => waterAmountML = waterAmountsML[selectedIndex])
                              : setState(() => waterAmountOZ = waterAmountsOZ[selectedIndex]),
                          scrollController: FixedExtentScrollController(
                              initialItem: provider.getCapacityUnit == 0 ? 200 : 70),
                          childCount: provider.getCapacityUnit == 0
                              ? waterAmountsML.length
                              : waterAmountsOZ.length,
                          itemBuilder: (context, index) => Center(
                            child: Text(
                              provider.getCapacityUnit == 0
                                  ? waterAmountsML[index].toStringAsFixed(0)
                                  : waterAmountsOZ[index].toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 25,
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * 0.05),
                      Text(kCapacityUnitStrings[provider.getCapacityUnit]),
                    ],
                  ),
                ),
              ),
              CupertinoActionSheetAction(
                child: Text(localize.save),
                onPressed: () {
                  provider.addCup = Cup(
                    capacity: provider.getCapacityUnit == 0
                        ? waterAmountML
                        : double.parse(Functions.flOzToMl(waterAmountOZ).toStringAsFixed(0)),
                    image: 'assets/images/cups/custom-128.png',
                    selected: false,
                    removable: true,
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
    ),
  );
}

/// Add forgotten record popup dialog
Future<dynamic> addForgottenRecordPopup({
  required BuildContext context,
  required Size size,
  required AppLocalizations localize,
}) {
  final List<double> waterAmountsML = [for (double i = 0; i <= 1500; i++) i];
  final List<double> waterAmountsOZ = [for (double i = 0; i <= 50; i += 0.1) i];
  double waterAmountML = waterAmountsML.elementAt(200);
  double waterAmountOZ = waterAmountsOZ.elementAt(70);

  DateTime time = DateTime.now();

  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => Dismissible(
        key: const Key('key'),
        direction: DismissDirection.vertical,
        onDismissed: (_) => Navigator.pop(context),
        child: Consumer<DataProvider>(
          builder: (context, provider, _) => CupertinoActionSheet(
            title: Text(
              localize.addForgottenDrinkingRecord,
              style: const TextStyle(color: Colors.black),
            ),
            actions: [
              Material(
                child: SizedBox(
                  height: 300,
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
                          child: CupertinoPicker.builder(
                            itemExtent: 35,
                            onSelectedItemChanged: (selectedIndex) => provider.getCapacityUnit == 0
                                ? setState(() => waterAmountML = waterAmountsML[selectedIndex])
                                : setState(() => waterAmountOZ = waterAmountsOZ[selectedIndex]),
                            scrollController: FixedExtentScrollController(
                                initialItem: provider.getCapacityUnit == 0 ? 200 : 70),
                            childCount: provider.getCapacityUnit == 0
                                ? waterAmountsML.length
                                : waterAmountsOZ.length,
                            itemBuilder: (context, index) => Center(
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
                        Expanded(
                          child: Text(
                            kCapacityUnitStrings[provider.getCapacityUnit],
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
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
                      : Functions.mlToFlOz(provider.getDrankAmount);

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
                      final double convertedWaterAmount = Functions.flOzToMl(waterAmountOZ);
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
    ),
  );
}

/// Clear all records
Future<dynamic> clearAllRecordsPopup({required BuildContext context}) {
  final localize = AppLocalizations.of(context)!;
  final DateTime now = DateTime.now();

  return showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) => Dismissible(
        key: const Key('key'),
        direction: DismissDirection.vertical,
        onDismissed: (_) => Navigator.pop(context),
        child: Consumer<DataProvider>(builder: (context, provider, _) {
          return CupertinoActionSheet(
            title: Text(
              localize.areYouSureYouWantToClearAllRecords,
              style: const TextStyle(color: Colors.black),
            ),
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
          );
        }),
      ),
    ),
  );
}
