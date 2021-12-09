import 'package:flutter/material.dart';

class ElevatedContainer extends StatelessWidget {
  const ElevatedContainer({
    Key? key,
    this.child,
    this.color = Colors.white,
    this.shadowColor = Colors.grey,
    this.blurRadius = 5.0,
    this.width,
    this.height,
    this.shape = BoxShape.circle,
    this.padding,
    this.borderRadius,
  }) : super(key: key);

  final Widget? child;
  final double blurRadius;
  final Color color;
  final Color shadowColor;
  final double? width;
  final double? height;
  final BoxShape shape;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        shape: shape,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: const Offset(0.0, 1.0), //(x,y)
            blurRadius: blurRadius,
          ),
        ],
      ),
      child: child,
    );
  }
}
