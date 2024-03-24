import 'package:flutter/material.dart';
import 'package:iot_app/components/my_button.dart';
import 'package:iot_app/components/my_text_field.dart';
import 'package:iot_app/components/square_tile.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final double fontSize = isTablet ? 30 : 16;

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body:  SafeArea( // avoiding notch area
        child: Center( // centering all
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(height: isTablet ? 50: 25,), //spacing on top

              //logo
              Icon(
                Icons.lock,
                size: 100,
              ),

              // spacing below icon
              SizedBox(height: isTablet ? 50: 25,),
              
              Text(
                'Hi there! Welcome back',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 50,
                ),
                textAlign: TextAlign.center,
              ),


              SizedBox(height: isTablet ? 50: 25,),

              //username
              MyTextField(
                controller: usernameController,
                hintText: 'Username',
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
                onTap: () {},
              ),

              SizedBox(height: isTablet ? 50: 25,),

              // Other options divider
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey.shade400,
                      )
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
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


              SizedBox(height: isTablet ? 70: 25,),

              // google and other sign in options
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(imagePath: 'lib/images/IOTWiFiIcon.jpeg',),

                  SizedBox(width: isTablet? 50 : 25,),

                  SquareTile(imagePath: 'lib/images/IOTWiFiIcon.jpeg'),
                ],
              ),


              SizedBox(height: isTablet ? 50: 25,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                  Text('Not a member?', style: TextStyle(fontSize: fontSize),),
                  SizedBox(width: 4,),
                  Text('Register Now',
                  style: TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold, fontSize: fontSize,
                  ),)
                ],
              )

















            ],
          ),
        ),
      ),
    );
  }
}
