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

  @override
  void initState() {
    super.initState();
    setTime();
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
                                              child: Text('Yes'),
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
                                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 24), // Increase vertical padding for height
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
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    addSampleData(); // Call addSampleData function
                                  },
                                  child: Text('Add Sample Data'),
                                ),
                              ),
                              // Live data content can be added here
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
