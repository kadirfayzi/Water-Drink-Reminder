import 'package:flutter/material.dart';
import 'package:water_reminder/constants.dart';

Widget buildReportRow({
  required Size size,
  required Color iconColor,
  required String title,
  required String content,
}) =>
    SizedBox(
      height: size.height * 0.0625,
      width: size.width * 0.95,
      child: Row(
        children: [
          Expanded(child: Icon(Icons.circle, size: 12, color: iconColor)),
          Expanded(flex: 6, child: Text(title)),
          Expanded(
            flex: 3,
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: kPrimaryColor,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
