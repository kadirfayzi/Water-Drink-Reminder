import 'package:hive/hive.dart';

part 'gender.g.dart';

@HiveType(typeId: 7)
class Gender extends HiveObject {
  @HiveField(0)
  late int gender;

  Gender({required this.gender});
}
