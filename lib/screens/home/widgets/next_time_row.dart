import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../functions.dart';
import '../home_helpers.dart';

class NextTimeRow extends StatelessWidget {
  const NextTimeRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<DataProvider>(
      builder: (context, provider, _) => Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(kRadius_5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// First row
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.grey),
                    SizedBox(width: size.width * 0.04),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.nextTime,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          provider.getNextDrinkTime,
                          style: const TextStyle(
                            color: kPrimaryColor,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                /// Second row
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                '${provider.getCapacityUnit == 0 ? provider.getSelectedCup.capacity.toStringAsFixed(0) : Functions.mlToFlOz(provider.getSelectedCup.capacity).toStringAsFixed(1)} ',
                          ),
                          TextSpan(
                            text: kCapacityUnitStrings[provider.getCapacityUnit],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: size.width * 0.05),
                    provider.getRecords.isNotEmpty
                        ? IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              Icons.delete,
                              color: kPrimaryColor,
                            ),
                            onPressed: () => clearAllRecordsPopup(context: context),
                          )
                        : const SizedBox(),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Visibility(
            visible: provider.getRecords.isNotEmpty ? true : false,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 22, right: 22, top: 8),
                child: Column(
                  children: const [
                    Icon(Icons.water_drop, size: 3, color: Colors.black54),
                    SizedBox(height: 3),
                    Icon(Icons.water_drop, size: 3, color: Colors.black54),
                    SizedBox(height: 3),
                    Icon(Icons.water_drop, size: 3, color: Colors.black54),
                    SizedBox(height: 3),
                    Icon(Icons.water_drop, size: 3, color: Colors.black54),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
