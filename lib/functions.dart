import 'package:intl/intl.dart';
import 'package:water_reminder/models/week_data.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'models/chart_data.dart';
import 'models/schedule_record.dart';

DateTime stringToDate({required String dateString}) => DateFormat("yyyy-MM-dd").parse(dateString);
DateTime stringToTime({required String timeString}) => DateFormat("hh:mm").parse(timeString);
DateTime date(DateTime dateTime) => DateTime(dateTime.day);

int kgToLbs(int kg) => (kg * 2.205).toInt().round();
int lbsToKg(int lbs) => (lbs ~/ 2.205).toInt().round();
double mlToFlOz(double ml) => (ml / 29.574);
double flOzToMl(double flOz) => (flOz * 29.574);
double calculateIntakeGoalAmount(int weight) => (weight * 40).roundToDouble();

int calculateReminderCount({
  required int bedHour,
  required int wakeUpHour,
}) =>
    (bedHour - wakeUpHour) ~/ 1.5;

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
  final DateTime now = DateTime.now();
  if (provider.getRecords.isNotEmpty) {
    if (date(now)
            .difference(
                date(stringToDate(dateString: provider.getRecords.first.time.split(' ')[0])))
            .inDays >
        0) {
      provider.deleteAllRecords();
      provider.removeAllDrunkAmount();
    }
  }
}

//TODO: what if user not uses app in the weekend ?
/// Remove week data if week changes
removeWeekDataIfWeekChanges({required DataProvider provider}) {
  final DateTime now = DateTime.now();

  if (provider.getWeekDataList.isNotEmpty) {
    if (now.difference(provider.getAppLastUseDateTime).inDays >= 7) {
      provider.removeWeekData();
    } else {
      //TODO: what if records empty
      if (provider.getRecords.isNotEmpty) {
        if (now.weekday == 7 &&
            date(now)
                    .difference(date(
                        stringToDate(dateString: provider.getRecords.first.time.split(' ')[0])))
                    .inDays >
                0) {
          provider.removeWeekData();
        }
      }
    }
  }
}

//TODO:test it
/// Reset monthly chart data if month changes
resetMonthlyChartDataIfMonthChanges({required DataProvider provider}) {
  final DateTime now = DateTime.now();
  final ChartData last = provider.getChartDataList.last;

  if (now.month != last.month) {
    int currentMonthDaysCount = getCurrentMonthDaysCount(now: now);
    for (int i = 1; i <= currentMonthDaysCount; i++) {
      provider.addToChartData(
        day: i,
        month: now.month,
        year: now.year,
        drankAmount: 0,
        intakeGoalAmount: provider.getIntakeGoalAmount,
        recordCount: 0,
      );
    }
  }
}

/// Schedule records to date time list
List<DateTime> dtScheduleRecords({
  required List<ScheduleRecord> scheduleRecords,
  required DateTime now,
}) {
  return List.generate(
    scheduleRecords.length,
    (index) => DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(scheduleRecords[index].time.split(':')[0]),
      int.parse(scheduleRecords[index].time.split(':')[1]),
    ),
  ).toList();
}

/// Calculate next drink time
String calculateNextDrinkTime({required List<ScheduleRecord> scheduleRecords}) {
  if (scheduleRecords.isNotEmpty) {
    final DateTime now = DateTime.now();

    final List<DateTime> _dtScheduleRecords = dtScheduleRecords(
      scheduleRecords: scheduleRecords,
      now: now,
    );

    for (int i = 0; i < _dtScheduleRecords.length; i++) {
      if (i + 1 != _dtScheduleRecords.length) {
        if (now.compareTo(_dtScheduleRecords[i]) > 0 &&
            now.compareTo(_dtScheduleRecords[i + 1]) < 0) {
          return scheduleRecords[i + 1].time;
        }
      } else if (i == _dtScheduleRecords.length - 1) {
        return scheduleRecords.first.time;
      }
    }
  }
  return '--:--';
}

/// Monthly drink average
double monthlyDrinkAverage({
  required List<ChartData> chartDataList,
  required int month,
  required int year,
}) {
  List<double> drankAmountList = [];
  double monthlyAverage = 0.0;
  final List<ChartData> selectedMonthChartData =
      chartDataList.where((element) => element.year == year && element.month == month).toList();

  for (var data in selectedMonthChartData) {
    drankAmountList.add(data.drankAmount);
  }

  if (drankAmountList.any((element) => element > 0)) {
    monthlyAverage = drankAmountList.fold(
        0,
        (avg, element) =>
            avg + element / drankAmountList.where((drankAmount) => drankAmount != 0).length);
  }

  return monthlyAverage;
}

/// Weekly drink average
double weeklyDrinkAverage({required List<WeekData> weekDataList}) {
  List<double> drankAmountList = [];
  double weeklyAverage = 0.0;

  for (var data in weekDataList) {
    drankAmountList.add(data.drankAmount);
  }

  if (drankAmountList.any((element) => element > 0)) {
    weeklyAverage = drankAmountList.fold(
        0,
        (avg, element) =>
            avg + element / drankAmountList.where((drankAmount) => drankAmount != 0).length);
  }

  return weeklyAverage;
}

/// Weekly drink percent
double weeklyPercent({required List<WeekData> weekDataList}) {
  double weeklyPercent = 0;

  for (var data in weekDataList) {
    weeklyPercent = weeklyPercent + data.percent;
  }
  return weeklyPercent > 100 ? 100 : weeklyPercent;
}

//TODO: test it
/// Monthly drink percent
double monthlyDrinkPercent({
  required List<ChartData> chartDataList,
  required int month,
  required int year,
  required double intakeGoalAmount,
}) {
  final List<ChartData> selectedMonthChartData =
      chartDataList.where((element) => element.year == year && element.month == month).toList();
  double monthlyDrankAmount = 0.0;
  double monthlyPercent = 0.0;

  for (var data in selectedMonthChartData) {
    if (data.drankAmount > intakeGoalAmount) {
      monthlyDrankAmount += intakeGoalAmount;
    } else {
      monthlyDrankAmount += data.drankAmount;
    }
  }

  int monthDaysCount = getMonthDaysCount(year: year, month: month);
  monthlyPercent = (monthlyDrankAmount / (monthDaysCount * intakeGoalAmount)) * 100;
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
