import 'package:flutter/material.dart';

Widget buildReportRow({
  required Size size,
  required Color iconColor,
  required String title,
  required String content,
}) =>
    SizedBox(
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
