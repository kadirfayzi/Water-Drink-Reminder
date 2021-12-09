import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/models/bed_time.dart';
import 'package:water_reminder/models/chart_data.dart';
import 'package:water_reminder/models/cup.dart';
import 'package:water_reminder/models/drunk_amount.dart';
import 'package:water_reminder/models/gender.dart';
import 'package:water_reminder/models/intake_goal.dart';
import 'package:water_reminder/models/record.dart';
import 'package:water_reminder/models/schedule_record.dart';
import 'package:water_reminder/models/sound.dart';
import 'package:water_reminder/models/unit.dart';
import 'package:water_reminder/models/wakeup_time.dart';
import 'package:water_reminder/models/weight.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/screens/history/history_screen.dart';
import 'package:water_reminder/screens/home/home_screen.dart';
import 'package:water_reminder/screens/settings/settings_screen.dart';
import 'package:water_reminder/widgets/build_appbar.dart';
import 'package:water_reminder/widgets/custom_tab.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(CupAdapter());
  await Hive.openBox<Cup>('cups');
  Hive.registerAdapter(RecordAdapter());
  await Hive.openBox<Record>('records');
  Hive.registerAdapter(ChartDataAdapter());
  await Hive.openBox<ChartData>('chartData');
  Hive.registerAdapter(ScheduleRecordAdapter());
  await Hive.openBox<ScheduleRecord>('scheduleRecords');
  Hive.registerAdapter(SoundAdapter());
  await Hive.openBox<Sound>('sound');
  Hive.registerAdapter(UnitAdapter());
  await Hive.openBox<Unit>('units');
  Hive.registerAdapter(IntakeGoalAdapter());
  await Hive.openBox<IntakeGoal>('intakeGoal');
  Hive.registerAdapter(GenderAdapter());
  await Hive.openBox<Gender>('gender');
  Hive.registerAdapter(WeightAdapter());
  await Hive.openBox<Weight>('weight');
  Hive.registerAdapter(WakeupTimeAdapter());
  await Hive.openBox<WakeupTime>('wakeupTime');
  Hive.registerAdapter(BedTimeAdapter());
  await Hive.openBox<BedTime>('bedTime');
  Hive.registerAdapter(DrunkAmountAdapter());
  await Hive.openBox<DrunkAmount>('drunkAmount');

  /// /// /// /// /// /// ///
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DataProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: BuildAppBar(
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              CustomTab(
                icon: Icons.water,
                title: 'Home',
              ),
              CustomTab(
                icon: Icons.history,
                title: 'History',
              ),
              CustomTab(
                icon: Icons.settings,
                title: 'Settings',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [HomeScreen(), HistoryScreen(), SettingsScreen()],
        ),
      ),
    );
  }
}
