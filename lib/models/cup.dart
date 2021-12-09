import 'package:hive/hive.dart';

part 'cup.g.dart';

@HiveType(typeId: 0)
class Cup extends HiveObject {
  @HiveField(0)
  late double capacity;
  @HiveField(1)
  late String image;
  @HiveField(2)
  late bool selected;

  Cup({required this.capacity, required this.image, required this.selected});
}
