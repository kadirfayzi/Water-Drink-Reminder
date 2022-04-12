import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:water_reminder/boxes.dart';
import 'package:water_reminder/models/bed_time.dart';
import 'package:water_reminder/models/chart_data.dart';
import 'package:water_reminder/models/cup.dart';
import 'package:water_reminder/models/record.dart';
import 'package:water_reminder/models/schedule_record.dart';
import 'package:water_reminder/models/wakeup_time.dart';
import 'package:water_reminder/models/week_data.dart';

import '../functions.dart';
import '../l10n/l10n.dart';

class DataProvider extends ChangeNotifier {
  /// /// /// /// /// //
  /// Reminder schedule
  /// /// /// /// /// //
  set addScheduleRecord(ScheduleRecord scheduleRecord) {
    final scheduleRecords = Boxes.getScheduleRecords();
    scheduleRecords.add(scheduleRecord);

    final List<ScheduleRecord> tempScheduleRecords = scheduleRecords.values.toList()
      ..sort((a, b) => a.time.compareTo(b.time));

    scheduleRecords.deleteAll(scheduleRecords.keys);
    scheduleRecords.addAll(tempScheduleRecords);

    notifyListeners();
  }

  editScheduleRecord(int index, ScheduleRecord scheduleRecord) {
    final scheduleRecords = Boxes.getScheduleRecords();
    scheduleRecords.putAt(index, scheduleRecord);
    notifyListeners();
  }

  set deleteScheduleRecord(int index) {
    final scheduleRecords = Boxes.getScheduleRecords();
    scheduleRecords.deleteAt(index);
    notifyListeners();
  }

  deleteAllScheduleRecords() {
    final scheduleRecords = Boxes.getScheduleRecords();
    scheduleRecords.deleteAll(scheduleRecords.keys);
    notifyListeners();
  }

  List<ScheduleRecord> get getScheduleRecords => Boxes.getScheduleRecords().values.toList();

  /// /// /// /// //
  /// Reminder sound
  /// /// /// /// //
  set setSoundValue(int soundValue) {
    final box = Boxes.getSoundValue();
    box.put('soundValue', soundValue);
    notifyListeners();
  }

  int get getSelectedSoundValue => Boxes.getSoundValue().values.first;

  /// /// /// /// /// /// /// ///
  /// Weight unit 0 = kg, 1 = lbs
  /// /// /// /// /// /// /// ///
  set setWeightUnit(int weightUnit) {
    final box = Boxes.getWeightUnit();
    box.put('weightUnit', weightUnit);
    notifyListeners();
  }

  int get getWeightUnit => Boxes.getWeightUnit().values.first;

  /// /// /// /// /// /// /// /// ///
  /// Capacity unit 0 = ml, 1 = fl oz
  /// /// /// /// /// /// /// /// ///
  set setCapacityUnit(int capacityUnit) {
    final box = Boxes.getCapacityUnit();
    box.put('capacityUnit', capacityUnit);
    notifyListeners();
  }

  int get getCapacityUnit => Boxes.getCapacityUnit().values.first;

  /// /// /// /// /// ///
  /// Intake goal amount
  /// /// /// /// /// ///
  set setIntakeGoalAmount(double intakeGoalAmount) {
    final box = Boxes.getIntakeGoalAmount();
    box.put('intakeGoalAmount', intakeGoalAmount);
    notifyListeners();
  }

  double get getIntakeGoalAmount => Boxes.getIntakeGoalAmount().values.first;

  /// /// /// ////
  /// Drank amount
  /// /// /// ////
  set addDrankAmount(double drankAmount) {
    final box = Boxes.getDrankAmount();
    box.put('drankAmount', drankAmount);
    notifyListeners();
  }

  removeAllDrunkAmount() {
    final drankAmount = Boxes.getDrankAmount();
    drankAmount.deleteAll(drankAmount.keys);
    notifyListeners();
  }

  double get getDrankAmount =>
      Boxes.getDrankAmount().isNotEmpty ? Boxes.getDrankAmount().values.first : 0.0;

  /// /// /// /// /// /// /// ////
  /// Gender 0 = male, 1 = female
  /// /// /// /// /// /// /// ////
  set setGender(int gender) {
    final box = Boxes.getGender();
    box.put('gender', gender);
    notifyListeners();
  }

  int get getGender => Boxes.getGender().values.first;

  /// /// ///
  /// Weight
  /// /// ///
  set setWeight(int weight) {
    final box = Boxes.getWeight();
    box.put('weight', weight);
    notifyListeners();
  }

  int get getWeight => getWeightUnit == 0
      ? Boxes.getWeight().values.first
      : Functions.kgToLbs(Boxes.getWeight().values.first);

  /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// ////
  /// Temporary weight for initial preferences step containers section
  /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// ////
  late int _tempWeight = getWeight;
  set setTempWeight(int weight) {
    _tempWeight = weight;
    notifyListeners();
  }

  int get getTempWeight => _tempWeight;

  /// /// /// ////
  /// Wake-up time
  /// /// /// ////
  setWakeUpTime(int hour, int minute) {
    final box = Boxes.getWakeupTime();
    box.put('wakeup', WakeupTime(wakeupHour: hour, wakeupMinute: minute));
    notifyListeners();
  }

  int get getWakeUpTimeHour => Boxes.getWakeupTime().get('wakeup')!.wakeupHour;
  int get getWakeUpTimeMinute => Boxes.getWakeupTime().get('wakeup')!.wakeupMinute;

  /// /// /// //////
  /// Bed time hour
  /// /// /// //////
  setBedTime(int hour, int minute) {
    final box = Boxes.getBedTime();
    box.put('bed', BedTime(bedHour: hour, bedMinute: minute));
    notifyListeners();
  }

  int get getBedTimeHour => Boxes.getBedTime().get('bed')!.bedHour;
  int get getBedTimeMinute => Boxes.getBedTime().get('bed')!.bedMinute;

  /// ////
  /// Cup
  /// ////
  set addCup(Cup cup) {
    final cups = Boxes.getCups();
    cups.add(cup);
    notifyListeners();
  }

  set setSelectedCup(int index) {
    final cups = Boxes.getCups();

    for (Cup cup in cups.values) {
      if (cup.selected) {
        cup.selected = false;
        cup.save();
        break;
      }
    }

    final Cup cup = cups.values.toList()[index];
    cup.selected = true;
    cup.save();

    notifyListeners();
  }

  List<Cup> get getCups => Boxes.getCups().values.toList();

  Cup get getSelectedCup => Boxes.getCups().values.firstWhere((cup) => cup.selected);
  int get getSelectedCupIndex => Boxes.getCups().values.toList().indexWhere((cup) => cup.selected);

  /// /// /// /// ///
  /// Intake records
  /// /// /// /// ///
  addRecord({required Record record, bool forgottenRecord = false}) {
    final records = Boxes.getRecords();
    if (forgottenRecord) {
      records.add(record);
      final List<Record> tempRecords = records.values.toList()
        ..sort((a, b) => a.time.compareTo(b.time));

      records.deleteAll(records.keys);
      records.addAll(tempRecords);
    } else {
      records.add(record);
    }

    notifyListeners();
  }

  editRecord({
    required dynamic recordKey,
    required double amount,
    required String time,
  }) {
    final Record? record = Boxes.getRecords().get(recordKey);
    record?.amount = amount;
    record?.time = time;
    record?.save();

    notifyListeners();
  }

  set deleteRecord(dynamic key) {
    Boxes.getRecords().delete(key);
    notifyListeners();
  }

  deleteAllRecords() {
    final records = Boxes.getRecords();
    records.deleteAll(records.keys);
    notifyListeners();
  }

  List<Record> get getRecords => Boxes.getRecords().values.toList();

  /// /// /// ///
  /// Chart Data
  /// /// /// ///
  addToChartData({
    required int day,
    required int month,
    required int year,
    required double drankAmount,
    required double intakeGoalAmount,
    required int recordCount,
    bool addMonth = false,
  }) {
    final box = Boxes.getChartData();
    final double amountPercent = ((drankAmount * 100) / intakeGoalAmount);

    if (addMonth) {
      box.add(
        ChartData(
          day: day,
          month: month,
          year: year,
          name: day.toString(),
          percent: amountPercent >= 100 ? 100 : amountPercent,
          drankAmount: drankAmount,
          recordCount: recordCount,
        ),
      );
    } else {
      final data = box.values
          .where((chartData) =>
              chartData.year == year && chartData.month == month && chartData.day == day)
          .first;
      data.drankAmount = drankAmount;
      data.percent = amountPercent >= 100 ? 100 : amountPercent;
      data.recordCount = recordCount;
      data.save();
    }

    notifyListeners();
  }

  List<ChartData> get getChartDataList => Boxes.getChartData().values.toList();

  /// /// /// ///
  /// Week data
  /// /// /// ///
  addToWeekData({
    required double drankAmount,
    required int day,
    required double intakeGoalAmount,
  }) {
    final box = Boxes.getWeekData();
    double drankAmountForPercent = drankAmount;
    if (drankAmountForPercent > intakeGoalAmount) {
      drankAmountForPercent = intakeGoalAmount;
    }
    final double amountPercent = ((drankAmountForPercent * 100) / intakeGoalAmount) / 7;
    box.put(
      'weekData$day',
      WeekData(
        drankAmount: drankAmount,
        day: day,
        percent: amountPercent,
        weekNumber: Functions.weekNumber(DateTime.now()),
      ),
    );

    notifyListeners();
  }

  removeWeekData() {
    final weekData = Boxes.getWeekData();
    weekData.deleteAll(weekData.keys);

    for (int i = 1; i <= 7; i++) {
      addToWeekData(
        drankAmount: 0,
        day: i,
        intakeGoalAmount: getIntakeGoalAmount,
      );
    }
    notifyListeners();
  }

  List<WeekData> get getWeekDataList => Boxes.getWeekData().values.toList();

  /// /// /// /// ////
  /// Next drink time
  /// /// /// /// ///
  String _nextDrinkTime = '';
  set setNextDrinkTime(String nextDrinkTime) {
    _nextDrinkTime = nextDrinkTime;
    notifyListeners();
  }

  String get getNextDrinkTime => _nextDrinkTime;

  /// /// /// /// /// //
  /// Intro Preferences
  /// /// /// /// /// //
  set setIsInitialPrefsSet(bool value) {
    final box = Boxes.getIsInitialPrefsSet();
    box.put('isInitialPrefsSet', value);
  }

  bool get getIsInitialPrefsSet => Boxes.getIsInitialPrefsSet().values.isNotEmpty
      ? Boxes.getIsInitialPrefsSet().values.first
      : false;

  /// /// /// /// ///
  /// Set/Get locale
  /// /// /// /// ///
  set setLangCode(String langCode) {
    if (!L10n.all.contains(Locale(langCode))) return;
    final box = Boxes.getLangCode();
    box.put('langCode', langCode);
    notifyListeners();
  }

  String get getLangCode => Boxes.getLangCode().values.first;

  /// /// /// /// /// /// /// /// /// /////
  /// Set/Get main state initialized value
  /// /// /// /// /// /// /// /// /// /////
  bool mainStateInitialized = false;
  set setMainStateInitialized(bool value) {
    mainStateInitialized = value;
    notifyListeners();
  }

  bool get getMainStateInitialized => mainStateInitialized;

  PackageInfo? _packageInfo;
  set setPackageInfo(PackageInfo packageInfo) {
    _packageInfo = packageInfo;
    notifyListeners();
  }

  PackageInfo? get getPackageInfo => _packageInfo;
}
