import 'package:hive/hive.dart';

part 'schedule_record.g.dart';

@HiveType(typeId: 3)
class ScheduleRecord extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String time;
  @HiveField(2)
  bool isSet;

  ScheduleRecord({required this.id, required this.time, required this.isSet});
}
