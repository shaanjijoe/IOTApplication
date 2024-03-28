import 'dart:convert';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_app/components/my_button.dart';
import 'package:iot_app/components/my_text_field.dart';
import 'package:iot_app/components/square_tile.dart';

import '../logicscripts/FetchData.dart';

class LoginPage extends StatefulWidget {
   final Function()? loginregistertoggler;
   const LoginPage({
      super.key,
     required this.loginregistertoggler,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final double fontSize = isTablet ? 30 : 16;

    void popUp(String message) {
      final snackBar = SnackBar(
        content: Text(message),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    // wrong email message popup
    void popUpCenter (String message) {
      showDialog(
        context: context,
        builder: (context) {
        return AlertDialog(
            backgroundColor: Colors.grey.shade600,
            title: Center(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ), // Text ), // Center
            ),
        );
        },
      );// AlertDialog
    }

    void signIn() async{
      final result = await FetchData.connectionStatus();

      // Check the result and call the popUp function accordingly
      // popUp(jsonEncode(result));
      if (result["error"] == "incomplete request") {
        popUpCenter("Error Making Request");
        return;
      }

      String email = emailController.text;
      String password = passwordController.text;

      final result2 = await FetchData.login(email, password);

      if (result2["error"] == "incomplete request") {
        popUpCenter("Parameter Absent");
        return;
      }


      // popUp(jsonEncode(result2));
      // return;

      if (result2["status"] == false) {
        // popUp(jsonEncode(result2));
        // return;
        if(result2["error"]=="404"){
          popUpCenter("Email not registered");
        } else if (result2["error"]=="401"){
          popUpCenter("Incorrect Password");
        } else {
          popUpCenter(result2["error"]);
        }
        return;
      }


      // popUpCenter(password);

      bool save = await FetchData.writeToken(password);
      bool save2 = await FetchData.writeData("email", email);

      if(save && save2){
        // popUp('Saved successfully');
        popUpCenter(password);
        Navigator.pushReplacementNamed(context, '/homepage');
      } else {
        popUp('Failed Saving');
      }

      // Navigator.pushReplacementNamed(context, '/homepage');
    }


    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body:  SafeArea( // avoiding notch area
        child: Center( // centering all
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(height: isTablet ? 50: 25,), //spacing on top

                //logo
                 Icon(
                  Icons.lock,
                  size: isTablet ? 100: 50,
                ),

                // IconButton(onPressed: () {}, icon: Image.asset('lib/images/IOTWiFiIcon.jpeg'),
                // style: Ico,),

                // spacing below icon
                SizedBox(height: isTablet ? 50: 25,),

                Text(
                  'Hi there! Welcome back',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: isTablet ? 50: 25,
                  ),
                  textAlign: TextAlign.center,
                ),


                SizedBox(height: isTablet ? 50: 25,),

                //username
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                SizedBox(height: isTablet ? 50: 25,),

                //password
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                SizedBox(height: isTablet ? 50: 25,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey.shade600,
                        fontSize: fontSize),
                      ),
                    ],
                  ),
                ),



                SizedBox(height: isTablet ? 50: 25,),


                MyButton(
                  message: 'Sign In',
                  onTap: signIn,),


                SizedBox(height: isTablet ? 50: 25,),

                // Other options divider
                Padding(
                  padding:  const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey.shade400,
                        )
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          'Or continue With',
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: isTablet ? 30 : 16,
                          ),
                        ),
                      ),


                      Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey.shade400,
                          )
                      ),
                    ],
                  ),
                ),


                SizedBox(height: isTablet ? 30: 20,),

                // google and other sign in options
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SquareTile(imagePath: 'lib/images/IOTWiFiIcon.jpeg',),

                    SizedBox(width: isTablet? 50 : 25,),

                    const SquareTile(imagePath: 'lib/images/IOTWiFiIcon.jpeg'),
                  ],
                ),


                SizedBox(height: isTablet ? 30: 25,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                    Text('Not a member?', style: TextStyle(fontSize: fontSize),),
                    const SizedBox(width: 4,),
                    GestureDetector(
                      onTap: widget.loginregistertoggler,
                      child: Text('Register Now',
                      style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold, fontSize: fontSize,
                      ),),
                    )
                  ],
                )


              ],
            ),
          ),
        ),
      ),
    );
  }
}
