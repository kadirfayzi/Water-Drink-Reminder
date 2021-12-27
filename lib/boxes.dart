import 'package:hive/hive.dart';
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

class Boxes {
  static Box<Cup> getCups() => Hive.box<Cup>('cups');
  static Box<Record> getRecords() => Hive.box<Record>('records');
  static Box<ChartData> getChartData() => Hive.box<ChartData>('chartData');
  static Box<ScheduleRecord> getScheduleRecords() =>
      Hive.box<ScheduleRecord>('scheduleRecords');
  static Box<Sound> getSoundValue() => Hive.box<Sound>('sound');
  static Box<Unit> getUnits() => Hive.box<Unit>('units');
  static Box<IntakeGoal> getIntakeGoal() => Hive.box<IntakeGoal>('intakeGoal');
  static Box<Gender> getGender() => Hive.box<Gender>('gender');
  static Box<Weight> getWeight() => Hive.box<Weight>('weight');
  static Box<WakeupTime> getWakeupTime() => Hive.box<WakeupTime>('wakeupTime');
  static Box<BedTime> getBedTime() => Hive.box<BedTime>('bedTime');
  static Box<DrunkAmount> getDrunkAmount() =>
      Hive.box<DrunkAmount>('drunkAmount');
  static Box getIsInitialPrefsSet() => Hive.box('isInitialPrefsSet');
}
