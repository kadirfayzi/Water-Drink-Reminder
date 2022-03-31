import 'package:hive/hive.dart';
import 'models/bed_time.dart';
import 'models/chart_data.dart';
import 'models/cup.dart';
import 'models/record.dart';
import 'models/schedule_record.dart';
import 'models/wakeup_time.dart';
import 'models/week_data.dart';

class Boxes {
  static Box<Cup> getCups() => Hive.box<Cup>('cups');
  static Box<Record> getRecords() => Hive.box<Record>('records');
  static Box<ChartData> getChartData() => Hive.box<ChartData>('chartData');
  static Box<ScheduleRecord> getScheduleRecords() => Hive.box<ScheduleRecord>('scheduleRecords');
  static Box<WakeupTime> getWakeupTime() => Hive.box<WakeupTime>('wakeupTime');
  static Box<BedTime> getBedTime() => Hive.box<BedTime>('bedTime');
  static Box<WeekData> getWeekData() => Hive.box<WeekData>('weekData');

  static Box getWeightUnit() => Hive.box('weightUnit');
  static Box getCapacityUnit() => Hive.box('capacityUnit');
  static Box getSoundValue() => Hive.box('sound');
  static Box getIntakeGoalAmount() => Hive.box('intakeGoalAmount');
  static Box getGender() => Hive.box('gender');
  static Box getWeight() => Hive.box('weight');
  static Box getDrankAmount() => Hive.box('drankAmount');
  static Box getLangCode() => Hive.box('langCode');
  static Box getIsInitialPrefsSet() => Hive.box('isInitialPrefsSet');
  static Box getAppLastUseDateTime() => Hive.box('appLastUseDateTime');
}
