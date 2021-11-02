import 'package:flutter/material.dart';
import 'package:water_reminder/constants.dart';
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
    return Scaffold(
      appBar: const BuildAppBar(title: Text('Reminder schedule')),
      body: Scrollbar(
          child: SingleChildScrollView(
        child: Column(
          children: List.generate(
            4,
            (index) => Column(
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
                    title: buildRow(
                      size: size,
                      title: '12:30 AM',
                      switchValue: true,
                    ),
                    subtitle: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Everyday',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              7,
                              (index) => ElevatedContainer(
                                width: 40,
                                height: 40,
                                blurRadius: 2,
                                color: kPrimaryColor,
                                shape: BoxShape.rectangle,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                ),
                                child: Center(
                                  child: Text(
                                    kWeekDays[index],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(),
                          Material(
                            elevation: 2.0,
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {},
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
                                )),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(
                  indent: 10,
                  endIndent: 10,
                ),
              ],
            ),
          ),
        ),
      )),
      floatingActionButton: const ElevatedContainer(
        color: kPrimaryColor,
        padding: EdgeInsets.all(10),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildRow({
    required Size size,
    required String title,
    required bool switchValue,
  }) {
    return Container(
      height: size.height * 0.06,
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Switch(
            value: switchValue,
            onChanged: (value) => setState(() => switchValue = value),
            activeTrackColor: kSecondaryColor,
            activeColor: kPrimaryColor,
          )
        ],
      ),
    );
  }
}
