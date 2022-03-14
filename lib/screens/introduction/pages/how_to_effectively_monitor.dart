import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HowToEffectivelyMonitor extends StatefulWidget {
  const HowToEffectivelyMonitor({Key? key}) : super(key: key);

  @override
  _HowToEffectivelyMonitorState createState() => _HowToEffectivelyMonitorState();
}

class _HowToEffectivelyMonitorState extends State<HowToEffectivelyMonitor> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size.width,
          child: Lottie.asset(
            'assets/lotties/graph.json',
            repeat: false,
          ),
        ),
        SizedBox(height: size.height * 0.03),
        Text(
          AppLocalizations.of(context)!.howToEffectivelyMonitor,
          style: TextStyle(
            fontSize: size.width * 0.06,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: size.height * 0.03),
        Text(
          AppLocalizations.of(context)!.checkYourHydrationReport,
          style: TextStyle(
            fontSize: size.width * 0.04,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
