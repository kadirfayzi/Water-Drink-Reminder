import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/provider/data_provider.dart';

import '../../../constants.dart';
import '../../../functions.dart';
import '../home_helpers.dart';

class RecordsColumn extends StatelessWidget {
  const RecordsColumn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<DataProvider>(
      builder: (context, provider, _) => Column(
        children: provider.getRecords
            .map(
              (record) => Column(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      highlightColor: Colors.blue.shade200,
                      splashColor: Colors.blue.shade200,
                      borderRadius: const BorderRadius.all(kRadius_5),
                      onTap: () => editOrDeleteSelectedRecordPopup(
                        context: context,
                        record: record,
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 20,
                          top: 10,
                          bottom: 10,
                        ),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(kRadius_5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(record.image, scale: 7),
                                SizedBox(width: size.width * 0.05),
                                Text(record.time.split(' ')[1]),
                              ],
                            ),
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
                                            '${provider.getCapacityUnit == 0 ? record.amount.toStringAsFixed(0) : Functions.mlToFlOz(record.amount).toStringAsFixed(1)} ',
                                      ),
                                      TextSpan(
                                        text: kCapacityUnitStrings[provider.getCapacityUnit],
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: size.width * 0.03),
                                const Icon(Icons.more_vert, size: 15),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  record != provider.getRecords.first
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 2),
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
                        )
                      : const SizedBox(),
                ],
              ),
            )
            .toList()
            .reversed
            .toList(),
      ),
    );
  }
}
