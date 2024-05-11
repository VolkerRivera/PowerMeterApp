import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:power_meter/presentation/items/bar%20graph/bar_data.dart';

class MyBarGraph extends StatelessWidget {
  final double? maxY;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thuAmount;
  final double friAmount;
  final double satAmount;
  final double sunAmount;

  const MyBarGraph({
    super.key, 
    this.maxY, 
    required this.monAmount, 
    required this.tueAmount, 
    required this.wedAmount, 
    required this.thuAmount, 
    required this.friAmount, 
    required this.satAmount, 
    required this.sunAmount
    });

  @override
  Widget build(BuildContext context) {
    //initialize Bardata, otherwise we will get null errors
    BarData myBarData = BarData(
      monAmount: monAmount, 
      tueAmount: tueAmount, 
      wedAmount: wedAmount, 
      thuAmount: thuAmount, 
      friAmount: friAmount, 
      satAmount: satAmount, 
      sunAmount: sunAmount);
    myBarData.initializeBarData();

    return BarChart(
      BarChartData(
        maxY: maxY,
        minY: 0,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: myBarData.barData // convertimos la lista a un mapa en el que iran los pares X Y y se asignan a los ejes del grafico
        .map((data) => BarChartGroupData(
          x: data.x,
          barRods: [
            BarChartRodData(toY: data.y)
          ]
          ))
        .toList()
      )
    );
  }
}