import 'package:hive/hive.dart';

part 'chart_data.g.dart';

@HiveType(typeId: 2)
class ChartData extends HiveObject {
  @HiveField(0)
  late int day;
  @HiveField(1)
  late int month;
  @HiveField(2)
  late int year;
  @HiveField(3)
  late String name;
  @HiveField(4)
  late double percent;

  ChartData({
    required this.day,
    required this.month,
    required this.year,
    required this.name,
    required this.percent,
  });
}
