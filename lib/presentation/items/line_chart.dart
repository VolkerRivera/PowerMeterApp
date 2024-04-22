import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:power_meter/data/energia_tiempo.dart';

class LineChartWidget extends StatelessWidget {
  final List<EnergiaTiempo> puntos;

  const LineChartWidget(this.puntos, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: puntos.map((e) => FlSpot(e.time.toDouble(), e.energy)).toList(),
            isCurved: true,
            dotData: const FlDotData(show: true)
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles( //titulo del eje
            axisNameSize: 20,
            axisNameWidget: const Text("Tiempo"),
            sideTitles: SideTitles( //contenido del eje, valores numericos
              interval: 1,
              reservedSize: 22,
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString());
              }
            )
            ),

          topTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            )
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            )
          ),
        )
      ),
    ));
  }
}