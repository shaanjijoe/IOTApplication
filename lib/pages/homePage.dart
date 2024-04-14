import 'package:flutter/material.dart';
import 'package:iot_app/components/my_button.dart';
import 'package:iot_app/components/rounded_tab.dart';
import 'package:iot_app/logicscripts/FetchData.dart';


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


    void popUp(String message) {
      final snackBar = SnackBar(
        content: Text(message),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    Map<String, dynamic>? validateAndConvertParameters(Map<String, dynamic> item) {
      try {
        // List of required keys
        final requiredKeys = ['Altitude', 'Concentration', 'Humidity', 'Pressure', 'Temperature', 'Raining'];

        // Check if any required key is missing
        if (requiredKeys.any((key) => !item.containsKey(key))) {
          return null;
        }

        // Create a new map to avoid modifying the original
        Map<String, dynamic> newItem = Map<String, dynamic>.from(item);

        // Convert each parameter
        bool check = false;
        newItem.forEach((key, value) {
          if (value is num) {
            newItem[key] = value.toDouble();
          } else if (key == 'Raining' && value is int) {
            newItem[key] = value == 1;
          } else if(key == 'timestamp') {
            try {
              DateTime timestamp = DateTime.parse(value);
              newItem[key] = timestamp;
            } catch (e) {
              // newItem = null; // Invalid timestamp format
              check = true;
            }

          } else {
            check = true;
          }
        });

        if(check == true){
          return null;
        }

        // All parameters validated and converted successfully
        return newItem;
      } catch (e) {
        // Exception occurred during validation/conversion
        return null;
      }
    }

    // bool processor(dynamic jsonData){
    //   // Check if 'Altitude' field exists
    //   double Altitude = 0.0;
    //   String timestamp = "";
    //   if (jsonData.containsKey('Altitude')) {
    //     // Check if 'Altitude' is an integer
    //     if (jsonData['Altitude'] is int) {
    //       // Convert 'Altitude' to double
    //       Altitude = jsonData['Altitude'].toDouble();
    //       // print('Altitude (converted to double): $Altitude');
    //     } else if (jsonData['Altitude'] is double) {
    //       Altitude = jsonData['Altitude'];
    //       // If 'Altitude' is already a double, no need to convert
    //       // print('Altitude: ${jsonData['Altitude']}');
    //     } else {
    //       return null;
    //     }
    //   } else {
    //     // print('Altitude not found');
    //     return null;
    //   }
    //
    //   // Check if 'timestamp' field exists
    //   if (jsonData.containsKey('timestamp')) {
    //     // Convert 'timestamp' to string
    //     timestamp = jsonData['timestamp'].toString();
    //     // print('Timestamp (converted to string): $timestamp');
    //   } else {
    //     return null;
    //     // print('Timestamp not found');
    //   }
    //
    //   return true;
    //
    // }


    void getData() async {

      var dat = await FetchData.readInfo();
      // print(dat.length);
      DateTime? latest;
      if(dat.isNotEmpty){
        latest = dat[dat.length-1].timestamp;
      }

      // print(latest);


      dynamic data = await FetchData.fetchInfo(email, key) ;
      List<dynamic>? lst = data['data'];

      if(lst==null){
        return;
      }

      // print(lst.toString());
      // return;


      // print(lst == null);
      for(var item2 in lst) {
        print(item2.toString());
        // continue;

        if(!item2.containsKey('timestamp')){
          continue;
        } else{
          try{
            DateTime.parse(item2['timestamp']);
          } catch (e){
            continue;
          }
        }

        DateTime timestamp = DateTime.parse(item2['timestamp']);
        double altitude, concentration, humidity, pressure,  temperature;
        bool rain;
        dynamic item = validateAndConvertParameters(item2);
        if(item == null){
          return;
        }
        altitude = item['Altitude'];
        concentration = item['Concentration'];
        humidity = item['Humidity'];
        pressure = item['Pressure'];
        temperature = item['Temperature'];
        rain = item['Raining'] == 1;
        // print(rain);
        // print(concentration);


        if(latest == null){
          latest = timestamp;
            await FetchData.insertInfo(altitude, concentration, humidity, pressure, rain, temperature, timestamp);
        }else {
          if(timestamp.isAfter(latest!)){
            latest = timestamp;
            await FetchData.insertInfo(altitude, concentration, humidity, pressure, rain, temperature, timestamp);
          }
        }

        // var dat2 = await FetchData.readInfo();

        // print(dat2.length);


      }

      popUp("Latest Data: " + latest.toString());

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
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white, // Adjust the color as needed
                            border: Border.all(color: Colors.grey.shade800, width: 2),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: getData,
                                icon: Icon(Icons.sync),
                                iconSize: isTablet ? 30 : 20, // Adjust the size based on the device type
                                color: Colors.black, // Adjust the icon color as needed
                                tooltip: 'Sync Data',
                              ),

                              SizedBox(width: 10,),
                              IconButton(
                                onPressed: () {
                                  // Navigate to the settings page
                                  Navigator.pushNamed(context, '/settings');
                                },
                                icon: Icon(Icons.settings),
                                iconSize: isTablet ? 30 : 20,
                                color: Colors.black,
                                tooltip: 'Settings',
                              ),

                            ],
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
                      GestureDetector(onTap: () {Navigator.pushNamed(context, '/pressure');}  ,child: RoundedTab(text: 'Pressure', height: tabheight, width: tabwidth,fontSize: isTablet ? 30.0 : 20.0,)),
                      GestureDetector(onTap: () {Navigator.pushNamed(context, '/altitude');}  ,child: RoundedTab(text: 'Altitude', height: tabheight, width: tabwidth,fontSize: isTablet ? 30.0 : 20.0,)),
                    ],
                  ),
                  SizedBox(height: isTablet ? 40 : 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(onTap: () {Navigator.pushNamed(context, '/humidity');}  ,child: RoundedTab(text: 'Humidity', height: tabheight, width: tabwidth,fontSize: isTablet ? 30.0 : 20.0,)),
                      GestureDetector(onTap: () {
                        Navigator.pushNamed(context, '/raining');
                        }  ,child: RoundedTab(text: 'Rain', height: tabheight, width: tabwidth,fontSize: isTablet ? 30.0 : 20.0,)),
                    ],
                  ),


                  // Text("HomePage", style: TextStyle(fontSize: 40),),

                  SizedBox(height: isTablet ? 60 : 30,),

                  MyButton(
                      onTap: logout,
                      message: 'Log Out'),

                  const SizedBox(height: 20),

                ],
              ),
            ),
          ),
        ),
    );
  }
}
