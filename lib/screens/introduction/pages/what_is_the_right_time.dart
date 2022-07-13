import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WhatIsTheRightTime extends StatefulWidget {
  const WhatIsTheRightTime({
    Key? key,
    required this.localize,
    required this.size,
  }) : super(key: key);

  final AppLocalizations localize;
  final Size size;

  @override
  WhatIsTheRightTimeState createState() => WhatIsTheRightTimeState();
}

class WhatIsTheRightTimeState extends State<WhatIsTheRightTime> {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: widget.size.width * 0.3,
            height: widget.size.width * 0.3,
            child: Lottie.asset(
              'assets/lotties/alarm-clock.json',
              repeat: false,
            ),
          ),
          SizedBox(height: widget.size.height * 0.01),
          SizedBox(
            width: widget.size.width * 0.5,
            height: widget.size.width * 0.5,
            child: Lottie.asset(
              'assets/lotties/water-glass.json',
              repeat: false,
            ),
          ),
          SizedBox(height: widget.size.height * 0.05),
          SizedBox(
            width: widget.size.width * 0.95,
            child: Text(
              widget.localize.whatIsTheRightTime,
              style: TextStyle(
                fontSize: widget.size.width * 0.06,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: widget.size.height * 0.03),
          SizedBox(
            width: widget.size.width * 0.95,
            child: Center(
              child: Text(
                widget.localize.dontWorryIllRemindYouOnTime,
                style: TextStyle(
                  fontSize: widget.size.width * 0.04,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
}
