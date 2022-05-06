import 'package:hive/hive.dart';

part 'wakeup_time.g.dart';

@HiveType(typeId: 4)
class WakeupTime extends HiveObject {
  @HiveField(0)
  int wakeupHour;
  @HiveField(1)
  int wakeupMinute;

  WakeupTime({required this.wakeupHour, required this.wakeupMinute});
}
