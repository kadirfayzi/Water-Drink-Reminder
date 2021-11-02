import 'package:flutter/material.dart';
import 'package:water_reminder/models/record_model.dart';

class DataProvider extends ChangeNotifier {
  /// Reminder Mode
  late int _reminderMode = 0;
  set setReminderMode(int mode) {
    _reminderMode = mode;
    notifyListeners();
  }

  get getReminderMode => _reminderMode;

  /// Weight unit
  late bool _weightUnit = false;
  set setWeightUnit(bool weightUnit) {
    _weightUnit = weightUnit;
    notifyListeners();
  }

  get getWeightUnit => _weightUnit;

  /// Capacity unit
  late bool _capacityUnit = false;

  set setCapacityUnit(bool capacityUnit) {
    _capacityUnit = capacityUnit;
    notifyListeners();
  }

  get getCapacityUnit => _capacityUnit;

  /// Intake goal
  late double _intakeGoal = 2030;
  set setIntakeGoal(double intakeGoal) {
    _intakeGoal = intakeGoal;
    notifyListeners();
  }

  get getIntakeGoal => _intakeGoal;

  /// Gender
  late bool _gender = false;
  set setGender(bool gender) {
    _gender = gender;
    notifyListeners();
  }

  get getGender => _gender;

  /// Weight
  late int _weight = 65;
  set setWeight(int weight) {
    _weight = weight;
    notifyListeners();
  }

  get getWeight => _weight;

  /// Wake-up time hour
  late int _wakeUpTimeHour = 8;

  set setWakeUpTimeHour(int hour) {
    _wakeUpTimeHour = hour;
    notifyListeners();
  }

  get getWakeUpTimeHour => _wakeUpTimeHour;

  /// Wake-up time minute
  late int _wakeUpTimeMinute = 0;

  set setWakeUpTimeMinute(int minute) {
    _wakeUpTimeMinute = minute;
    notifyListeners();
  }

  get getWakeUpTimeMinute => _wakeUpTimeMinute;

  /// Bed time hour
  late int _bedTimeHour = 1;

  set setBedTimeHour(int hour) {
    _bedTimeHour = hour;
    notifyListeners();
  }

  get getBedTimeHour => _bedTimeHour;

  /// Wake-up time minute
  late int _bedTimeMinute = 0;

  set setBedTimeMinute(int minute) {
    _bedTimeMinute = minute;
    notifyListeners();
  }

  get getBedTimeMinute => _bedTimeMinute;

  /// Hide tips
  late bool _hideTips = false;

  set setHideTips(bool hideTips) {
    _hideTips = hideTips;
    notifyListeners();
  }

  get getHideTips => _hideTips;

  /// Cup
  late double _cupCapacity = 175;

  set setCupCapacity(double capacity) {
    _cupCapacity = capacity;
    notifyListeners();
  }

  get getCupCapacity => _cupCapacity;

  /// Drunk amount
  late double _drunkAmount = 0;

  set addDrunkAmount(double drunkAmount) {
    _drunkAmount += drunkAmount;
    notifyListeners();
  }

  set removeDrunkAmount(double drunkAmount) {
    if ((_drunkAmount - drunkAmount) >= 0) {
      _drunkAmount -= drunkAmount;
    }
    notifyListeners();
  }

  get getDrunkAmount => _drunkAmount;

  /// Records

  late final List<DrinkRecord> _drinkRecords = [];

  addDrinkRecord(DrinkRecord drinkRecord, {bool forgottenRecord = false}) {
    forgottenRecord ? _drinkRecords.insert(0, drinkRecord) : _drinkRecords.add(drinkRecord);
    notifyListeners();
  }

  editDrinkRecord(int index, DrinkRecord drinkRecord) {
    _drinkRecords[index] = drinkRecord;
    notifyListeners();
  }

  set deleteDrinkRecord(int drinkRecordIndex) {
    _drinkRecords.removeAt(drinkRecordIndex);
    notifyListeners();
  }

  get getDrinkRecords => _drinkRecords;
}
