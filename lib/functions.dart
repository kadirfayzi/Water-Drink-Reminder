import 'dart:math';
import 'package:water_reminder/constants.dart';

/// Get and return random tip from tips list
String getRandomTip() {
  final random = Random();
  final i = random.nextInt(tips.length);
  return tips[i];
}

/// Convert kg to lbs

int convertKgToLbs(int kg) => (kg * 2.205).toInt().round();
