import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:water_reminder/models/bed_time.dart';
import 'package:water_reminder/models/chart_data.dart';
import 'package:water_reminder/models/cup.dart';
import 'package:water_reminder/models/record.dart';
import 'package:water_reminder/models/schedule_record.dart';
import 'package:water_reminder/models/wakeup_time.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/screens/statistics/statistics_screen.dart';
import 'package:water_reminder/screens/home/home_screen.dart';
import 'package:water_reminder/screens/settings/settings_screen.dart';
import 'screens/initial/welcome_screen.dart';
import 'package:water_reminder/services/notification_service.dart';
import 'package:water_reminder/widgets/build_appbar.dart';
import 'package:water_reminder/widgets/custom_tab.dart';
import 'functions.dart';
import 'l10n/l10n.dart';

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
  Hive.registerAdapter(WakeupTimeAdapter());
  await Hive.openBox<WakeupTime>('wakeupTime');
  Hive.registerAdapter(BedTimeAdapter());
  await Hive.openBox<BedTime>('bedTime');
  await Hive.openBox('sound');
  await Hive.openBox('weightUnit');
  await Hive.openBox('capacityUnit');
  await Hive.openBox('intakeGoalAmount');
  await Hive.openBox('gender');
  await Hive.openBox('weight');
  await Hive.openBox('drunkAmount');
  await Hive.openBox('langCode');
  await Hive.openBox('isInitialPrefsSet');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
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

class _MyAppState extends State<MyApp> {
  late final NotificationHelper _notificationHelper;

  @override
  void initState() {
    super.initState();
    _notificationHelper = NotificationHelper();
    _notificationHelper.initializeNotification();
    resetMonthlyChartDataIfMonthChanges(provider: DataProvider());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, provider, _) => MaterialApp(
        title: 'Water Drink Reminder',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        debugShowCheckedModeBanner: false,
        locale: provider.getIsInitialPrefsSet
            ? Locale(provider.getLangCode)
            : Locale(ui.window.locale.languageCode),
        supportedLocales: L10n.all,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,

          ///comment off this line if there is a right to left language like arabic or persian
          // GlobalWidgetsLocalizations.delegate,
        ],
        home: provider.getIsInitialPrefsSet ? const Home() : const WelcomeScreen(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: BuildAppBar(
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              CustomTab(
                icon: Icons.water,
                title: AppLocalizations.of(context)!.home,
              ),
              CustomTab(
                icon: Icons.history,
                title: AppLocalizations.of(context)!.statistics,
              ),
              CustomTab(
                icon: Icons.settings,
                title: AppLocalizations.of(context)!.settings,
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            HomeScreen(),
            StatisticsScreen(),
            SettingsScreen(),
          ],
        ),
        resizeToAvoidBottomInset: true,
      );
}
