import 'package:flutter/material.dart';
import 'package:iot_app/pages/loginPage.dart';
import 'package:iot_app/pages/registerPage.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {

  bool showLoginPage = true;

  void togglePage() {
    setState(() { // Causes a reload of system ui depending on the value of the variables which are dependant on it.
      showLoginPage = !showLoginPage;
    });
  }


  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginPage(loginregistertoggler: togglePage,);
    } else {
      return RegisterPage(loginregistertoggler: togglePage,);
    }
  }
}
