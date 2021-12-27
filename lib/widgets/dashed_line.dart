import 'package:flutter/material.dart';

class DashedLine extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final int count;
  final Axis direction;

  const DashedLine({
    Key? key,
    this.height = 2,
    this.color = Colors.grey,
    this.width = 0.8,
    this.count = 4,
    this.direction = Axis.vertical,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      children: List.generate(count, (index) {
        return SizedBox(
          width: width,
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(color: color),
          ),
        );
      }),
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      direction: direction,
    );
  }
}
