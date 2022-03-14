import 'package:hive/hive.dart';
import 'package:water_reminder/models/bed_time.dart';
import 'package:water_reminder/models/chart_data.dart';
import 'package:water_reminder/models/cup.dart';
import 'package:water_reminder/models/record.dart';
import 'package:water_reminder/models/schedule_record.dart';
import 'package:water_reminder/models/wakeup_time.dart';

class Boxes {
  static Box<Cup> getCups() => Hive.box<Cup>('cups');
  static Box<Record> getRecords() => Hive.box<Record>('records');
  static Box<ChartData> getChartData() => Hive.box<ChartData>('chartData');
  static Box<ScheduleRecord> getScheduleRecords() => Hive.box<ScheduleRecord>('scheduleRecords');
  static Box<WakeupTime> getWakeupTime() => Hive.box<WakeupTime>('wakeupTime');
  static Box<BedTime> getBedTime() => Hive.box<BedTime>('bedTime');

  static Box getWeightUnit() => Hive.box('weightUnit');
  static Box getCapacityUnit() => Hive.box('capacityUnit');
  static Box getSoundValue() => Hive.box('sound');
  static Box getIntakeGoalAmount() => Hive.box('intakeGoalAmount');
  static Box getGender() => Hive.box('gender');
  static Box getWeight() => Hive.box('weight');
  static Box getDrunkAmount() => Hive.box('drunkAmount');
  static Box getLangCode() => Hive.box('langCode');
  static Box getIsInitialPrefsSet() => Hive.box('isInitialPrefsSet');
}
