import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:water_reminder/widgets/glassmorphism.dart';
import 'models/bed_time.dart';
import 'models/chart_data.dart';
import 'models/cup.dart';
import 'models/record.dart';
import 'models/schedule_record.dart';
import 'models/wakeup_time.dart';
import 'models/week_data.dart';
import 'provider/data_provider.dart';
import 'screens/statistics/statistics_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/initial/welcome_screen.dart';
import 'services/notification_service.dart';
import 'widgets/build_appbar.dart';
import 'widgets/custom_tab.dart';
import 'functions.dart';
import 'l10n/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Device orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
  Hive.registerAdapter(WeekDataAdapter());
  await Hive.openBox<WeekData>('weekData');
  await Hive.openBox('sound');
  await Hive.openBox('weightUnit');
  await Hive.openBox('capacityUnit');
  await Hive.openBox('intakeGoalAmount');
  await Hive.openBox('gender');
  await Hive.openBox('weight');
  await Hive.openBox('drankAmount');
  await Hive.openBox('langCode');
  await Hive.openBox('isInitialPrefsSet');
  await Hive.openBox('appLastUseDateTime');

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

  Timer? timer;
  @override
  void initState() {
    super.initState();
    _notificationHelper = NotificationHelper();
    _notificationHelper.initializeNotification();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Consumer<DataProvider>(
        builder: (context, provider, _) {
          timer?.cancel();
          timer = Timer.periodic(
            const Duration(seconds: 10),
            (_) {
              provider.setNextDrinkTime = calculateNextDrinkTime(
                scheduleRecords: provider.getScheduleRecords,
              );
              removeAllRecordsIfDayChanges(provider: provider);
              removeWeekDataIfWeekChanges(provider: provider);
              resetMonthlyChartDataIfMonthChanges(provider: provider);
            },
          );

          return MaterialApp(
            title: 'Water Drink Reminder',
            theme: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              // primaryColor: kPrimaryColor,
            ),

            debugShowCheckedModeBanner: false,
            locale: provider.getIsInitialPrefsSet
                ? Locale(provider.getLangCode)
                : Locale(window.locale.languageCode),
            supportedLocales: L10n.all,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,

              ///comment off this line if there is a right to left language like arabic or persian
              // GlobalWidgetsLocalizations.delegate,
            ],
            home: provider.getIsInitialPrefsSet ? const Home() : const WelcomeScreen(),
            // home: const WelcomeScreen(),
          );
        },
      );
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final TabController _tabController;
  late final DataProvider _provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _tabController = TabController(length: 3, vsync: this);
    _provider = Provider.of<DataProvider>(context, listen: false);

    Future.delayed(Duration.zero, () {
      _provider.setNextDrinkTime =
          calculateNextDrinkTime(scheduleRecords: _provider.getScheduleRecords);
      removeAllRecordsIfDayChanges(provider: _provider);
      removeWeekDataIfWeekChanges(provider: _provider);
      resetMonthlyChartDataIfMonthChanges(provider: _provider);
      _provider.setMainStateInitialized = true;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        Navigator.popUntil(context, (route) => route.isFirst);
        break;
      case AppLifecycleState.inactive:
        Navigator.popUntil(context, (route) => route.isFirst);
        break;
      case AppLifecycleState.paused:
        Navigator.popUntil(context, (route) => route.isFirst);
        break;
      case AppLifecycleState.detached:
        Navigator.popUntil(context, (route) => route.isFirst);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localize = AppLocalizations.of(context)!;
    final appBar = BuildAppBar(
      bottom: TabBar(
        indicatorColor: Colors.black,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black54,
        controller: _tabController,
        tabs: [
          CustomTab(icon: Icons.water_drop, title: localize.home),
          CustomTab(icon: Icons.bar_chart, title: localize.statistics),
          CustomTab(icon: Icons.settings, title: localize.settings),
        ],
      ),
    );

    final double appBarHeight =
        Platform.isAndroid ? appBar.preferredSize.height * 1.4 : appBar.preferredSize.height * 1.7;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: GlassmorphicContainer(
          blur: 25,
          borderRadius: BorderRadius.zero,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
            stops: const [0.1, 1],
          ),
          child: Padding(
            padding: EdgeInsets.only(top: appBarHeight),
            child: TabBarView(
              controller: _tabController,
              children: const [
                HomeScreen(),
                StatisticsScreen(),
                SettingsScreen(),
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
