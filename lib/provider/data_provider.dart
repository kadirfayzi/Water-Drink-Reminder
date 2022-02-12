import 'package:flutter/foundation.dart';
import 'package:water_reminder/boxes.dart';
import 'package:water_reminder/models/bed_time.dart';
import 'package:water_reminder/models/chart_data.dart';
import 'package:water_reminder/models/cup.dart';
import 'package:water_reminder/models/drunk_amount.dart';
import 'package:water_reminder/models/gender.dart';
import 'package:water_reminder/models/intake_goal.dart';
import 'package:water_reminder/models/record.dart';
import 'package:water_reminder/models/schedule_record.dart';
import 'package:water_reminder/models/sound.dart';
import 'package:water_reminder/models/unit.dart';
import 'package:water_reminder/models/wakeup_time.dart';
import 'package:water_reminder/models/weight.dart';

import '../functions.dart';

class DataProvider extends ChangeNotifier {
  /// Intro Preferences
  set setIsInitialPrefsSet(bool value) {
    final box = Boxes.getIsInitialPrefsSet();
    box.put('isInitialPrefsSet', value);
  }

  get getIsInitialPrefsSet => Boxes.getIsInitialPrefsSet().values.isNotEmpty
      ? Boxes.getIsInitialPrefsSet().values.first
      : false;

  /// Reminder schedule
  set addScheduleRecord(ScheduleRecord scheduleRecord) {
    final scheduleRecords = Boxes.getScheduleRecords();
    scheduleRecords.add(scheduleRecord);
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

  get getScheduleRecords => Boxes.getScheduleRecords().values.toList();
  // get getScheduleRecords =>
  //     Boxes.getScheduleRecords().values.toList()..sort((a, b) => a.time.compareTo(b.time));

  /// Reminder sound
  set setSoundValue(int soundValue) {
    final box = Boxes.getSoundValue();
    box.put('soundValue', Sound(soundValue: soundValue));
    notifyListeners();
  }

  get getSoundValue => Boxes.getSoundValue().get('soundValue')!.soundValue;

  /// Weight unit 0 = kg, 1 = lbs
  /// Capacity unit 0 = ml, 1 = fl oz
  setUnit(int weightUnit, int capacityUnit) {
    final box = Boxes.getUnits();
    box.put('unit', Unit(weightUnit: weightUnit, capacityUnit: capacityUnit));
    notifyListeners();
  }

  get getWeightUnit => Boxes.getUnits().get('unit')!.weightUnit;
  get getCapacityUnit => Boxes.getUnits().get('unit')!.capacityUnit;

  /// Intake goal
  set setIntakeGoalAmount(double intakeGoalAmount) {
    final box = Boxes.getIntakeGoal();
    box.put('intakeGoal', IntakeGoal(intakeGoalAmount: intakeGoalAmount));
    notifyListeners();
  }

  get getIntakeGoalAmount => getCapacityUnit == 0
      ? Boxes.getIntakeGoal().get('intakeGoal')!.intakeGoalAmount
      : mlToFlOz(Boxes.getIntakeGoal().get('intakeGoal')!.intakeGoalAmount);

  /// Gender 0 = male, 1 = female
  set setGender(int genderValue) {
    final box = Boxes.getGender();
    box.put('gender', Gender(gender: genderValue));
    notifyListeners();
  }

  get getGender => Boxes.getGender().get('gender')!.gender;

  /// Weight
  set setWeight(int weight) {
    final box = Boxes.getWeight();
    box.put('weight', Weight(weight: weight));
    notifyListeners();
  }
  // setWeight(int weight, int unit) {
  //   final box = Boxes.getWeight();
  //   if (unit == 1) weight = kgToLbs(weight);
  //   box.put('weight', Weight(weight: weight));
  //   notifyListeners();
  // }

  get getWeight => getWeightUnit == 0
      ? Boxes.getWeight().get('weight')!.weight
      : kgToLbs(Boxes.getWeight().get('weight')!.weight);

  /// Wake-up time
  setWakeUpTime(int hour, int minute) {
    final box = Boxes.getWakeupTime();
    box.put('wakeup', WakeupTime(wakeupHour: hour, wakeupMinute: minute));
    notifyListeners();
  }

  get getWakeUpTimeHour => Boxes.getWakeupTime().get('wakeup')!.wakeupHour;
  get getWakeUpTimeMinute => Boxes.getWakeupTime().get('wakeup')!.wakeupMinute;

  /// Bed time hour
  setBedTime(int hour, int minute) {
    final box = Boxes.getBedTime();
    box.put('bed', BedTime(bedHour: hour, bedMinute: minute));
    notifyListeners();
  }

  get getBedTimeHour => Boxes.getBedTime().get('bed')!.bedHour;
  get getBedTimeMinute => Boxes.getBedTime().get('bed')!.bedMinute;

  /// Cup
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

    final cup = cups.values.toList()[index];
    cup.selected = true;
    cup.save();

    notifyListeners();
  }

  // get getCups => getCapacityUnit == 0 ? _cupCapacity : mlToFloz;
  get getCups => Boxes.getCups().values.toList();

  get getSelectedCup => Boxes.getCups().values.firstWhere((cup) => cup.selected);
  get getSelectedCupIndex => Boxes.getCups().values.toList().indexWhere((cup) => cup.selected);

  /// Drunk amount
  set addDrunkAmount(DrunkAmount drunkAmount) {
    final box = Boxes.getDrunkAmount();
    if (getDrunkAmount + getSelectedCup.capacity <= getIntakeGoalAmount) {
      box.put('drunkAmount', drunkAmount);
    }
    notifyListeners();
  }

  set removeDrunkAmount(DrunkAmount drunkAmount) {
    final box = Boxes.getDrunkAmount();
    box.put('drunkAmount', drunkAmount);
    notifyListeners();
  }

  // set removeDrunkAmount(double drunkAmount) {
  //   final box=Boxes.getDrunkAmount();
  //   if ((box.values.toList().cast<DrunkAmount>().first.drunkAmount - drunkAmount) >= 0) {
  //     _drunkAmount -= drunkAmount;
  //   }
  //   notifyListeners();
  // }

  get getDrunkAmount => Boxes.getDrunkAmount().isNotEmpty
      ? Boxes.getDrunkAmount().get('drunkAmount')!.drunkAmount
      : 0.0;

  /// Records with hive

  addRecord(Record record, {bool forgottenRecord = false}) {
    final records = Boxes.getRecords();
    forgottenRecord ? records.putAt(0, record) : records.add(record);
    notifyListeners();
  }

  editRecord(int index, Record record) {
    final records = Boxes.getRecords();
    records.putAt(index, record);
    notifyListeners();
  }

  set deleteRecord(int index) {
    final records = Boxes.getRecords();
    records.deleteAt(index);
    notifyListeners();
  }

  get getRecords => Boxes.getRecords().values.toList();

  /// Chart Data
  addMonthDayChartData({
    required int day,
    required double drunkAmount,
    required double intakeGoalAmount,
  }) {
    // final double amountPercent =
    //     ((drunkAmount * 100) ~/ intakeGoalAmount) as double;
    final double amountPercent = ((drunkAmount * 100) / intakeGoalAmount);

    final box = Boxes.getChartData();
    final DateTime now = DateTime.now();

    // if (box.values.isNotEmpty) {
    //   for (var monthDay in box.values) {
    //     if (monthDay.x == day) {
    //       box.put(day, ChartData(x: day, y: amountPercent));
    //     }
    //     break;
    //   }
    // } else {
    //   box.put(day, ChartData(x: day, y: amountPercent));
    // }

    // box.put(day, ChartData(x: day, y: amountPercent));
    /// ///
    box.put(
        now.year + now.month + day,
        ChartData(
          day: day - 1,
          month: now.month,
          year: now.year,
          name: day.toString(),
          percent: amountPercent,
        ));

    notifyListeners();
  }

  get getMonthDayChartDataList => Boxes.getChartData().values.toList();
}
