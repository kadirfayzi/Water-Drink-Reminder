import 'package:hive/hive.dart';

part 'chart_data.g.dart';

@HiveType(typeId: 2)
class ChartData extends HiveObject {
  @HiveField(0)
  late int x;
  @HiveField(1)
  late int y;

  ChartData({required this.x, required this.y});
}
