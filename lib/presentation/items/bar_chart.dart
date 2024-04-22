import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:power_meter/data/energia_tiempo.dart';

class BarChartWidget extends StatelessWidget {
  final List<CostoTiempo> puntos;

  const BarChartWidget(this.puntos, {super.key,});

  @override
  Widget build(BuildContext context) => Expanded(
    child: 
      BarChart(
        BarChartData(
          barGroups: puntos.map((data) => BarChartGroupData(
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
}