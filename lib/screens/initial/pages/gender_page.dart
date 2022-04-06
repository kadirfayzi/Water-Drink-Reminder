import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:water_reminder/provider/data_provider.dart';

class GenderPage extends StatefulWidget {
  const GenderPage({
    Key? key,
    required this.size,
    required this.localize,
    required this.provider,
  }) : super(key: key);
  final Size size;
  final AppLocalizations localize;
  final DataProvider provider;

  @override
  State<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(
            widget.localize.yourGender,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: widget.size.height * 0.2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 800),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                GestureDetector(
                  onTap: () {
                    widget.provider.setGender = 0;
                    widget.provider.setWeight = 70;
                    widget.provider.setTempWeight = 70;
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: widget.provider.getGender == 0 ? Colors.grey : Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Image.asset(
                            'assets/images/boy.png',
                            scale: 5,
                          ),
                        ),
                      ),
                      SizedBox(height: widget.size.height * 0.02),
                      Text(
                        widget.localize.male,
                        style: TextStyle(
                          color: widget.provider.getGender == 0 ? Colors.blue : Colors.grey[400],
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: widget.size.width * 0.1),
                GestureDetector(
                  onTap: () {
                    widget.provider.setGender = 1;
                    widget.provider.setWeight = 60;
                    widget.provider.setTempWeight = 60;
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: widget.provider.getGender == 1 ? Colors.grey : Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Image.asset(
                            'assets/images/girl.png',
                            scale: 5,
                          ),
                        ),
                      ),
                      SizedBox(height: widget.size.height * 0.02),
                      Text(
                        widget.localize.female,
                        style: TextStyle(
                          color: widget.provider.getGender == 1 ? Colors.blue : Colors.grey[400],
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
