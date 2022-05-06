import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/provider/data_provider.dart';

class GenderPage extends StatelessWidget {
  const GenderPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final localize = AppLocalizations.of(context)!;
    return Consumer<DataProvider>(
      builder: (context, provider, _) => Column(
        children: [
          Text(
            localize.yourGender,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xff000000),
            ),
          ),
          SizedBox(height: size.height * 0.2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  provider.setGender = 0;
                  provider.setWeight = 70;
                  provider.setTempWeight = 70;
                },
                child: Column(
                  children: [
                    Opacity(
                      opacity: provider.getGender == 0 ? 1 : 0.3,
                      child: Image.asset(
                        'assets/images/intro/male.png',
                        scale: 3,
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      localize.male,
                      style: TextStyle(
                        color: provider.getGender == 0 ? Colors.blue : Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: size.width * 0.1),
              InkWell(
                onTap: () {
                  provider.setGender = 1;
                  provider.setWeight = 60;
                  provider.setTempWeight = 60;
                },
                child: Column(
                  children: [
                    Opacity(
                      opacity: provider.getGender == 1 ? 1 : 0.3,
                      child: Image.asset(
                        'assets/images/intro/female.png',
                        scale: 3,
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      localize.female,
                      style: TextStyle(
                        color: provider.getGender == 1 ? Colors.blue : Colors.grey,
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
