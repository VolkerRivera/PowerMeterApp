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
    //initialize Bardata, otherwise null errors
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
      padding: const EdgeInsets.only(left: 30.0, right: 40.0),
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

          titlesData: FlTitlesData(
            show: true,
            leftTitles:  AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: maxY!/4,
                  getTitlesWidget: (value, meta) {
                  const style = TextStyle(
                    fontSize: 14,
                  );

                  // Format the value with one decimal place
                  String formattedValue = value.toStringAsFixed(2); 
                  
                  return Text(formattedValue, style: style); 
                },
                reservedSize: 50
              )
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false, // Oculta el eje derecho
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false, // Oculta el eje derecho
              ),
            ),
            bottomTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: getBottomTitlesWeek
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
                color: const Color.fromARGB(255, 130, 108, 255),
                borderRadius: BorderRadius.circular(2),
                width: 12.0
              )
            ]
            ))
          .toList()
        )
      ),
    );
  }
}

Widget getBottomTitlesWeek(double value, TitleMeta meta){
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

Widget getBottomTitlesSingleMonth(double value, TitleMeta meta){
  const style = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  Widget text = const Text('data', style: style,);

  for(int i = 0; i <= value.toInt(); i++){
    text = const Text(' ', style: style);
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text);
}

class MyBarGraphMonth extends StatelessWidget {
  final double? maxY;
  final int numDias;
  final List<double>values;
  final DateTime startOfMonth;

  const MyBarGraphMonth({
    super.key, 
    required this.maxY,
    required this.numDias, 
    required this.values,
    required this.startOfMonth
  });

  @override
  Widget build(BuildContext context) {
    BarDataMonth myBarData = BarDataMonth(
      numDias: numDias, 
      values: values,
      startOfMonth: startOfMonth
    );
    myBarData.initializeBarData();
    myBarData.initializeTitleWeekRange();

    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 40.0),
      child: BarChart(
        BarChartData(
          //config eje y
          maxY: maxY,
          minY: 0,
          //style bar graphic
          gridData: const FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false),
          borderData: FlBorderData(show: true),
          titlesData:  FlTitlesData(
            show: true,
            leftTitles:  AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: maxY!/4,
                  getTitlesWidget: (value, meta) {
                  const style = TextStyle(
                    fontSize: 14,
                  );

                  // Format the value with one decimal place
                  String formattedValue = value.toStringAsFixed(2); 
                  
                  return Text(formattedValue, style: style); 
                },
                reservedSize: 50
              )
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false, // Oculta el eje derecho
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false, // Oculta el eje derecho
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true, // Oculta el eje de abajo
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  );
                  Widget text = const Text('data', style: style,); 

                  for(int i = 0; i <= value.toInt(); i++){
                    text = Text(myBarData.titleWeekRange.elementAt(i), style: style);
                  }

                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Transform(
                      origin: const Offset(20, 10),
                      transform: Matrix4.identity()..rotateZ(0.8),
                      alignment: AlignmentDirectional.bottomStart,
                      child: text
                    )
                  );
                } ,
                reservedSize: 30
              ),
            ),
          ),
      
          //data bar graphic
          barGroups: myBarData.barData
          .map((data) => BarChartGroupData(
            x: data.x, 
            barRods: [
              BarChartRodData(
                toY: data.y,
                color: const Color.fromARGB(255, 130, 108, 255),
                borderRadius: BorderRadius.circular(2),
                width: 12.0
                )
            ]
            ))
            .toList()
        )
        ),
    );
  }
}

class MyBarGraphDay extends StatelessWidget {
  final double? maxY;
  final int numHoras = 24;
  final List<double> values;
  final DateTime dayToConsult;

  const MyBarGraphDay({
    super.key,
    required this.maxY,
    required this.values,
    required this.dayToConsult
  });

  @override
  Widget build(BuildContext context) {
    // es dummie, solo le paso valores, donde identifico valores de que dia es en clase MyBarGraphDay
    BarDataDay myBarData = BarDataDay(values: values);
    myBarData.initializaBarData();

    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 40.0),
      child: BarChart(BarChartData(
        maxY: maxY,
        minY: 0,
        barGroups: myBarData.barData
        .map((data) => BarChartGroupData(
          x: data.x,
          barRods: [
            BarChartRodData(
              toY: data.y,
              color: const Color.fromARGB(255, 130, 108, 255),
              borderRadius: BorderRadius.circular(2),
              width: 12.0
            )
          ]
          ))
          .toList(),
        gridData: const FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false),
          borderData: FlBorderData(show: true),
          titlesData: FlTitlesData(
            show: true,
            leftTitles:  AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: maxY!/4,
                  getTitlesWidget: (value, meta) {
                  const style = TextStyle(
                    fontSize: 14,
                  );

                  // Format the value with one decimal place
                  String formattedValue = value.toStringAsFixed(2); 
                  
                  return Text(formattedValue, style: style); 
                },
                reservedSize: 50
              )
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false, // Oculta el eje derecho
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false, // Oculta el eje derecho
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  );
                  Widget text = const Text('data', style: style,); 
                  for(int i = 0; i <= value.toInt(); i++){
                    text = Text(myBarData.barData.elementAt(i).x.toString(), style: style);
                  }
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Transform(
                      origin: const Offset(10, -20),
                      //origin: Offset(20, 20),
                      transform: Matrix4.identity()..rotateZ(0),
                      alignment: AlignmentDirectional.bottomStart,
                      child: text
                      ));
                },
                reservedSize: 30
              )
            )
          ),
        barTouchData: BarTouchData(
          touchCallback: (FlTouchEvent event, barTouchResponse) {
              if (event.isInterestedForInteractions && barTouchResponse != null) {
                final spot = barTouchResponse.spot;
                if (spot != null) {
                  // Handle the touch event here if needed
                }
              }
            },
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              int startHour = group.x;
              int endHour = startHour + 1 == 24 ? 0 : startHour + 1;
              return BarTooltipItem(
                'Hora: $startHour:00 - $endHour:00\nConsumo: ${rod.toY}',
                const TextStyle(color: Colors.white),
                );
            },
          ),
        ),
      )
      )
    );
  }
}