import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class Wave extends StatefulWidget {
  final double? value;
  final Color color;
  final Axis direction;
  final bool linear;

  const Wave({
    Key? key,
    required this.value,
    required this.color,
    required this.direction,
    this.linear = false,
  }) : super(key: key);

  @override
  WaveState createState() => WaveState();
}

class WaveState extends State<Wave> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    widget.linear ? _animationController.repeat() : _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
      builder: (context, child) => ClipPath(
        clipper: _WaveClipper(
          animationValue: _animationController.value,
          value: widget.value,
          direction: widget.direction,
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            // color: kPrimaryColor,
            // color: widget.color,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.15),
                  Colors.blue.withOpacity(0.5),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: const [0.0, 1.0],
              ),
            ),
            // color: Colors.blue.withOpacity(0.2),
          ),
        ),
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  final double animationValue;
  final double? value;
  final Axis direction;

  _WaveClipper({
    required this.animationValue,
    required this.value,
    required this.direction,
  });

  @override
  Path getClip(Size size) {
    if (direction == Axis.horizontal) {
      Path path = Path()
        ..addPolygon(_generateHorizontalWavePath(size), false)
        ..lineTo(0.0, size.height)
        ..lineTo(0.0, 0.0)
        ..close();
      return path;
    }

    Path path = Path()
      ..addPolygon(_generateVerticalWavePath(size), false)
      ..lineTo(size.width, size.height)
      ..lineTo(0.0, size.height)
      ..close();
    return path;
  }

  List<Offset> _generateHorizontalWavePath(Size size) {
    final waveList = <Offset>[];
    for (int i = -2; i <= size.height.toInt() + 2; i++) {
      final waveHeight = (size.width / 20);
      final dx = math.sin((animationValue * 360 - i) % 360 * (math.pi / 180)) * waveHeight +
          (size.width * value!);
      waveList.add(Offset(dx, i.toDouble()));
    }
    return waveList;
  }

  List<Offset> _generateVerticalWavePath(Size size) {
    final waveList = <Offset>[];
    for (int i = -2; i <= size.width.toInt() + 2; i++) {
      final waveHeight = (size.height / 20);
      final dy = math.sin((animationValue * 360 - i) % 360 * (math.pi / 180)) * waveHeight +
          (size.height - (size.height * value!));
      waveList.add(Offset(i.toDouble(), dy));
    }
    return waveList;
  }

  @override
  bool shouldReclip(_WaveClipper oldClipper) => animationValue != oldClipper.animationValue;
}
