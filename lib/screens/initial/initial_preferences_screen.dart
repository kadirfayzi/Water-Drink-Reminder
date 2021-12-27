import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/screens/initial/welcome_widgets.dart';
import 'package:water_reminder/screens/introduction/hydration_plan_splash.dart';

import '../../constants.dart';
import '../../functions.dart';
import 'pages/bedtime_page.dart';
import 'pages/gender_page.dart';
import 'pages/wakeuptime_page.dart';
import 'pages/weight_page.dart';

class InitialPreferences extends StatefulWidget {
  const InitialPreferences({Key? key}) : super(key: key);

  @override
  _InitialPreferencesState createState() => _InitialPreferencesState();
}

class _InitialPreferencesState extends State<InitialPreferences> {
  final PageController pageController = PageController();
  int currentPage = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<DataProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.only(top: size.height * 0.06),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StepContainer(
                      image: 'assets/images/gender.png',
                      text: kGenderStrings[provider.getGender],
                      textColor: currentPage == 0 ? Colors.blue : Colors.grey,
                      activeContainer: currentPage == 0,
                    ),
                    SizedBox(
                      width: size.width * 0.05,
                      height: size.height * 0.05,
                      child: CustomPaint(painter: DashedLine()),
                    ),
                    StepContainer(
                      image: 'assets/images/weight.png',
                      text:
                          '${provider.getWeight} ${kWeightUnitStrings[provider.getWeightUnit]}',
                      textColor: currentPage == 1 ? Colors.blue : Colors.grey,
                      activeContainer: currentPage == 1,
                    ),
                    SizedBox(
                      width: size.width * 0.05,
                      height: size.height * 0.05,
                      child: CustomPaint(painter: DashedLine()),
                    ),
                    StepContainer(
                      image: 'assets/images/alarm.png',
                      text:
                          '${twoDigits(provider.getWakeUpTimeHour)}:${twoDigits(provider.getWakeUpTimeMinute)}',
                      textColor: currentPage == 2 ? Colors.blue : Colors.grey,
                      activeContainer: currentPage == 2,
                    ),
                    SizedBox(
                      width: size.width * 0.05,
                      height: size.height * 0.05,
                      child: CustomPaint(painter: DashedLine()),
                    ),
                    StepContainer(
                      image: 'assets/images/sleep.png',
                      text:
                          '${twoDigits(provider.getBedTimeHour)}:${twoDigits(provider.getBedTimeMinute)}',
                      textColor: currentPage == 3 ? Colors.blue : Colors.grey,
                      activeContainer: currentPage == 3,
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.03),
                SizedBox(
                  height: size.height * 0.675,
                  child: PageView(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      GenderPage(),
                      WeightPage(),
                      WakeupTimePage(),
                      BedTimePage(),
                    ],
                    onPageChanged: (page) => setState(() => currentPage = page),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          if (pageController.page == 0) {
                            Navigator.pop(context);
                          } else {
                            pageController.previousPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(50),
                            gradient: const LinearGradient(
                              colors: [Colors.lightBlueAccent, Colors.blue],
                              begin: FractionalOffset(0.0, 0.0),
                              end: FractionalOffset(0.5, 0.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp,
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Center(
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (pageController.page! < 3) {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          } else {
                            /// go to introduction screen
                            Navigator.pushAndRemoveUntil(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        const HydrationPlanSplash()),
                                (route) => false);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              colors: [Colors.lightBlueAccent, Colors.blue],
                              begin: FractionalOffset(0.0, 0.0),
                              end: FractionalOffset(0.5, 0.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp,
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Center(
                              child: Text(
                                'NEXT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
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
        );
      },
    );
  }
}
