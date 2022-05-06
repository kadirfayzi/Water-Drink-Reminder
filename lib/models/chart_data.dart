import 'package:hive/hive.dart';

part 'chart_data.g.dart';

@HiveType(typeId: 2)
class ChartData extends HiveObject {
  @HiveField(0)
  int day;
  @HiveField(1)
  int month;
  @HiveField(2)
  int year;
  @HiveField(3)
  String name;
  @HiveField(4)
  double percent;
  @HiveField(5)
  double drankAmount;
  @HiveField(6)
  int recordCount;

  ChartData({
    required this.day,
    required this.month,
    required this.year,
    required this.name,
    required this.percent,
    required this.drankAmount,
    required this.recordCount,
  });
}
