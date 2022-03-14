import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WhatIsTheRightTime extends StatefulWidget {
  const WhatIsTheRightTime({Key? key}) : super(key: key);

  @override
  _WhatIsTheRightTimeState createState() => _WhatIsTheRightTimeState();
}

class _WhatIsTheRightTimeState extends State<WhatIsTheRightTime> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size.width * 0.3,
          height: size.width * 0.3,
          child: Lottie.asset(
            'assets/lotties/alarm-clock.json',
            repeat: false,
          ),
        ),
        SizedBox(height: size.height * 0.01),
        SizedBox(
          width: size.width * 0.5,
          height: size.width * 0.5,
          child: Lottie.asset(
            'assets/lotties/water-glass.json',
            repeat: false,
          ),
        ),
        SizedBox(height: size.height * 0.05),
        Text(
          AppLocalizations.of(context)!.whatIsTheRightTime,
          style: TextStyle(
            fontSize: size.width * 0.06,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: size.height * 0.03),
        Text(
          AppLocalizations.of(context)!.dontWorryIllRemindYouOnTime,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
