import 'dart:math';
import 'package:water_reminder/constants.dart';
import 'models/chart_data.dart';
import 'models/schedule_record.dart';

final DateTime _now = DateTime.now();

/// Convert 24 hour string to datetime object
convertStringToTime({
  required int hour,
  required int minute,
  required DateTime now,
}) =>
    DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

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
int calculateReminderCount({required int bedHour, required int wakeUpHour}) =>
    (bedHour - wakeUpHour) ~/ 1.5;

List<DateTime> dtScheduleRecords({required List<ScheduleRecord> scheduleRecords}) {
  if (scheduleRecords.isNotEmpty) {
    return List.generate(
        scheduleRecords.length,
        (index) => convertStringToTime(
              hour: int.parse(scheduleRecords[index].time.split(':')[0]),
              minute: int.parse(scheduleRecords[index].time.split(':')[1]),
              now: _now,
            ));
  }
  return List<DateTime>.empty();
}

String calculateNextDrinkTime({required List<ScheduleRecord> scheduleRecords}) {
  final _dtScheduleRecords = dtScheduleRecords(scheduleRecords: scheduleRecords);

  for (int i = 0; i < _dtScheduleRecords.length; i++) {
    if (_dtScheduleRecords.isNotEmpty && i + 1 != _dtScheduleRecords.length) {
      if (_now.compareTo(_dtScheduleRecords[i]) > 0 &&
          _now.compareTo(_dtScheduleRecords[i + 1]) < 0) {
        return scheduleRecords[i + 1].time;
      } else if (_now.compareTo(_dtScheduleRecords.last) > 0) {
        return scheduleRecords.firstWhere((scheduleRecord) => scheduleRecord.isSet).time;
      }
    }
  }

  return '';
}

int calculateMonthlyAverage({
  required List<ChartData> monthDayChartDataList,
  required double intakeGoalAmount,
}) {
  List<double> monthDayDataList = [];
  double monthlyAverage = 0.0;
  for (int i = 0; i < monthDayChartDataList.length; i++) {
    if (_now.year == monthDayChartDataList[i].year &&
        _now.month == monthDayChartDataList[i].month) {
      monthDayDataList.add(monthDayChartDataList[i].drunkAmount);
    }
  }

  monthlyAverage =
      monthDayDataList.fold(0, (avg, element) => avg + element / monthDayChartDataList.length);
  return monthlyAverage.toInt();
}

/// Convert hour and minutes to two digits if they are one digits
String twoDigits(int n) => n.toString().padLeft(2, '0');

/// Get month days
int monthDays() =>
    DateTime(_now.year, _now.month + 1, 0).difference(DateTime(_now.year, _now.month, 0)).inDays;
