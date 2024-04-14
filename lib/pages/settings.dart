import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import 'package:iot_app/logicscripts/Database/DataModel.dart';
import 'package:iot_app/logicscripts/FetchData.dart';
import 'package:iot_app/logicscripts/GlobalData.dart';
import '../components/back_button.dart';
import '../components/rounded_tab.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String email = GlobalData().email!;
  String key = GlobalData().secret_key!;
  String latestTimestamp = "No data"; // Placeholder for latest timestamp
  late IO.Socket socket;
  bool socketConnected = false;
  // DataModel(20.0, 30.0, 30.0, 200.0, true, 100.0, DateTime.now()),
  List<DataModel> dataList = [
  ];


  @override
  void initState() {
    super.initState();
    setTime();
    connectToServer();
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  void setConnect(){
    print("Got here");
    socketConnected = true;
    print(socketConnected);
  }

  void stopConnect(){
    print("Outta here");
    socketConnected = false;
    print(socketConnected);
  }

  DataModel? validateAndConvertParameters(Map<String, dynamic> item) {
    try {
      // List of required keys
      final requiredKeys = ['Altitude', 'Concentration', 'Humidity', 'Pressure', 'Temperature', 'Raining','timestamp'];


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
      return DataModel(newItem['Altitude'], newItem['Concentration'], newItem['Humidity'], newItem['Pressure'], newItem['Raining']==1, newItem['Temperature'], newItem['timestamp']);
    } catch (e) {
      // Exception occurred during validation/conversion
      print(e);
      return null;
    }
  }

  void connectToServer() {
    String? email = GlobalData().email;
    String? authorization = GlobalData().secret_key;
    try {
      socket = IO.io('https://fast-api-sample-9b2d.onrender.com', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'extraHeaders': {
          'EMAIL': '$email',
          'AUTHORIZATION': '$authorization',
        },
      });

      socket.connect();

      socket.on('connect', (_) {
        print('connect: ${socket.id}');
        setConnect();
      });

      socket.on('disconnect', (_) {
        print('disconnect');
        stopConnect();
      });

      socket.on('data-post', (data) {
        // print(data.toString());
        DataModel? dat = validateAndConvertParameters(data);

        if(dat!= null){
          setState(() {
            dataList.insert(0, dat);

          });
        }


      });

    } catch (e) {
      print(e.toString());
      stopConnect();
    }
  }

  void setTime() async{
    List<DataModel> lst = await FetchData.readInfo();
    if(lst.isNotEmpty){
      setState(() {
        latestTimestamp = lst[lst.length - 1].timestamp.toString();
      });

    }
  }
  // Function to wipe all data
  void wipeData() {
    // Implement your logic to wipe data here
    print('Wiping all data...');
    FetchData.clearData();
    setTime();
  }

  // Function to add sample data
  void addSampleData() {
    // Implement your logic to add sample data here
    print('Adding sample data...');
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final double fontSize = isTablet ? 30 : 16;
    double screenWidth = MediaQuery.of(context).size.width;


    return Scaffold(
      appBar: AppBar(
        leading: const BackButtonWidget(),
        title: const Text('Settings'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RoundedTab(
                text: 'Email: $email',
                width: screenWidth * 0.8,
                height: isTablet ? 70.0 : 50.0,
                fontSize: isTablet ? 30.0 : 20.0,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RoundedTab(
                text: 'Key: $key',
                width: screenWidth * 0.8,
                height: isTablet ? 70.0 : 50.0,
                fontSize: isTablet ? 30.0 : 13.0,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DefaultTabController(
                length: 2, // Number of tabs
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.blue,
                      tabs: [
                        Tab(text: 'Clear Data',),
                        Tab(text: 'Live Data'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Content for Clear Data tab
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Center(child: Text('Latest Data Timestamp', style: TextStyle(fontSize: fontSize),)), // Display latest timestamp
                              SizedBox(height: 10),
                              Center(child: Text(latestTimestamp, style: TextStyle(fontSize: fontSize),)), // Display latest timestamp
                              SizedBox(height: 20),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Are you sure?'),
                                          content: const Text('This action will wipe all data.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('No'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                wipeData(); // Call wipeData function
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Yes'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24), // Increase vertical padding for height
                                  ),
                                  child: Text('Wipe All Data', style: TextStyle(fontSize: fontSize),),

                                ),

                              ),
                            ],
                          ),

                          // Content for Live Data tab
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text('Top'),
                              // Center(child: OutlinedButton(onPressed: () {}, child: Text('Go Live'))),
                              Expanded(
                                child: ListView(
                                  children: dataList.map((data) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey, // Change color as needed
                                          width: 1, // Adjust width as needed
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        // Adjust border radius as needed
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Timestamp: ${data.timestamp}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                            SizedBox(height: 5),
                                            Text('Concentration: ${data.concentration}  Temperature: ${data.temperature}', style: TextStyle(fontSize: 14)),
                                            SizedBox(height: 5),
                                            Text('Pressure: ${data.pressure}  Altitude: ${data.altitude}', style: TextStyle(fontSize: 14)),
                                            SizedBox(height: 5),
                                            Text('Humidity: ${data.humidity}  Rain: ${data.rain}', style: TextStyle(fontSize: 14)),
                                            // Add more Text widgets for other properties of your data model
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
