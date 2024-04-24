import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:power_meter/data/energia_tiempo.dart';

class BarChartWidget extends StatefulWidget { //estatefull porque cambiara su estado
 //en funcion del eje de tiempos que se elija
  final Future<List<CostoTiempo>> puntos;

  const BarChartWidget(this.puntos, {super.key,});

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  @override
  Widget build(BuildContext context) => FutureBuilder(
    future: widget.puntos,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Expanded(
          child: BarChart(
            BarChartData(
              barGroups: snapshot.data!.map((data) => BarChartGroupData(
                x: data.time,
                barRods: [
                  BarChartRodData(
                    toY: data.precio,
                    width: 10,
                    color: Colors.blue.shade200,
                  )
                ],
              ))
            .toList(),
              titlesData: const FlTitlesData(
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  )
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  )
                ),
                bottomTitles: AxisTitles(
                  axisNameWidget: Text('Tiempo'),
                  axisNameSize: 22,
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 25
                  )
                )
              )
            ),
          ),
        );
      } else {
        return const CircularProgressIndicator();
      }
    },
  );
}