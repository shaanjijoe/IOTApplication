import 'package:flutter/material.dart';
// import 'package:iot_app/components/my_button.dart';
import 'package:iot_app/components/my_chart.dart';
import 'package:iot_app/components/my_stats.dart';
import 'package:iot_app/logicscripts/FetchData.dart';

import '../logicscripts/Database/DataModel.dart';

class Temperature extends StatefulWidget {
  const Temperature({super.key,
  });

  @override
  State<Temperature> createState() => _TemperatureState();
}

class _TemperatureState extends State<Temperature> {

  // Pair('2022-01-01', 100),
  List<Pair> dataList = [];
  // 10.5, 20.3, 15.7, 25.8, 30.2, 18.6, 12.4, 22.9, 28.0, 35.1,
  List<double> randomData = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final List<DataModel> fetchedData = await FetchData.readInfo();

      setState(() {
        dataList = fetchedData.map((data) => Pair(data.timestamp.toString(), data.temperature)).toList();

        randomData = fetchedData.map((data) => data.temperature).toList();
      });
    } catch (e) {
      print('Error loading data: $e');
    }
  }


  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    return Scaffold(
      appBar: AppBar(
        leading: BackButtonWidget(),
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
                      Text("Temperature", style: TextStyle(fontSize: isTablet ?  60 : 30, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),


                MyChart(pairDataList: dataList,xaxis: 'Time', yaxis: 'Temperature',),
                //
                const SizedBox(height: 20,),

                StatsWidget(
                  heading: 'Statistics',
                  data: randomData,
                  unit: '°C',
                ),

                // MyButton(onTap: () async {
                //   String? email2 = await FetchData.readData("email");
                //   String? key2 = await FetchData.checkToken();
                //   String email = email2 ?? "";
                //   String password = key2 ?? "";
                //
                //   dynamic data = await FetchData.fetchInfo(email, password) ;
                //   List<dynamic> lst = data['data'];
                //
                //   for(var item in lst) {
                //     // print(item['Concentration']);
                //     dataList.add(Pair(item['timestamp'], item['Concentration']));
                //     randomData.add(item['Concentration']);
                //   }
                //
                //
                // }, message: 'Fetch data')





              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BackButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
