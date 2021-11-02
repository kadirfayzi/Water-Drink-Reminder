import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  const CustomTab({
    Key? key,
    required this.title,
    required this.icon,
    this.iconSize = 20,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Tab(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(icon, size: iconSize),
        Text(title),
      ],
    ));
  }
}
