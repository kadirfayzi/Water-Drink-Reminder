import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/models/schedule_record.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/screens/settings/settings_helpers.dart';
import 'package:water_reminder/widgets/build_appbar.dart';
import 'package:water_reminder/widgets/elevated_container.dart';

import '../../../services/notification_service.dart';

class ReminderSchedule extends StatefulWidget {
  const ReminderSchedule({Key? key}) : super(key: key);

  @override
  _ReminderScheduleState createState() => _ReminderScheduleState();
}

class _ReminderScheduleState extends State<ReminderSchedule> {
  final _notificationHelper = NotificationHelper();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<DataProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: const BuildAppBar(title: Text('Reminder schedule')),
          body: Scrollbar(
            child: SingleChildScrollView(
              child: SizedBox(
                height: size.height * 0.8,
                child: ListView(
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
                                      onChanged: (isSet) {
                                        /// set or reset notification
                                        if (!isSet) {
                                          _notificationHelper
                                              .cancel(provider.getScheduleRecords[index].id);
                                        } else {
                                          _notificationHelper.scheduledNotification(
                                            hour: int.parse(provider.getScheduleRecords[index].time
                                                .split(":")[0]),
                                            minutes: int.parse(provider
                                                .getScheduleRecords[index].time
                                                .split(":")[1]),
                                            id: provider.getScheduleRecords[index].id,
                                            sound: 'sound${provider.getSoundValue}',
                                          );
                                        }

                                        /// Edit schedule record
                                        provider.editScheduleRecord(
                                          index,
                                          ScheduleRecord(
                                            id: provider.getScheduleRecords[index].id,
                                            time: provider.getScheduleRecords[index].time,
                                            isSet: isSet,
                                          ),
                                        );
                                      },
                                      activeColor: kPrimaryColor,
                                    )
                                  ],
                                ),
                              ),
                              children: [
                                Material(
                                  elevation: 2.0,
                                  borderRadius: const BorderRadius.all(kRadius_10),
                                  child: InkWell(
                                    borderRadius: const BorderRadius.all(kRadius_10),
                                    onTap: () {
                                      /// Delete schedule record and notification
                                      _notificationHelper
                                          .cancel(provider.getScheduleRecords[index].id);
                                      provider.deleteScheduleRecord = index;
                                    },
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
                          const Divider(indent: 10, endIndent: 10),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          /// Add new schedule record
          floatingActionButton: ElevatedContainer(
            color: kPrimaryColor,
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () => setTimePopup(
                context: context,
                provider: provider,
                size: size,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
