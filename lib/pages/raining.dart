import 'package:flutter/material.dart';
import 'package:iot_app/components/active_button.dart';
import 'package:iot_app/components/my_chart.dart';
import 'package:iot_app/components/my_stats.dart';
import 'package:iot_app/logicscripts/FetchData.dart';
import '../components/back_button.dart';
import '../logicscripts/Database/DataModel.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../logicscripts/GlobalData.dart';

class Raining extends StatefulWidget {
  const Raining({super.key,
  });

  @override
  State<Raining> createState() => _RainingState();
}

class _RainingState extends State<Raining> {

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
        dataList = fetchedData.map((data) => Pair(data.timestamp.toString(), data.rain ? 1.0 : 0.0)).toList();

        randomData = fetchedData.map((data) => data.rain ? 1.0 : 0.0).toList();

        // print(randomData.toString());
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
    // Check if 'Raining' field exists
    double Raining = 0.0;
    String timestamp = "";
    if (jsonData.containsKey('Raining')) {
      print(jsonData.toString());
      // Check if 'Raining' is an integer
      if (jsonData['Raining'] is int) {
        // Negating due to sensor conductivity
        // jsonData['Raining'] = 1 - jsonData['Raining'];
        // Convert 'Raining' to double
        Raining = jsonData['Raining'].toDouble();
        print(Raining);
        // print('Raining (converted to double): $Raining');
      } else {
        return null;
      }
    } else {
      // print('Raining not found');
      return null;
    }

    // Check if 'timestamp' field exists
    if (jsonData.containsKey('timestamp')) {
      // Convert 'timestamp' to string
      timestamp = jsonData['timestamp'].toString();
      // print('Timestamp (converted to string): $timestamp');
    } else {
      return null;
      // print('Timestamp not found');
    }

    return Pair(timestamp, Raining);

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
        // print(data.toString());

        Pair? dat = processor(data);
        print(dat.toString());
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
                      Text("Raining", style: TextStyle(fontSize: isTablet ?  60 : 30, fontWeight: FontWeight.bold),),

                    ],
                  ),
                ),


                MyChart(pairDataList: dataList,xaxis: 'Time', yaxis: 'Raining',),
                //
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
                  unit: '',
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }
}
