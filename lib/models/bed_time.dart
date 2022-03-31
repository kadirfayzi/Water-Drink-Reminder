import 'package:hive/hive.dart';

part 'bed_time.g.dart';

@HiveType(typeId: 5)
class BedTime extends HiveObject {
  @HiveField(0)
  late int bedHour;
  @HiveField(1)
  late int bedMinute;

  BedTime({required this.bedHour, required this.bedMinute});
}
