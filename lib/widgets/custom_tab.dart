import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  const CustomTab({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: MediaQuery.of(context).size.width * 0.0465),
            SizedBox(width: MediaQuery.of(context).size.width * 0.004),
            Text(
              title,
              style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03),
            )
          ],
        ),
      );
}
