import 'package:hive/hive.dart';

part 'record.g.dart';

@HiveType(typeId: 1)
class Record extends HiveObject {
  @HiveField(0)
  String image;
  @HiveField(1)
  String time;
  @HiveField(2)
  double amount;

  Record({required this.image, required this.time, required this.amount});
}
