import 'package:flutter/material.dart';
import 'package:iot_app/logicscripts/GlobalData.dart';

import '../components/back_button.dart';
import '../components/rounded_tab.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    String email = GlobalData().email!;
    String key = GlobalData().secret_key!;
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final double fontSize = isTablet ? 30 : 16;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // backgroundColor: Colors.white70,
      appBar: AppBar(
        leading: const BackButtonWidget(),
      ),
      body:  SafeArea( // avoiding notch area
        child: Center( // centering all
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Padding(
                  padding: EdgeInsets.symmetric(vertical: isTablet ? 30.0 : 15.0, horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                          Text(
                            "Home",
                            style: TextStyle(fontSize: isTablet ? 60 : 30, fontWeight: FontWeight.bold),
                          ),
                        ],


                  ),
                ),

                SizedBox(height: isTablet ? 50: 25,), //spacing on top


                // SizedBox(height: 50),
                RoundedTab(text: 'Email: $email', width: screenWidth * 0.8, height: isTablet ? 70.0 : 50.0 ,fontSize: isTablet ? 30.0 : 20.0,),
                // SizedBox(height: 10),
                // RoundedTab(text: 'Secret Key: ' + key, width: screenWidth * 0.8, height: 50,),
                SizedBox(height: isTablet ? 50 : 30),

                RoundedTab(text: 'Key: $key', width: screenWidth * 0.8, height: isTablet ? 70.0 : 50.0 ,fontSize: isTablet ? 30.0 : 13.0,),
                // SizedBox(height: 10),
                // RoundedTab(text: 'Secret Key: ' + key, width: screenWidth * 0.8, height: 50,),
                SizedBox(height: isTablet ? 50 : 30),






              ],
            ),
          ),
        ),
      ),
    );
  }
}
