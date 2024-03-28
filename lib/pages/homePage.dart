import 'package:flutter/material.dart';
import 'package:iot_app/components/my_button.dart';
import 'package:iot_app/components/rounded_tab.dart';

class HomePage extends StatelessWidget {

  const HomePage({super.key});

  // parameters : Concentration, Temperature, Pressure, Altitude, Humidity, Raining/Not Raining


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    // final double fontSize = isTablet ? 30 : 16;
    double tabwidth = screenWidth * 0.4;
    double tabheight = isTablet ? 200 : 100;
    // final double tabwidth = 300;
    // final double tabheight = 200;
    return Scaffold(
        // appBar: AppBar(
        //   title: Row(
        //     children: [
        //       // Text('back'),
        //       Spacer(), // Empty space to push email and secret key to the right
        //     ],
        //   ),
        // ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
            
                  Padding(
                    // padding: EdgeInsets.all(30.0),
                    padding: EdgeInsets.symmetric(vertical: isTablet ? 30.0 : 15.0, horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Home", style: TextStyle(fontSize: isTablet ?  60 : 30, fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
            
            
                  // SizedBox(height: 50),
                  RoundedTab(text: 'Email', width: screenWidth * 0.8, height: 50,),
                  SizedBox(height: 10),
                  RoundedTab(text: 'Secret Key', width: screenWidth * 0.8, height: 50,),
                  SizedBox(height: isTablet ? 50 : 30),
            
            
                  // SizedBox(height: 50,),
                  //
                  // Center(
                  //   child: Row(
                  //     children: [
                  //       Container(
                  //         padding: const EdgeInsets.all(25),
                  //         margin: EdgeInsets.symmetric(horizontal: 10),
                  //         decoration: BoxDecoration(
                  //           color: Colors.black,
                  //           borderRadius: BorderRadius.circular (10),
                  //         ), // BoxDecoration child: const Center(
                  //         child: const  Center(
                  //           child: Text(
                  //             'Air Quality',
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontWeight: FontWeight.bold,
                  //               fontSize: 30,
                  //             ), // TextStyle
                  //           ),
                  //         ), // Text ), // Center
                  //       ),
                  //
                  //       Container(
                  //         padding: const EdgeInsets.all(25),
                  //         margin: EdgeInsets.symmetric(horizontal: 10),
                  //         decoration: BoxDecoration(
                  //           color: Colors.black,
                  //           borderRadius: BorderRadius.circular (10),
                  //         ), // BoxDecoration child: const Center(
                  //         child: const  Center(
                  //           child: Text(
                  //             'Air Quality',
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontWeight: FontWeight.bold,
                  //               fontSize: 30,
                  //             ), // TextStyle
                  //           ),
                  //         ), // Text ), // Center
                  //       ),
                  //     ],
                  //   ),
                  // ),
            
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RoundedTab(text: 'Concentration', height: tabheight, width: tabwidth,),
                      RoundedTab(text: 'Temperature', height: tabheight, width: tabwidth,),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RoundedTab(text: 'Pressure', height: tabheight, width: tabwidth,),
                      RoundedTab(text: 'Altitude', height: tabheight, width: tabwidth,),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RoundedTab(text: 'Humidity', height: tabheight, width: tabwidth,),
                      RoundedTab(text: 'Raining/Not Raining', height: tabheight, width: tabwidth,),
                    ],
                  ),
            
            
                  // Text("HomePage", style: TextStyle(fontSize: 40),),
            
                  SizedBox(height: isTablet ? 50 : 30,),
            
                  MyButton(onTap: () {}, message: 'Log Out'),
          
                  SizedBox(height: 20),
            
                ],
              ),
            ),
          ),
        ),
    );
  }
}
