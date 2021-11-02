import 'package:flutter/material.dart';
import 'package:water_reminder/models/cup_model.dart';

const Color kPrimaryColor = Color(0xff2196f3);
const Color kSecondaryColor = Color(0xffD6EAF8);

const List<String> tips = [
  'Drink your glass of water slowly with some small sips',
  'Hold the water in your mouth for a while before swallowing',
  'Drinking water in a sitting posture is better than in a standing or running position',
  'Do not drink cold water or water with ice',
  'Do not drink water immediately after eating',
  'Do not drink cold water immediately after hot drinks like tea or coffee',
  'Always drink water before urinating and do not drink water immediately after urinating'
];

const List<String> kWeekDays = [
  'Sun',
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
];

const double kIntakeGoalDefaultValue = 2030.0;

const List<String> kReminderModeStrings = [
  'As device settings',
  'Sound and vibrate',
  'Vibrate only',
  'Display only',
  'Turn off',
];
const List<IconData> kReminderModeIcons = [
  Icons.mobile_friendly,
  Icons.notifications_active,
  Icons.vibration,
  Icons.messenger,
  Icons.notifications_off,
];

const List<String> kWeightUnitStrings = ['kg', 'lbs'];
const List<String> kCapacityUnitStrings = ['ml', 'fl oz'];
const List<String> kGenderStrings = ['Male', 'Female'];

const List<String> kCupDivisionStrings = ['1/4', '2/4', '3/4', '4/4'];

const List<Cup> kCups = [
  Cup(100, 'assets/images/cup.png'),
  Cup(125, 'assets/images/cup.png'),
  Cup(150, 'assets/images/cup.png'),
  Cup(175, 'assets/images/cup.png'),
  Cup(200, 'assets/images/cup.png'),
  Cup(300, 'assets/images/cup.png'),
  Cup(400, 'assets/images/cup.png'),
  Cup(500, 'assets/images/cup.png'),
];
