import 'dart:math';
import 'package:intl/intl.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'models/chart_data.dart';
import 'models/record.dart';
import 'models/schedule_record.dart';

DateTime stringToDate({required String dateString}) => DateFormat("yyyy-MM-dd").parse(dateString);
DateTime stringToTime({required String timeString}) => DateFormat("hh:mm").parse(timeString);

/// Get and return random tip from tips list
String getRandomTip() => tips[Random().nextInt(tips.length)];

int kgToLbs(int kg) => (kg * 2.205).toInt().round();
int lbsToKg(int lbs) => (lbs ~/ 2.205).round();
double mlToFlOz(double ml) => (ml / 29.574).roundToDouble();
double flOzToMl(double flOz) => (flOz * 29.574).roundToDouble();
double calculateIntakeGoalAmount(int weight) => (weight * 40.0).roundToDouble();
int calculateReminderCount({required int bedHour, required int wakeUpHour}) =>
    (bedHour - wakeUpHour) ~/ 1.5;

/// Convert 24 hour string to datetime object
DateTime convertStringToDateTime({
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

/// Get selected month chart data
List<ChartData> selectedMonthChartData({
  required List<ChartData> chartDataList,
  required List<int> selectedDate,
}) =>
    chartDataList
        .where((element) => element.year == selectedDate[0] && element.month == selectedDate[1])
        .toList();

/// Remove all records if day changes
removeAllRecordsIfDayChanges({required DataProvider provider}) {
  final List<Record> _records = provider.getRecords;
  final List<ScheduleRecord> _scheduleRecords = provider.getScheduleRecords;
  final DateTime now = DateTime.now();
  DateTime date(DateTime dateTime) => DateTime(dateTime.day);

  if (_scheduleRecords.isNotEmpty && _records.isNotEmpty) {
    final DateTime lastScheduleRecordTime = stringToTime(
      timeString: _scheduleRecords.last.time,
    );

    if (date(now)
                .difference(date(stringToDate(dateString: _records.first.time.split(' ')[0])))
                .inDays >
            0 &&
        now.isAfter(lastScheduleRecordTime)) {
      provider.deleteAllRecords();
      provider.removeAllDrunkAmount();
    }
  }
}

//TODO:not completed
/// Reset monthly chart data if month changes
resetMonthlyChartDataIfMonthChanges({required DataProvider provider}) {
  if (provider.getChartDataList.isNotEmpty) {
    final DateTime now = DateTime.now();
    final ChartData last = provider.getChartDataList.last;
    final DateTime lastDate = DateTime.utc(last.year, last.month, last.day);

    if (now.compareTo(lastDate) > 0) {
      int currentMonthDaysCount = getCurrentMonthDaysCount(now: now);
      for (int i = 1; i <= currentMonthDaysCount; i++) {
        provider.addToChartData(
          day: i,
          month: now.month,
          year: now.year,
          drunkAmount: 0,
          intakeGoalAmount: 2800,
          recordCount: 0,
        );
      }
    }
  }
}

/// Schedule records to date time list
List<DateTime> dtScheduleRecords({required List<ScheduleRecord> scheduleRecords}) {
  final DateTime now = DateTime.now();
  if (scheduleRecords.isNotEmpty) {
    return List.generate(
        scheduleRecords.length,
        (index) => convertStringToDateTime(
              hour: int.parse(scheduleRecords[index].time.split(':')[0]),
              minute: int.parse(scheduleRecords[index].time.split(':')[1]),
              now: now,
            )).toList();
  }
  return List<DateTime>.empty();
}

/// Calculate next drink time
String calculateNextDrinkTime({required List<ScheduleRecord> scheduleRecords}) {
  final _dtScheduleRecords = dtScheduleRecords(scheduleRecords: scheduleRecords);
  final now = DateTime.now();

  for (int i = 0; i < _dtScheduleRecords.length; i++) {
    if (_dtScheduleRecords.isNotEmpty && i + 1 != _dtScheduleRecords.length) {
      if (now.compareTo(_dtScheduleRecords[i]) > 0 &&
          now.compareTo(_dtScheduleRecords[i + 1]) < 0) {
        return scheduleRecords[i + 1].time;
      } else if (now.compareTo(_dtScheduleRecords.last) > 0) {
        return scheduleRecords.firstWhere((scheduleRecord) => scheduleRecord.isSet).time;
      }
    }
  }

  return '';
}

/// Monthly drink average
int monthlyDrinkAverage({
  required List<ChartData> chartDataList,
  required int month,
  required int year,
}) {
  List<double> drunkAmountList = [];
  double monthlyAverage = 0.0;
  final List<ChartData> selectedMonthChartData =
      chartDataList.where((element) => element.year == year && element.month == month).toList();

  for (var data in selectedMonthChartData) {
    drunkAmountList.add(data.drunkAmount);
  }

  if (drunkAmountList.any((element) => element > 0)) {
    monthlyAverage = drunkAmountList.fold(
        0,
        (avg, element) =>
            avg + element / drunkAmountList.where((drunkAmount) => drunkAmount != 0).length);
  }

  return monthlyAverage.toInt();
}

/// Monthly drink percent
double monthOfYearChartData({
  required List<ChartData> chartDataList,
  required int month,
  required int year,
  required double intakeGoalAmount,
}) {
  final List<ChartData> selectedMonthChartData =
      chartDataList.where((element) => element.year == year && element.month == month).toList();
  double monthlyDrunkAmount = 0.0;
  double monthlyPercent = 0.0;

  for (var data in selectedMonthChartData) {
    monthlyDrunkAmount += data.drunkAmount;
  }

  if (monthlyDrunkAmount != 0) {
    int monthDaysCount = getMonthDaysCount(year: year, month: month);
    if (monthlyDrunkAmount > intakeGoalAmount) monthlyDrunkAmount = intakeGoalAmount;
    monthlyPercent = (monthlyDrunkAmount / (monthDaysCount * intakeGoalAmount)) * 100;
  }

  return monthlyPercent;
}

/// Drink frequency
int drinkFrequency({required List<ChartData> chartDataList}) {
  final DateTime now = DateTime.now();
  List<int> recordCountList = [];
  double frequency = 0;

  final List<ChartData> selectedMonthChartData = chartDataList
      .where((element) => element.year == now.year && element.month == now.month)
      .toList();
  for (var data in selectedMonthChartData) {
    recordCountList.add(data.recordCount);
  }

  if (recordCountList.any((element) => element > 0)) {
    frequency = recordCountList.fold(
        0,
        (avg, element) =>
            avg + element / recordCountList.where((recordCount) => recordCount != 0).length);
  }

  return frequency.toInt();
}

/// Average completion
int averageCompletion({required List<ChartData> chartDataList}) {
  final DateTime now = DateTime.now();
  List<double> drunkAmountPercentList = [];
  double averageCompletion = 0;

  final List<ChartData> selectedMonthChartData = chartDataList
      .where((element) => element.year == now.year && element.month == now.month)
      .toList();
  for (var data in selectedMonthChartData) {
    drunkAmountPercentList.add(data.percent);
  }

  if (drunkAmountPercentList.any((element) => element > 0)) {
    averageCompletion = drunkAmountPercentList.fold(
        0,
        (avg, element) =>
            avg +
            element /
                drunkAmountPercentList
                    .where((drunkAmountPercent) => drunkAmountPercent != 0)
                    .length);
  }
  return averageCompletion.toInt();
}

/// Convert hour and minutes to two digits if they are one digits
String twoDigits(int n) => n.toString().padLeft(2, '0');

/// Get current month days count
int getCurrentMonthDaysCount({required DateTime now}) =>
    DateTime(now.year, now.month + 1, 0).difference(DateTime(now.year, now.month, 0)).inDays;

/// Get specific month days count
int getMonthDaysCount({required int year, required int month}) =>
    DateTime(year, month + 1, 0).difference(DateTime(year, month, 0)).inDays;
