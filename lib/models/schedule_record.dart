import 'package:hive/hive.dart';

part 'schedule_record.g.dart';

@HiveType(typeId: 3)
class ScheduleRecord extends HiveObject {
  @HiveField(0)
  late int id;
  @HiveField(1)
  late String time;
  @HiveField(2)
  late bool isSet;

  ScheduleRecord({required this.id, required this.time, required this.isSet});
}
