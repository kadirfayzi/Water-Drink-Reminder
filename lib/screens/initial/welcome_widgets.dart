import 'package:flutter/material.dart';
import 'package:water_reminder/constants.dart';

class StepContainer extends StatelessWidget {
  const StepContainer({
    Key? key,
    required this.size,
    required this.image,
    required this.text,
    this.textColor = Colors.grey,
    this.activeContainer = false,
  }) : super(key: key);

  final Size size;
  final String image;
  final String text;
  final Color textColor;
  final bool activeContainer;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(kRadius_5),
                color: Colors.grey,
                gradient: activeContainer
                    ? const LinearGradient(
                        colors: [kPrimaryColor, Colors.blue],
                        begin: FractionalOffset(0.0, 0.0),
                        end: FractionalOffset(0.5, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp,
                      )
                    : null,
              ),
              child: Image.asset(
                image,
                color: Colors.white,
                scale: 8,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            SizedBox(
              width: size.width * 0.125,
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(color: textColor),
                ),
              ),
            ),
          ],
        ),
      );
}

class DashedLine extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 1;

    _drawDashedLine(canvas, size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  void _drawDashedLine(Canvas canvas, Size size, Paint paint) {
    // Change to your preferred size
    const int dashWidth = 3;
    const int dashSpace = 3;

    // Start to draw from left size.
    // Of course, you can change it to match your requirement.
    double startX = 0;
    double y = 10;

    // Repeat drawing until we reach the right edge.
    // In our example, size.with = 300 (from the SizedBox)
    while (startX < size.width) {
      // Draw a small line.
      canvas.drawLine(Offset(startX, y), Offset(startX + dashWidth, y), paint);

      // Update the starting X
      startX += dashWidth + dashSpace;
    }
  }
}
