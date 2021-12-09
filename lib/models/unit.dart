import 'package:hive/hive.dart';

part 'unit.g.dart';

@HiveType(typeId: 5)
class Unit extends HiveObject {
  @HiveField(0)
  late int weightUnit;
  @HiveField(1)
  late int capacityUnit;

  Unit({required this.weightUnit, required this.capacityUnit});
}
