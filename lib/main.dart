import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/provider/data_provider.dart';
import 'package:water_reminder/screens/history/history_screen.dart';
import 'package:water_reminder/screens/home/home_screen.dart';
import 'package:water_reminder/screens/settings/settings_screen.dart';
import 'package:water_reminder/widgets/build_appbar.dart';
import 'package:water_reminder/widgets/custom_tab.dart';

void main() {
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
        ));
  }
}
