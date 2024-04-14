import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iot_app/logicscripts/Database/DataModel.dart';
import 'package:iot_app/pages/Concentration.dart';
import 'package:iot_app/pages/altitude.dart';
import 'package:iot_app/pages/homePage.dart';
import 'package:iot_app/pages/humidity.dart';
import 'package:iot_app/pages/loginorregister.dart';
import 'package:iot_app/pages/pressure.dart';
import 'package:iot_app/pages/raining.dart';
import 'package:iot_app/pages/settings.dart';
import 'package:iot_app/pages/temperature.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(DataModelAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IOT App',
      debugShowCheckedModeBanner: false,

      home: const LoginOrRegister(),
      routes: {
        '/homepage' : (context) => const HomePage(),
        '/loginorregister': (context) => const LoginOrRegister(),
        '/concentration' : (context) => const Concentration(),
        '/temperature' : (context) => const Temperature(),
        '/pressure' : (context) => const Pressure(),
        '/settings' : (context) => const Settings(),
        '/altitude' : (context) => const Altitude(),
        '/humidity' : (context) => const Humidity(),
        '/raining' : (context) => const Raining(),
      },
    );
  }
}

