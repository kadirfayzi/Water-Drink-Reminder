import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
          const Text(
            'Your Gender',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: size.height * 0.2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  provider.setGender = 0;
                  provider.setWeight(70, provider.getWeightUnit);
                },
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: provider.getGender == 0
                            ? Colors.grey
                            : Colors.grey[300],
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
                      'Male',
                      style: TextStyle(
                        color: provider.getGender == 0
                            ? Colors.blue
                            : Colors.grey[400],
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
                  provider.setWeight(60, provider.getWeightUnit);
                },
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: provider.getGender == 1
                            ? Colors.grey
                            : Colors.grey[300],
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
                      'Female',
                      style: TextStyle(
                        color: provider.getGender == 1
                            ? Colors.blue
                            : Colors.grey[400],
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
