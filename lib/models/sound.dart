import 'package:hive/hive.dart';

part 'sound.g.dart';

@HiveType(typeId: 4)
class Sound extends HiveObject {
  @HiveField(0)
  late int soundValue;

  Sound({required this.soundValue});
}
