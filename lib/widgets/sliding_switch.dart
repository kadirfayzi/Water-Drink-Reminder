import 'package:flutter/material.dart';
import 'package:water_reminder/constants.dart';

class SlidingSwitch extends StatefulWidget {
  final double height;
  final ValueChanged<bool> onChanged;
  final double width;
  final bool value;
  final String textLeft;
  final String textRight;
  final Duration animationDuration;
  final Color background;
  final Color buttonColor;
  final double buttonTextSize;
  final Color activeColor;
  final Color inactiveColor;
  final Function onTap;
  final Function? onDoubleTap;
  final Function onSwipe;
  final double buttonBorderRadius;
  final double backgroundBorderRadius;

  const SlidingSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    this.height = 55,
    this.width = 250,
    this.backgroundBorderRadius = 8,
    this.buttonBorderRadius = 5,
    this.animationDuration = const Duration(milliseconds: 300),
    required this.onTap,
    this.onDoubleTap,
    required this.onSwipe,
    required this.textLeft,
    required this.textRight,
    this.background = kPrimaryColor,
    this.buttonColor = const Color(0xFFFFFFFF),
    this.activeColor = const Color(0xff000000),
    this.inactiveColor = const Color(0xFFFFFFFF),
    this.buttonTextSize = 15,
  }) : super(key: key);
  @override
  _SlidingSwitch createState() => _SlidingSwitch();
}

class _SlidingSwitch extends State<SlidingSwitch> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  double value = 0.0;

  late bool turnState;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, lowerBound: 0.0, upperBound: 1.0, duration: widget.animationDuration);
    animation = CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    animationController.addListener(() => setState(() => value = animation.value));
    turnState = widget.value;
    _determine();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onDoubleTap: () {
          _action();
          widget.onDoubleTap!();
        },
        onTap: () {
          _action();
          widget.onTap();
        },
        onPanEnd: (details) {
          _action();
          widget.onSwipe();
        },
        child: Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: widget.background,
            borderRadius: BorderRadius.circular(widget.backgroundBorderRadius),
          ),
          padding: const EdgeInsets.all(2),
          child: Stack(children: <Widget>[
            Transform.translate(
                offset: Offset(((widget.width * 0.5) * value - (2 * value)), 0),
                child: Container(
                  height: widget.height,
                  width: widget.width * 0.5 - 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.buttonBorderRadius),
                    color: widget.buttonColor,
                  ),
                )),
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      widget.textLeft,
                      style: TextStyle(
                        color: turnState ? widget.inactiveColor : widget.activeColor,
                        fontSize: widget.buttonTextSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      widget.textRight,
                      style: TextStyle(
                        color: turnState ? widget.activeColor : widget.inactiveColor,
                        fontSize: widget.buttonTextSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              ],
            )
          ]),
        ));
  }

  _action() => _determine(changeState: true);

  _determine({bool changeState = false}) => setState(() {
        if (changeState) turnState = !turnState;
        (turnState) ? animationController.forward() : animationController.reverse();
        if (changeState) widget.onChanged(turnState);
      });
}
