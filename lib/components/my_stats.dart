import 'dart:math';

import 'package:flutter/material.dart';

class StatsWidget extends StatefulWidget {

  final String heading;
  final List<double> data;
  final String unit;
  const StatsWidget({
    super.key,
    required this.heading,
    required this.data,
    required this.unit,

  });

  @override
  State<StatsWidget> createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget> {

  late double mean=0.0;
  late double min=0.0;
  late double max=0.0;
  late double median=0.0;
  late double stdDev=0.0;
  late double q1=0.0;
  late double q3=0.0;

  // @override
  // void initState() {
  //   super.initState();
  //   _calculateStatistics();
  // }

  @override
  void didUpdateWidget(covariant StatsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _calculateStatistics();
  }


  void _calculateStatistics() {
    if (widget.data.isEmpty) return;

    mean = widget.data.reduce((value, element) => value + element) / widget.data.length;
    min = widget.data.reduce((min, value) => min < value ? min : value);
    max = widget.data.reduce((max, value) => max > value ? max : value);

    final sortedData = List<double>.from(widget.data)..sort();
    final int middle = sortedData.length ~/ 2;
    median = sortedData.length.isEven
        ? (sortedData[middle - 1] + sortedData[middle]) / 2
        : sortedData[middle];

    final double meanSquaredDiff = widget.data
        .map((value) => (value - mean)*(value - mean))
        .reduce((value, element) => value + element);
    stdDev = sqrt(meanSquaredDiff / widget.data.length);

    final int middleIndex = widget.data.length ~/ 2;
    q1 = sortedData.length.isEven
        ? sortedData.sublist(0, middleIndex).reduce((value, element) => value + element) / middleIndex
        : sortedData[middleIndex ~/ 2];
    q3 = sortedData.length.isEven
        ? sortedData.sublist(middleIndex).reduce((value, element) => value + element) / middleIndex
        : sortedData[middleIndex + middleIndex ~/ 2];
  }



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Adjust margin here
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.heading,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize:  isTablet ? 22.0 : 18.0,
            ),
          ),
          SizedBox(height: 10.0),
          _buildDataField('Mean', mean),
          _buildDataField('Min', min),
          _buildDataField('Max', max),
          _buildDataField('Median', median),
          _buildDataField('Standard Deviation', stdDev),
          _buildDataField('1st Quartile (Q1)', q1),
          _buildDataField('3rd Quartile (Q3)', q3),
        ],
      ),
    );
  }

  Widget _buildDataField(String label, double value) {
    double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    return Row(
      children: [
        Expanded(
          child: Text(
            '$label ${widget.unit}:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: isTablet ? 20 : 15),
          ),
        ),
        Text('$value ${widget.unit}', style: TextStyle(fontSize: isTablet ? 20 : 15),), // Add unit here
      ],
    );
  }
}


