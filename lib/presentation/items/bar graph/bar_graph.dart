import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:power_meter/presentation/items/bar%20graph/bar_data.dart';

class MyBarGraphWeek extends StatelessWidget {
  final double? maxY;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thuAmount;
  final double friAmount;
  final double satAmount;
  final double sunAmount;

  const MyBarGraphWeek({
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
    BarDataWeek myBarData = BarDataWeek(
      monAmount: monAmount, 
      tueAmount: tueAmount, 
      wedAmount: wedAmount, 
      thuAmount: thuAmount, 
      friAmount: friAmount, 
      satAmount: satAmount, 
      sunAmount: sunAmount);
    myBarData.initializeBarData();

    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: BarChart(
        BarChartData(
          //config eje y
          maxY: maxY,
          minY: 0,
      
          //style bar graphic
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            drawHorizontalLine: true,
            verticalInterval: (maxY!/2)
          ),
          borderData: FlBorderData(
            show: true,
          ),

          titlesData: const FlTitlesData(
            show: true,
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false, // Oculta el eje derecho
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false, // Oculta el eje derecho
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: getBottomTitles
              ),
            ),
            
          ),
          //data bar graphic
          barGroups: myBarData.barData // convertimos la lista a un mapa en el que iran los pares X Y y se asignan a los ejes del grafico
          .map((data) => BarChartGroupData(
            x: data.x,
            barRods: [
              BarChartRodData(
                toY: data.y,
                color: Colors.grey.shade500,
                borderRadius: BorderRadius.circular(2),
                width: 15.0
              )
            ]
            ))
          .toList()
        )
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta){
  const style = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  Widget text;

  switch(value.toInt()){
    case 0:
      text = const Text('L', style: style);
      break;
    case 1:
      text = const Text('M', style: style);
      break;
    case 2:
      text = const Text('X', style: style);
      break;
    case 3:
      text = const Text('J', style: style);
      break;
    case 4:
      text = const Text('V', style: style);
      break;
    case 5:
      text = const Text('S', style: style);
      break;
    case 6:
      text = const Text('D', style: style);
      break;
    default: 
      text = const Text('', style: style);
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text);
}

class MyBarGraphMonth extends StatelessWidget {
  final double? maxY;
  final int numDias;
  final List<double>values;

  const MyBarGraphMonth({
    super.key, 
    required this.maxY,
    required this.numDias, 
    required this.values
  });

  @override
  Widget build(BuildContext context) {
    BarDataMonth myBarData = BarDataMonth(
      numDias: numDias, 
      values: values
    );
    myBarData.initializeBarData();

    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            drawHorizontalLine: true,
            verticalInterval: (maxY!/2)
            ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              color: Colors.grey.shade500,
              spots: myBarData.barData
              .map((data) => FlSpot(
                data.x.toDouble(), 
                data.y
              ))
              .toList()
              )
          ],
          titlesData: const FlTitlesData(
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false
              )
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false
              )
            )
          )
        )
        ),
    );
    /*return BarChart(
      BarChartData(
        //config eje y
        maxY: maxY,
        minY: 0,

        //style bar graphic
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false, // Oculta el eje derecho
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false, // Oculta el eje derecho
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true, // Oculta el eje de abajo
            ),
          ),
        ),

        //data bar graphic
        barGroups: myBarData.barData
        .map((data) => BarChartGroupData(
          x: data.x, 
          barRods: [
            BarChartRodData(toY: data.y)
          ]
          ))
          .toList()
      )
      );*/
  }
}