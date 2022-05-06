import 'package:flutter/material.dart';

/// Build Custom Title For Settings
class BuildTitle extends StatelessWidget {
  const BuildTitle({
    Key? key,
    required this.size,
    required this.title,
  }) : super(key: key);

  final Size size;
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[500],
                fontSize: 15,
              ),
            ),
            SizedBox(height: size.height * 0.0125),
            Container(
              width: size.width * 0.4,
              height: 0.625,
              color: Colors.grey[400],
            ),
          ],
        ),
      );
}
