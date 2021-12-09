import 'package:hive/hive.dart';

part 'drunk_amount.g.dart';

@HiveType(typeId: 11)
class DrunkAmount extends HiveObject {
  @HiveField(0)
  late double drunkAmount;

  DrunkAmount({required this.drunkAmount});
}
