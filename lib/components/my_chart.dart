import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyChart extends StatefulWidget {
  final List<Pair> pairDataList;
  final String yaxis;
  final String xaxis;
  const MyChart({super.key, required this.pairDataList,
  required this.yaxis,
  required this.xaxis,});

  @override
  State<MyChart> createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> {

  List<Pair> _data = [];

  @override
  void initState() {
    super.initState();
    _data = widget.pairDataList;
  }

  void updateChart(Pair newData) {
    setState(() {
      // Add new data to the existing data list
      _data.add(newData);

      if(_data.length >30) {
        _data.removeAt(0);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10), // Optional padding
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.black, width: 1.0), // Border decoration
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Container(
          width: double.infinity,
          height: 300,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(
              title: AxisTitle(text: widget.xaxis), // X-axis label
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(text: widget.yaxis), // Y-axis label
            ),
            legend: const Legend(isVisible: true),
            series: <SplineSeries<Pair,String>>[
              SplineSeries<Pair,String>(

                dataSource: widget.pairDataList,
                xValueMapper: (Pair pairData, _) => pairData.Xstring,
                yValueMapper: (Pair pairData, _) => pairData.Yint,
                name: 'Time-Series Data',
              )
            ],
          ),
      ),
    );
  }
}

class Pair {
  late final String Xstring;
  late final double Yint;
  Pair(this.Xstring, this.Yint);
}

