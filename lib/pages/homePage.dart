import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iot_app/components/my_button.dart';
import 'package:iot_app/components/rounded_tab.dart';
import 'package:iot_app/logicscripts/FetchData.dart';

import '../components/my_chart.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  void initState() {
    super.initState();
    // Call the function when the widget is first created
    setEmailAndKey();

    // getData();
  }

  String email ="";
  String key ="";

  void setEmailAndKey() async {
    // String? key2 = await FetchData.checkToken();
    String? email2 = await FetchData.readData("email");
    String? key2 = await FetchData.checkToken();

    if(email2 == null) {
      email = "";
    } else {
      email = email2;
    }

    if(key2==null){
      key = "";
    } else {
      key = key2;
    }

    setState(() {
      email = email;
      key = key;
    });
  }

  // late Map<String,List<dynamic>> graph;
  // late Map<String,List<dynamic>> stats;
  // List<String> params = ['Concentration', 'Temperature', 'Pressure', 'Altitude', 'Humidity', 'Raining'];





  // parameters : Concentration, Temperature, Pressure, Altitude, Humidity, Raining/Not Raining
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    // final double fontSize = isTablet ? 30 : 16;
    double tabwidth = screenWidth * 0.4;
    double tabheight = isTablet ? 200 : 120;
    // final double tabwidth = 300;
    // final double tabheight = 200;

    void getData() async {

      var dat = await FetchData.readInfo();
      // print(dat.length);
      DateTime? latest = null;
      if(dat.length>0){
        latest = dat[dat.length-1].timestamp;
      }

      // print(latest);


      dynamic data = await FetchData.fetchInfo(email, key) ;
      List<dynamic>? lst = data['data'];

      if(lst==null){
        return;
      }


      // print(lst == null);
      for(var item in lst) {
        DateTime timestamp = DateTime.parse(item['timestamp']);
        double altitude, concentration, humidity, pressure,  temperature;
        bool rain;
        altitude = item['Altitude'];
        concentration = item['Concentration'];
        humidity = item['Humidity'];
        pressure = item['Pressure'];
        temperature = item['Temperature'];
        rain = item['Raining'] == 1;
        // print(rain);
        // print(concentration);


        if(latest == null){
            await FetchData.insertInfo(altitude, concentration, humidity, pressure, rain, temperature, timestamp);
        }else {
          if(timestamp.isAfter(latest!)){
            await FetchData.insertInfo(altitude, concentration, humidity, pressure, rain, temperature, timestamp);
          }
        }

        // var dat2 = await FetchData.readInfo();

        // print(dat2.length);


      }

      // for(var item in lst) {
      //
      //   for( var param in params) {
      //
      //     graph[param]?.add(Pair(item['timestamp'], item[param]));
      //     stats[param]?.add(item[param]);
      //
      //   }
      //   // print(item['Concentration']);
      //   // dataList.add(Pair(item['timestamp'], item['Concentration']));
      //   // randomData.add(item['Concentration']);
      // }
      //
      //
      // for( var param in params) {
      //   for( var item in stats[param]!){
      //     print(item.toString());
      //   }
      // }

    }


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

    void popUp(String message) {
      final snackBar = SnackBar(
        content: Text(message),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    void logout () async {
      bool save = await FetchData.writeData('email', null);
      bool save2 = await FetchData.writeData('token', null);

      Navigator.pushReplacementNamed(context, '/loginorregister');
    }



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
                    padding: EdgeInsets.symmetric(vertical: isTablet ? 30.0 : 15.0, horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Home",
                              style: TextStyle(fontSize: isTablet ? 60 : 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white, // Adjust the color as needed
                            border: Border.all(color: Colors.grey.shade800, width: 2),
                          ),
                          child: IconButton(
                            onPressed: getData,
                            icon: Icon(Icons.sync),
                            iconSize: isTablet ? 40 : 20, // Adjust the size based on the device type
                            color: Colors.black, // Adjust the icon color as needed
                            tooltip: 'Sync Data',
                          ),
                        ),
                      ],
                    ),
                  ),



                  // SizedBox(height: 50),
                  RoundedTab(text: 'Email: $email', width: screenWidth * 0.8, height: isTablet ? 70.0 : 50.0 ,fontSize: isTablet ? 30.0 : 20.0,),
                  // SizedBox(height: 10),
                  // RoundedTab(text: 'Secret Key: ' + key, width: screenWidth * 0.8, height: 50,),
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
                      GestureDetector(onTap: () {Navigator.pushNamed(context, '/concentration');} ,child: RoundedTab(text: 'Concentration', height: tabheight, width: tabwidth,fontSize: isTablet ? 30.0 : 20.0,)),
                      GestureDetector(onTap: () {Navigator.pushNamed(context, '/temperature');}, child: RoundedTab(text: 'Temperature', height: tabheight, width: tabwidth,fontSize: isTablet ? 30.0 : 20.0,)),
                    ],
                  ),
                  SizedBox(height: isTablet ? 40 : 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RoundedTab(text: 'Pressure', height: tabheight, width: tabwidth,fontSize: isTablet ? 30.0 : 20.0,),
                      RoundedTab(text: 'Altitude', height: tabheight, width: tabwidth,fontSize: isTablet ? 30.0 : 20.0,),
                    ],
                  ),
                  SizedBox(height: isTablet ? 40 : 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RoundedTab(text: 'Humidity', height: tabheight, width: tabwidth,fontSize: isTablet ? 30.0 : 20.0,),
                      RoundedTab(text: 'Raining/Not Raining', height: tabheight, width: tabwidth,fontSize: isTablet ? 30.0 : 20.0,),
                    ],
                  ),


                  // Text("HomePage", style: TextStyle(fontSize: 40),),

                  SizedBox(height: isTablet ? 60 : 30,),

                  MyButton(
                      onTap: logout,
                      message: 'Log Out'),

                  SizedBox(height: 20),

                ],
              ),
            ),
          ),
        ),
    );
  }
}
