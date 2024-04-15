import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iot_app/components/my_button.dart';
import 'package:iot_app/components/my_text_field.dart';
import 'package:iot_app/components/square_tile.dart';

import '../logicscripts/FetchData.dart';
import '../logicscripts/GlobalData.dart';

class RegisterPage extends StatefulWidget {
  final Function()? loginregistertoggler;
  const RegisterPage({
    super.key,
    required this.loginregistertoggler,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // controllers
  final emailController = TextEditingController();
  bool _isLoading = false;



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

    void signUp() async{
      setState(() {
        _isLoading = true;
      });
      final result = await FetchData.connectionStatus();

      String email = emailController.text;

      // Check the result and call the popUp function accordingly
      // popUp(jsonEncode(result));
      if (result["error"] == "incomplete request") {
        setState(() {
          _isLoading = false;
        });
        popUpCenter("Error Making Request");
        return;
      }

      final result2 = await FetchData.register(email);

      if (result2["error"] == "duplicate") {
        setState(() {
          _isLoading = false;
        });
        popUpCenter("Email already exists");
        return;
      }


      if (result2["error"] == "failed") {
        setState(() {
          _isLoading = false;
        });
        popUpCenter("Account creation failed");
        return;
      }

      String token = result2["secret_key"];

      popUpCenter(token);

      bool save = await FetchData.writeToken(token);
      bool save2 = await FetchData.writeData("email", email);

      if(save && save2){
        setState(() {
          _isLoading = false;
        });
        // popUp('Saved successfully');
        popUpCenter(token);
        GlobalData().setEmail(email);
        GlobalData().setSecret(token);
        Navigator.pushReplacementNamed(context, '/homepage');
      } else {
        popUp('Failed Saving');
      }
    }


    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body:  SafeArea( // avoiding notch area
        child: Center( // centering all
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(height: isTablet ? 50: 20,), //spacing on top

                Container(
                  margin: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 20),
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: AutoSizeText(
                          'Design Lab IOT App',
                          style: TextStyle(fontSize: isTablet ? 50.0 : 30.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      AutoSizeText(
                        'Professor Incharge:',
                        style: TextStyle(fontSize: isTablet ? 35.0 :20.0),
                      ),
                      Center(
                        child: AutoSizeText(
                          'Professor Preetam Kumar',
                          style: TextStyle(fontSize: isTablet ? 30.0 :16.0),
                        ),
                      ),
                      AutoSizeText(
                        'Group members:',
                        style: TextStyle(fontSize: isTablet ? 35.0 : 20.0),
                      ),
                      Center(
                        child: AutoSizeText(
                          'Shaan Jijoe',
                          style: TextStyle(fontSize: isTablet ? 30.0 :16.0),
                        ),
                      ),
                      Center(
                        child: AutoSizeText(
                          'Aditya Gupta',
                          style: TextStyle(fontSize: isTablet ? 30.0 :16.0),
                        ),
                      ),
                      // SizedBox(height: 20.0),
                      // AutoSizeText(
                      //   'Professor Incharge:',
                      //   style: TextStyle(fontSize: isTablet ? 35.0 :20.0),
                      // ),
                      // Center(
                      //   child: AutoSizeText(
                      //     'Professor Preetam Kumar',
                      //     style: TextStyle(fontSize: isTablet ? 30.0 :16.0),
                      //   ),
                      // ),
                      // SizedBox(height: 20.0),
                    ],
                  ),
                ),
                // SizedBox(height: 20.0),


                //logo
                // Icon(
                //   Icons.lock,
                //   size: isTablet ? 100: 50,
                // ),
                //
                // // IconButton(onPressed: () {}, icon: Image.asset('lib/images/IOTWiFiIcon.jpeg'),
                // // style: Ico,),
                //
                // // spacing below icon
                // SizedBox(height: isTablet ? 50: 25,),
                //
                // Text(
                //   'Let\'s register',
                //   style: TextStyle(
                //     color: Colors.grey[700],
                //     fontSize: isTablet ? 50: 25,
                //   ),
                //   textAlign: TextAlign.center,
                // ),


                SizedBox(height: isTablet ? 50: 30,),

                //username
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                SizedBox(height: isTablet ? 50: 25,),



                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0),
                ),



                SizedBox(height: isTablet ? 50: 25,),


                _isLoading ?
                CircularProgressIndicator():
                MyButton(
                  message: 'Sign Up',
                  onTap: signUp,),


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


                SizedBox(height: isTablet ? 50: 25,),

                // google and other sign in options
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SquareTile(imagePath: 'lib/images/IOTWiFiIcon.jpeg',),

                    SizedBox(width: isTablet? 50 : 25,),

                    const SquareTile(imagePath: 'lib/images/IOTWiFiIcon.jpeg'),
                  ],
                ),


                SizedBox(height: isTablet ? 50: 25,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already a member?', style: TextStyle(fontSize: fontSize),),
                    const SizedBox(width: 4,),
                    GestureDetector(
                      onTap: widget.loginregistertoggler,
                      child: Text('Login',
                        style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold, fontSize: fontSize,
                        ),),
                    )
                  ],
                ),

                SizedBox(height: isTablet ? 20: 10,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
