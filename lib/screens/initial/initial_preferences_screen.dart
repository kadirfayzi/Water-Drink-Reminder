import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/screens/initial/welcome_widgets.dart';
import 'package:water_reminder/screens/introduction/hydration_plan_splash.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants.dart';
import '../../functions.dart';
import 'pages/bedtime_page.dart';
import 'pages/gender_page.dart';
import 'pages/wakeuptime_page.dart';
import 'pages/weight_page.dart';

class InitialPreferences extends StatefulWidget {
  const InitialPreferences({Key? key}) : super(key: key);

  @override
  InitialPreferencesState createState() => InitialPreferencesState();
}

class InitialPreferencesState extends State<InitialPreferences>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.99);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final localize = AppLocalizations.of(context)!;
    return Consumer<DataProvider>(
      builder: (context, provider, _) => Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover,
              opacity: 0.5,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: size.height * 0.06),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StepContainer(
                      size: size,
                      image: 'assets/images/intro/gender.svg',
                      text: provider.getGender == 0 ? localize.male : localize.female,
                      textColor: provider.getPageIndex == 0 ? kPrimaryColor : Colors.grey,
                      activeContainer: provider.getPageIndex == 0,
                    ),
                    SizedBox(
                      width: size.width * 0.05,
                      height: size.height * 0.05,
                      child: CustomPaint(painter: DashedLine()),
                    ),
                    StepContainer(
                      key: ValueKey<Object>(provider.getWeightUnit),
                      size: size,
                      image: 'assets/images/intro/weight.svg',
                      text:
                          '${provider.getTempWeight} ${kWeightUnitStrings[provider.getWeightUnit]}',
                      textColor: provider.getPageIndex == 1 ? kPrimaryColor : Colors.grey,
                      activeContainer: provider.getPageIndex == 1,
                    ),
                    SizedBox(
                      width: size.width * 0.05,
                      height: size.height * 0.05,
                      child: CustomPaint(painter: DashedLine()),
                    ),
                    StepContainer(
                      size: size,
                      image: 'assets/images/intro/alarm.svg',
                      text:
                          '${Functions.twoDigits(provider.getWakeUpTimeHour)}:${Functions.twoDigits(provider.getWakeUpTimeMinute)}',
                      textColor: provider.getPageIndex == 2 ? kPrimaryColor : Colors.grey,
                      activeContainer: provider.getPageIndex == 2,
                    ),
                    SizedBox(
                      width: size.width * 0.05,
                      height: size.height * 0.05,
                      child: CustomPaint(painter: DashedLine()),
                    ),
                    StepContainer(
                      size: size,
                      image: 'assets/images/intro/sleep.svg',
                      text:
                          '${Functions.twoDigits(provider.getBedTimeHour)}:${Functions.twoDigits(provider.getBedTimeMinute)}',
                      textColor: provider.getPageIndex == 3 ? kPrimaryColor : Colors.grey,
                      activeContainer: provider.getPageIndex == 3,
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                SizedBox(
                  height: size.height * 0.675,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      GenderPage(),
                      WeightPage(),
                      WakeupTimePage(),
                      BedTimePage(),
                    ],
                    onPageChanged: (page) => provider.setInitialPrefsPageIndex = page,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        borderRadius: const BorderRadius.all(kRadius_50),
                        onTap: () {
                          if (provider.getPageIndex == 0) {
                            Navigator.pop(context);
                          } else {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.ease,
                            );
                          }
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.all(kRadius_50),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Center(
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: const BorderRadius.all(kRadius_30),
                        onTap: () {
                          if (provider.getPageIndex < 3) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.ease,
                            );
                          } else {
                            /// go to introduction screen
                            Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => HydrationPlanSplash(
                                  provider: provider,
                                  localize: localize,
                                  size: size,
                                ),
                              ),
                              (route) => false,
                            );
                          }
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.all(kRadius_30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Center(
                              child: Text(
                                localize.next,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * 0.04,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
