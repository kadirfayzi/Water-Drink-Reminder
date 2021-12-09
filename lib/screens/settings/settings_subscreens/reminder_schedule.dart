import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/models/schedule_record.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/screens/settings/settings_helpers.dart';
import 'package:water_reminder/widgets/build_appbar.dart';
import 'package:water_reminder/widgets/elevated_container.dart';

class ReminderSchedule extends StatefulWidget {
  const ReminderSchedule({Key? key}) : super(key: key);

  @override
  _ReminderScheduleState createState() => _ReminderScheduleState();
}

class _ReminderScheduleState extends State<ReminderSchedule> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<DataProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: const BuildAppBar(title: Text('Reminder schedule')),
          body: Scrollbar(
              child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                provider.getScheduleRecords.length,
                (index) {
                  return Column(
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                          splashColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          childrenPadding: const EdgeInsets.all(10),
                          backgroundColor: Colors.grey[200],
                          collapsedIconColor: Colors.grey,
                          title: Container(
                            height: size.height * 0.06,
                            width: size.width,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${provider.getScheduleRecords[index].time}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                CupertinoSwitch(
                                  value: provider.getScheduleRecords[index].isSet,
                                  onChanged: (isSet) => provider.editScheduleRecord(
                                      index,
                                      ScheduleRecord(
                                          time: provider.getScheduleRecords[index].time,
                                          isSet: isSet)),
                                  activeColor: kPrimaryColor,
                                )
                              ],
                            ),
                          ),
                          children: [
                            Material(
                              elevation: 2.0,
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () => provider.deleteScheduleRecord = index,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  width: size.width,
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: Colors.red[800],
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        indent: 10,
                        endIndent: 10,
                      ),
                    ],
                  );
                },
              ),
            ),
          )),
          floatingActionButton: ElevatedContainer(
            color: kPrimaryColor,
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
                onTap: () => setTimePopup(
                      context: context,
                      provider: provider,
                      size: size,
                    ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 35,
                )),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
