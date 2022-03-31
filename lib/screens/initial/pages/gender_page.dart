import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:water_reminder/provider/data_provider.dart';

class GenderPage extends StatefulWidget {
  const GenderPage({Key? key}) : super(key: key);

  @override
  State<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<DataProvider>(
      builder: (context, provider, _) => Column(
        children: [
          Text(
            AppLocalizations.of(context)!.yourGender,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: size.height * 0.2),
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
                    provider.setGender = 0;
                    provider.setWeight = 70;
                    provider.setTempWeight = 70;
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: provider.getGender == 0 ? Colors.grey : Colors.grey[300],
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
                      SizedBox(height: size.height * 0.02),
                      Text(
                        AppLocalizations.of(context)!.male,
                        style: TextStyle(
                          color: provider.getGender == 0 ? Colors.blue : Colors.grey[400],
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: size.width * 0.1),
                GestureDetector(
                  onTap: () {
                    provider.setGender = 1;
                    provider.setWeight = 60;
                    provider.setTempWeight = 60;
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: provider.getGender == 1 ? Colors.grey : Colors.grey[300],
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
                      SizedBox(height: size.height * 0.02),
                      Text(
                        AppLocalizations.of(context)!.female,
                        style: TextStyle(
                          color: provider.getGender == 1 ? Colors.blue : Colors.grey[400],
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
      ),
    );
  }
}
