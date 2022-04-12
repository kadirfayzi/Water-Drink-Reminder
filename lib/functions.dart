import 'package:intl/intl.dart';
import 'package:water_reminder/models/week_data.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'models/chart_data.dart';
import 'models/schedule_record.dart';

class Functions {
  static DateTime stringToDate({required String dateString}) =>
      DateFormat("yyyy-MM-dd").parse(dateString);
  static DateTime stringToTime({required String timeString}) =>
      DateFormat("hh:mm").parse(timeString);
  static DateTime date(DateTime dateTime) => DateTime(dateTime.day);

  static int kgToLbs(int kg) => (kg * 2.205).toInt().round();
  static int lbsToKg(int lbs) => (lbs ~/ 2.205).toInt().round();
  static double mlToFlOz(double ml) => (ml / 29.574);
  static double flOzToMl(double flOz) => (flOz * 29.574);
  static double calculateIntakeGoalAmount({
    required int weight,
    required int gender,
  }) {
    if (gender == 0) {
      return (weight * 40).roundToDouble();
    } else {
      return (weight * 35).roundToDouble();
    }
  }

  static int calculateReminderCount({
    required int bedHour,
    required int wakeUpHour,
  }) =>
      (bedHour - wakeUpHour) ~/ 1.5;

  /// Remove all records if day changes
  static removeAllRecordsIfDayChanges({required DataProvider provider}) {
    final DateTime now = DateTime.now();

    if (provider.getRecords.isNotEmpty) {
      if (now
              .difference(stringToDate(dateString: provider.getRecords.first.time.split(' ')[0]))
              .inDays >
          0) {
        provider.deleteAllRecords();
        provider.removeAllDrunkAmount();
      }
    }
  }

  /// Remove week data if week changes
  static removeWeekDataIfWeekChanges({required DataProvider provider}) {
    final DateTime now = DateTime.now();

    if (provider.getWeekDataList.isNotEmpty) {
      if (provider.getWeekDataList.first.weekNumber != weekNumber(now)) {
        provider.removeWeekData();
      }
    }
  }

  /// Reset monthly chart data if month changes
  static resetMonthlyChartDataIfMonthChanges({required DataProvider provider}) {
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
          addMonth: true,
        );
      }
    }
  }

  /// Schedule records to date time list
  static List<DateTime> dtScheduleRecords({
    required List<ScheduleRecord> scheduleRecords,
    required DateTime now,
  }) {
    return scheduleRecords
        .map((scheduleRecord) => DateTime(
              now.year,
              now.month,
              now.day,
              int.parse(scheduleRecord.time.split(':')[0]),
              int.parse(scheduleRecord.time.split(':')[1]),
            ))
        .toList();
  }

  /// Calculate next drink time
  static String calculateNextDrinkTime({required List<ScheduleRecord> scheduleRecords}) {
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
  static double monthlyDrinkAverage({
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
  static double weeklyDrinkAverage({required List<WeekData> weekDataList}) {
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
  static double weeklyPercent({required List<WeekData> weekDataList}) {
    double weeklyPercent = 0;

    for (var data in weekDataList) {
      weeklyPercent = weeklyPercent + data.percent;
    }
    return weeklyPercent > 100 ? 100 : weeklyPercent;
  }

  /// Monthly drink percent
  static double monthlyDrinkPercent({
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
  static int drinkFrequency({required List<ChartData> chartDataList}) {
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
  static int averageCompletion({required List<ChartData> chartDataList}) {
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

  /// Converts hour and minutes to two digits if they are one digits
  static String twoDigits(int n) => n.toString().padLeft(2, '0');

  /// Gets current month days count
  static int getCurrentMonthDaysCount({required DateTime now}) =>
      DateTime(now.year, now.month + 1, 0).difference(DateTime(now.year, now.month, 0)).inDays;

  /// Gets specific month days count
  static int getMonthDaysCount({required int year, required int month}) =>
      DateTime(year, month + 1, 0).difference(DateTime(year, month, 0)).inDays;

  /// Calculates number of weeks for a given year
  static int numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  /// Calculates week number from a date
  static int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = numOfWeeks(date.year - 1);
    } else if (woy > numOfWeeks(date.year)) {
      woy = 1;
    }
    return woy;
  }
}
