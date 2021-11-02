import 'package:flutter/material.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/widgets/build_appbar.dart';
import 'package:water_reminder/widgets/elevated_container.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const BuildAppBar(
        title: Text('How to drink water correctly ?'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(
              tips.length,
              (index) => ElevatedContainer(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 15,
                    ),
                    shape: BoxShape.rectangle,
                    blurRadius: 1.5,
                    child: Row(
                      children: [
                        Expanded(
                          child: Image.asset(
                            'assets/images/1.png',
                            scale: 5,
                          ),
                        ),
                        SizedBox(width: size.width * 0.02),
                        Expanded(
                          flex: 5,
                          child: Text(tips[index]),
                        ),
                      ],
                    ),
                  )),
        ),
      ),
    );
  }
}
