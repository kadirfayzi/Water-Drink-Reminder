import 'dart:math';
import 'package:water_reminder/constants.dart';

/// Get and return random tip from tips list
String getRandomTip() {
  final random = Random();
  final i = random.nextInt(tips.length);
  return tips[i];
}

int kgToLbs(int kg) => (kg * 2.205).toInt().round();
int lbsToKg(int lbs) => (lbs ~/ 2.205).round();
double mlToFlOz(double ml) => (ml / 29.574).roundToDouble();
double flOzToMl(double flOz) => (flOz * 29.574).roundToDouble();
double calculateIntakeGoalAmount(int weight) => (weight * 40.0).roundToDouble();
int calculateReminderCount(int bedHour, int wakeUpHour) =>
    (bedHour - wakeUpHour) ~/ 1.5;

/// Convert hour and minutes to two digits if they are one digits
String twoDigits(int n) => n.toString().padLeft(2, "0");

/// Get month days
int monthDays() => DateTime(DateTime.now().year, DateTime.now().month + 1, 0)
    .difference(DateTime(DateTime.now().year, DateTime.now().month, 0))
    .inDays;

/// Convert String time to integer
