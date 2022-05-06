import 'package:hive/hive.dart';

part 'cup.g.dart';

@HiveType(typeId: 0)
class Cup extends HiveObject {
  @HiveField(0)
  double capacity;
  @HiveField(1)
  String image;
  @HiveField(2)
  bool selected;
  @HiveField(3)
  bool removable;

  Cup({
    required this.capacity,
    required this.image,
    this.selected = false,
    this.removable = false,
  });
}
