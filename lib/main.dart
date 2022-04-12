import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'constants.dart' show kPrimaryColor;
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
            const Duration(seconds: 15),
            (_) {
              provider.setNextDrinkTime = Functions.calculateNextDrinkTime(
                scheduleRecords: provider.getScheduleRecords,
              );
              Functions.removeAllRecordsIfDayChanges(provider: provider);
              Functions.removeWeekDataIfWeekChanges(provider: provider);
              Functions.resetMonthlyChartDataIfMonthChanges(provider: provider);
            },
          );

          return MaterialApp(
            title: 'Drink Water Reminder',
            theme: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              fontFamily: 'Ubuntu',
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
            home: getHome(provider.getIsInitialPrefsSet),
            // home: const WelcomeScreen(),
          );
        },
      );

  Widget getHome(bool isInitialPrefsSet) {
    switch (isInitialPrefsSet) {
      case true:
        return const Home();
      case false:
        return const WelcomeScreen();
      default:
        return const Home();
    }
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin, WidgetsBindingObserver {
  late final PageController _pageController;
  late final DataProvider _provider;

  int _selectedPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _pageController = PageController(initialPage: _selectedPage);
    _provider = Provider.of<DataProvider>(context, listen: false);
    PackageInfo.fromPlatform().then((value) => _provider.setPackageInfo = value);

    Future.delayed(Duration.zero, () {
      _provider.setNextDrinkTime =
          Functions.calculateNextDrinkTime(scheduleRecords: _provider.getScheduleRecords);
      Functions.removeAllRecordsIfDayChanges(provider: _provider);
      Functions.removeWeekDataIfWeekChanges(provider: _provider);
      Functions.resetMonthlyChartDataIfMonthChanges(provider: _provider);
      _provider.setMainStateInitialized = true;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _pageController.dispose();
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
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, size.height * 0.05),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0.5,
          backgroundColor: Colors.grey.shade50,
          title: Center(
            child: Text(
              getAppBarTitle(_selectedPage, localize),
              style: TextStyle(
                fontSize: size.width * 0.05,
                color: kPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background4.png'),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: PageView(
            controller: _pageController,
            onPageChanged: (page) => setState(() => _selectedPage = page),
            children: const [
              HomeScreen(),
              StatisticsScreen(),
              SettingsScreen(),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        currentIndex: _selectedPage,
        onTap: (page) => _pageController.animateToPage(
          page,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        ),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.water_drop),
            label: localize.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bar_chart),
            label: localize.statistics,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: localize.settings,
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Widget getSelectedPage(int page) {
    switch (page) {
      case 0:
        return const HomeScreen();
      case 1:
        return const StatisticsScreen();
      case 2:
        return const SettingsScreen();
      default:
        return const HomeScreen();
    }
  }

  String getAppBarTitle(int page, AppLocalizations localize) {
    switch (page) {
      case 0:
        return 'Drink Water Reminder';
      case 1:
        return localize.statistics;
      case 2:
        return localize.settings;
      default:
        return '';
    }
  }
}
