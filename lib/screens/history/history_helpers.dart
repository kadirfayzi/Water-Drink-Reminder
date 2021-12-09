import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:water_reminder/constants.dart';

Widget buildReportRow({
  required Size size,
  required Color iconColor,
  required String title,
  required String content,
}) {
  return SizedBox(
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
}

Widget buildTimeRangeSelectionButton({
  required Size size,
  required String title,
  required Color color,
  required Color textColor,
  required Function() onTap,
}) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width * 0.15,
        height: size.height * 0.03,
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: kPrimaryColor, width: 1.5),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 13, color: textColor),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );
}
