import 'package:flutter/material.dart';

class ReportRow extends StatelessWidget {
  const ReportRow({
    Key? key,
    required this.size,
    required this.iconColor,
    required this.title,
    required this.content,
  }) : super(key: key);

  final Size size;
  final Color iconColor;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.0625,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.circle, size: 12, color: iconColor),
                const SizedBox(width: 10),
                Text(title),
              ],
            ),
            Text(
              content,
              style: const TextStyle(fontSize: 15),
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ),
    );
  }
}
