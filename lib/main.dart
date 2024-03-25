import 'package:flutter/material.dart';
// import 'package:iot_app/pages/authPage.dart';
import 'package:iot_app/pages/homePage.dart';
// import 'package:iot_app/pages/loginPage.dart';
import 'package:iot_app/pages/loginorregister.dart';

void main() {
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
        '/homepage' : (context) => HomePage(),
      },
    );
  }
}

