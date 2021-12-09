import 'package:hive/hive.dart';

part 'weight.g.dart';

@HiveType(typeId: 8)
class Weight extends HiveObject {
  @HiveField(0)
  late int weight;

  Weight({required this.weight});
}
