import 'package:flutter/material.dart';
import 'package:scheduleapp/Database/dbhelper.dart';
import 'package:scheduleapp/NotificationHandler/local_notification.dart';
import 'package:scheduleapp/Views/HomePage.dart';
import 'package:scheduleapp/Views/Lists.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.db;
  await LocalNotification().init();
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple, brightness: Brightness.dark),
          useMaterial3: true,
        ),
        home: const ListsNote());
  }
}
