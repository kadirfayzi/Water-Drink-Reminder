import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
          body: Padding(
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
                          Provider.of<DataProvider>(context, listen: false)
                                      .getGender ==
                                  0
                              ? 'assets/images/boy.png'
                              : 'assets/images/girl.png',
                          scale: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Personal hydration plan',
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
                    // physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      DailyWaterIntake(),
                      HowMuchShouldDrink(),
                      WhatIsTheRightTime(),
                      HowToEffectivelyMonitor(),
                    ],
                    onPageChanged: (page) => setState(() => currentPage = page),
                  ),
                ),
                if (currentPage == 3)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Material(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () => Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const MyApp()),
                        ),
                        child: Container(
                          width: size.width * 0.65,
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
                                'START',
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
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => pageController.animateToPage(3,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease),
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
                                child: Text(
                                  'Skip',
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
                        InkWell(
                          onTap: () => pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          ),
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
