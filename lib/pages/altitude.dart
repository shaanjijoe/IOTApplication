import 'package:flutter/material.dart';
import 'package:iot_app/components/active_button.dart';
import 'package:iot_app/components/my_chart.dart';
import 'package:iot_app/components/my_stats.dart';
import 'package:iot_app/logicscripts/FetchData.dart';
import '../components/back_button.dart';
import '../logicscripts/Database/DataModel.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../logicscripts/GlobalData.dart';

class Altitude extends StatefulWidget {
  const Altitude({super.key,
  });

  @override
  State<Altitude> createState() => _AltitudeState();
}

class _AltitudeState extends State<Altitude> {

  // Pair('2022-01-01', 100),
  List<Pair> dataList = [];
  // 10.5, 20.3, 15.7, 25.8, 30.2, 18.6, 12.4, 22.9, 28.0, 35.1,
  List<double> randomData = [];

  late IO.Socket socket;
  bool socketConnected = false;
  bool buttonState = false;
  bool listening = false;


  @override
  void initState() {
    super.initState();
    loadData();
    connectToServer();
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    try {
      final List<DataModel> fetchedData = await FetchData.readInfo();

      setState(() {
        dataList = fetchedData.map((data) => Pair(data.timestamp.toString(), data.altitude)).toList();

        randomData = fetchedData.map((data) => data.altitude).toList();
      });
    } catch (e) {
      print('Error loading data: $e');
    }
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

    } catch (e) {
      print(e.toString());
      stopConnect();
    }
  }

  Pair? processor(dynamic jsonData){
    double Altitude = 0.0;
    String timestamp = "";
    if (jsonData.containsKey('Altitude')) {
      // Check if 'Altitude' is an integer
      if (jsonData['Altitude'] is int) {
        // Convert 'Altitude' to double
        Altitude = jsonData['Altitude'].toDouble();
        // print('Altitude (converted to double): $Altitude');
      } else if (jsonData['Altitude'] is double) {
        Altitude = jsonData['Altitude'];
      } else {
        return null;
      }
    } else {
      // print('Altitude not found');
      return null;
    }

    // Check if 'timestamp' field exists
    if (jsonData.containsKey('timestamp')) {
      // Convert 'timestamp' to string
      timestamp = jsonData['timestamp'].toString();
    } else {
      return null;
      // print('Timestamp not found');
    }
    return Pair(timestamp, Altitude);
  }

  void noLiveMode(){

    if(socketConnected == true && listening == true){
      socket.off('data-post');
      listening = false;
    }

    setState(() {
      dataList.clear();
      randomData.clear();
    });

    loadData().then((value) => print("Loaded old data"));

  }


  void liveMode(){

    setState(() {
      dataList.clear();
      randomData.clear();
    });

    if(socketConnected == true && listening == false){
      socket.on('data-post', (data) {
        print(data.toString());

        Pair? dat = processor(data);
        if(dat!=null){

          setState(() {
            dataList.add(dat);
            randomData.add(dat.Yint);

            if(dataList.length>100){
              dataList.removeAt(0);
              randomData.removeAt(0);
            }
          });
        }

      });
      listening = true;
    }
  }


  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButtonWidget(),
      ),
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
                      Text("Altitude", style: TextStyle(fontSize: isTablet ?  60 : 30, fontWeight: FontWeight.bold),),

                    ],
                  ),
                ),


                MyChart(pairDataList: dataList,xaxis: 'Time', yaxis: 'Altitude',),

                const SizedBox(height: 20,),

                ActiveButton(onTap: () {

                  // print(socketConnected);
                  if(buttonState == false) {

                    liveMode();
                    buttonState = !buttonState;

                  } else {

                    noLiveMode();
                    buttonState = !buttonState;

                  }


                } , message: "Live Data", activeMessage: "Stop Live"),

                const SizedBox(height: 20,),

                StatsWidget(
                  heading: 'Statistics',
                  data: randomData,
                  unit: 'm',
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
