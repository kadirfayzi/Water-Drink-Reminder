import 'package:hive/hive.dart';

part 'week_data.g.dart';

@HiveType(typeId: 6)
class WeekData extends HiveObject {
  @HiveField(0)
  double drankAmount;
  @HiveField(1)
  int day;
  @HiveField(2)
  double percent;
  @HiveField(3)
  int weekNumber;

  WeekData({
    required this.drankAmount,
    required this.day,
    required this.percent,
    required this.weekNumber,
  });
}
