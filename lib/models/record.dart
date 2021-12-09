import 'package:hive/hive.dart';

part 'record.g.dart';

@HiveType(typeId: 1)
class Record extends HiveObject {
  @HiveField(0)
  late String image;
  @HiveField(1)
  late String time;
  @HiveField(2)
  late double defaultAmount;
  @HiveField(3)
  late int cupDivisionIndex;

  Record({
    required this.image,
    required this.time,
    required this.defaultAmount,
    this.cupDivisionIndex = 3,
  });

  get dividedCapacity => (defaultAmount * (cupDivisionIndex + 1)) / 4;
}
