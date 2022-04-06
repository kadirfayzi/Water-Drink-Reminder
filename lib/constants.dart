import 'package:flutter/material.dart';
import 'models/cup.dart';

const String kEmail = 'kadir.fayzi@gmail.com';
const Color kPrimaryColor = Color(0xFF42A5F5);

const List<String> kWeightUnitStrings = ['kg', 'lbs'];
const List<int> kWeightChildCount = [400, 882];
const List<String> kCapacityUnitStrings = ['ml', 'fl oz'];
const List<String> kCupDivisionStrings = ['1/4', '2/4', '3/4', '4/4'];

List<Cup> kCups = [
  Cup(capacity: 100, image: 'assets/images/cups/100-128.png', selected: false),
  Cup(capacity: 125, image: 'assets/images/cups/125-128.png', selected: false),
  Cup(capacity: 150, image: 'assets/images/cups/150-128.png', selected: false),
  Cup(capacity: 175, image: 'assets/images/cups/175-128.png', selected: true),
  Cup(capacity: 200, image: 'assets/images/cups/200-128.png', selected: false),
  Cup(capacity: 300, image: 'assets/images/cups/300-128.png', selected: false),
];

const List<String> kSounds = ['Water pouring', 'Water drop 1', 'Water drop 2'];

const kRadius_5 = Radius.circular(5);
const kRadius_10 = Radius.circular(10);
const kRadius_20 = Radius.circular(20);
const kRadius_25 = Radius.circular(25);
const kRadius_30 = Radius.circular(30);
const kRadius_50 = Radius.circular(50);

const List<double> kDrankLimits = [10000, 338];
