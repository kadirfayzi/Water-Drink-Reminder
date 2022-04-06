import 'package:hive/hive.dart';

part 'week_data.g.dart';

@HiveType(typeId: 6)
class WeekData extends HiveObject {
  @HiveField(0)
  late double drankAmount;
  @HiveField(1)
  late int day;
  @HiveField(2)
  late double percent;
  @HiveField(3)
  late int weekNumber;

  WeekData({
    required this.drankAmount,
    required this.day,
    required this.percent,
    required this.weekNumber,
  });
}
