import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/main.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/screens/introduction/pages/daily_water_intake.dart';
import 'package:water_reminder/screens/introduction/pages/how_much_should_drink.dart';
import 'package:water_reminder/screens/introduction/pages/how_to_effectively_monitor.dart';
import 'package:water_reminder/screens/introduction/pages/what_is_the_right_time.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
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
          body: DecoratedBox(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
                opacity: 0.25,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: size.height * 0.08),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset(
                            provider.getGender == 0
                                ? 'assets/images/boy.png'
                                : 'assets/images/girl.png',
                            scale: 15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        AppLocalizations.of(context)!.personalHydraPlan,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.725,
                    child: PageView(
                      controller: pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        DailyWaterIntake(provider: provider),
                        HowMuchShouldDrink(provider: provider),
                        const WhatIsTheRightTime(),
                        const HowToEffectivelyMonitor(),
                      ],
                      onPageChanged: (page) => setState(() => currentPage = page),
                    ),
                  ),
                  if (currentPage == 3)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: InkWell(
                        borderRadius: const BorderRadius.all(kRadius_30),
                        onTap: () => Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(builder: (context) => const MyApp()),
                        ),
                        child: Container(
                          width: size.width * 0.65,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(kRadius_30),
                            gradient: LinearGradient(
                              colors: [kPrimaryColor, Colors.blue],
                              begin: FractionalOffset(0.0, 0.0),
                              end: FractionalOffset(0.5, 0.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.start,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            borderRadius: const BorderRadius.all(kRadius_50),
                            onTap: () => pageController.animateToPage(3,
                                duration: const Duration(milliseconds: 300), curve: Curves.ease),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.all(kRadius_50),
                                gradient: LinearGradient(
                                  colors: [kPrimaryColor, Colors.blue],
                                  begin: FractionalOffset(0.0, 0.0),
                                  end: FractionalOffset(0.5, 0.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.skip,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            borderRadius: const BorderRadius.all(kRadius_30),
                            onTap: () => pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.all(kRadius_30),
                                gradient: LinearGradient(
                                  colors: [kPrimaryColor, Colors.blue],
                                  begin: FractionalOffset(0.0, 0.0),
                                  end: FractionalOffset(0.5, 0.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.next,
                                    style: const TextStyle(
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
          ),
        );
      },
    );
  }
}
