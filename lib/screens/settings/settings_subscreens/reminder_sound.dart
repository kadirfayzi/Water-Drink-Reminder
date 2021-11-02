import 'package:flutter/material.dart';
import 'package:water_reminder/constants.dart';
import 'package:water_reminder/widgets/build_appbar.dart';
import 'package:water_reminder/widgets/sliding_switch.dart';

class ReminderSound extends StatefulWidget {
  const ReminderSound({Key? key}) : super(key: key);

  @override
  _ReminderSoundState createState() => _ReminderSoundState();
}

class _ReminderSoundState extends State<ReminderSound> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const BuildAppBar(title: Text('Reminder sound')),
      body: Scrollbar(
          child: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Column(
            children: [
              const SizedBox(height: 20),
              SlidingSwitch(
                value: false,
                width: size.width * 0.4,
                height: size.height * 0.045,
                onChanged: (value) =>
                    !value ? _tabController?.animateTo(0) : _tabController?.animateTo(1),
                onTap: () {},
                onSwipe: () {},
                textLeft: 'App',
                textRight: 'Phone',
              ),
              const SizedBox(height: 25),
              SizedBox(
                height: size.height * 0.8,
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    ListView(
                      children: List.generate(
                          5,
                          (index) => Container(
                                height: size.height * 0.08,
                                decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                    color: Colors.grey,
                                    width: 0.5,
                                  )),
                                ),
                                child: buildTappableRow(
                                  title: 'Water flow',
                                ),
                              )),
                    ),
                    ListView(
                      children: List.generate(
                        10,
                        (index) => Container(
                          height: size.height * 0.08,
                          decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                              color: Colors.grey,
                              width: 0.5,
                            )),
                          ),
                          child: buildTappableRow(
                            title: 'Water flow',
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
      )),
    );
  }

  Widget buildTappableRow({
    required String title,
  }) {
    return Material(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const Icon(
                Icons.check_circle,
                color: kPrimaryColor,
                size: 25,
              )
            ],
          ),
        ),
      ),
    );
  }
}
