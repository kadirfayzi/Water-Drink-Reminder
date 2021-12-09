import 'package:flutter/foundation.dart';
import 'package:water_reminder/boxes.dart';
import 'package:water_reminder/models/bed_time.dart';
import 'package:water_reminder/models/chart_data_model.dart';
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

class DataProvider extends ChangeNotifier {
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
      : Boxes.getIntakeGoal().get('intakeGoal')!.intakeGoalAmount / 29.574;

  /// Gender 0 = male, 1 = female
  set setGender(int genderValue) {
    final box = Boxes.getGender();
    box.put('gender', Gender(gender: genderValue));
    notifyListeners();
  }

  get getGender => Boxes.getGender().get('gender')!.gender;

  /// Weight
  set setWeight(int weightValue) {
    final box = Boxes.getWeight();
    box.put('weight', Weight(weight: weightValue));
    notifyListeners();
  }

  get getWeight => getWeightUnit == 0
      ? Boxes.getWeight().get('weight')!.weight
      : (Boxes.getWeight().get('weight')!.weight * 2.205).toInt();

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

    for (var cup in cups.values) {
      if (cup.selected) {
        cup.selected = false;
        cup.save();
      }
      break;
    }

    final Cup cup = cups.values.toList()[index];
    cup.selected = true;
    cup.save();

    notifyListeners();
  }

  // get getCups => getCapacityUnit == 0 ? _cupCapacity : _cupCapacity / 29.574;
  get getCups => Boxes.getCups().values.toList();
  get getSelectedCup => Boxes.getCups().values.toList().firstWhere((cup) => cup.selected == true);
  get getSelectedCupIndex =>
      Boxes.getCups().values.toList().indexWhere((cup) => cup.selected == true);

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

  get getDrunkAmount => Boxes.getDrunkAmount().get('drunkAmount')!.drunkAmount;

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
  late final List<ChartData> _monthDayChartDataList = [];

  addMonthDayChartData({
    required int day,
    required double drunkAmount,
    required double intakeGoalAmount,
  }) {
    final int amountPercent = (drunkAmount * 100) ~/ intakeGoalAmount;

    if (_monthDayChartDataList.isNotEmpty) {
      for (var monthDay in _monthDayChartDataList) {
        if (monthDay.x == day) {
          _monthDayChartDataList.insert(
            _monthDayChartDataList.indexWhere((element) => element.x == day),
            ChartData(day, amountPercent),
          );
          break;
        } else {
          _monthDayChartDataList.add(ChartData(day, amountPercent));
          break;
        }
      }
    } else {
      _monthDayChartDataList.add(ChartData(day, amountPercent));
    }

    notifyListeners();
  }

  get getMonthDayChartDataList => _monthDayChartDataList;
}
