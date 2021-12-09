import 'package:hive/hive.dart';

part 'wakeup_time.g.dart';

@HiveType(typeId: 9)
class WakeupTime extends HiveObject {
  @HiveField(0)
  late int wakeupHour;
  @HiveField(1)
  late int wakeupMinute;

  WakeupTime({required this.wakeupHour, required this.wakeupMinute});
}
