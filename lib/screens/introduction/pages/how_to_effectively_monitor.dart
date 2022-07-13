import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HowToEffectivelyMonitor extends StatefulWidget {
  const HowToEffectivelyMonitor({
    Key? key,
    required this.localize,
    required this.size,
  }) : super(key: key);

  final AppLocalizations localize;
  final Size size;

  @override
  HowToEffectivelyMonitorState createState() => HowToEffectivelyMonitorState();
}

class HowToEffectivelyMonitorState extends State<HowToEffectivelyMonitor> {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: widget.size.width,
            child: Lottie.asset(
              'assets/lotties/graph.json',
              repeat: false,
            ),
          ),
          SizedBox(height: widget.size.height * 0.03),
          SizedBox(
            width: widget.size.width * 0.95,
            child: Center(
              child: Text(
                widget.localize.howToEffectivelyMonitor,
                style: TextStyle(
                  fontSize: widget.size.width * 0.06,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: widget.size.height * 0.03),
          SizedBox(
            width: widget.size.width * 0.95,
            child: Center(
              child: Text(
                widget.localize.checkYourHydrationReport,
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
