import 'package:flutter/material.dart';

import 'models/cup.dart';

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

List<Cup> kCups = [
  Cup(capacity: 100, image: 'assets/images/cup.png', selected: true),
  Cup(capacity: 125, image: 'assets/images/cup.png', selected: false),
  Cup(capacity: 150, image: 'assets/images/cup.png', selected: false),
  Cup(capacity: 175, image: 'assets/images/cup.png', selected: false),
  Cup(capacity: 200, image: 'assets/images/cup.png', selected: false),
  Cup(capacity: 250, image: 'assets/images/cup.png', selected: false),
  Cup(capacity: 300, image: 'assets/images/cup.png', selected: false),
  Cup(capacity: 350, image: 'assets/images/cup.png', selected: false),
  Cup(capacity: 400, image: 'assets/images/cup.png', selected: false),
  Cup(capacity: 500, image: 'assets/images/cup.png', selected: false),
];

const List<String> kSounds = ['Water pouring', 'Water drop 1', 'Water drop 2'];
