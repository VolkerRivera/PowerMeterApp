import 'package:flutter/material.dart';
import 'package:power_meter/data/expense_data.dart';
import 'package:power_meter/datetime/date_time_helper.dart';
import 'package:power_meter/presentation/items/bar%20graph/bar_graph.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const ExpenseSummary({
    super.key, 
    required this.startOfWeek});

    // calculate max amount in bar graph
    double calculateMax(
      ExpenseData value,
      String lunes,
      String martes,
      String miercoles,
      String jueves,
      String viernes,
      String sabado,
      String domingo
    ){
      double? max = 100;

      List<double> values = [
        value.calculateDailyExpenseSummary()[lunes] ?? 0,
        value.calculateDailyExpenseSummary()[martes] ?? 0,
        value.calculateDailyExpenseSummary()[miercoles] ?? 0,
        value.calculateDailyExpenseSummary()[jueves] ?? 0,
        value.calculateDailyExpenseSummary()[viernes] ?? 0,
        value.calculateDailyExpenseSummary()[sabado] ?? 0,
        value.calculateDailyExpenseSummary()[domingo] ?? 0,
      ];

      // sort form smalles to largest
      values.sort();

      //get largest amount (which is at the end of the list)
      max = values.last * 1.1;
      return max == 0 ? 100 : max;
    }

    // calcualte the week total
    String calculateWeekTotal(
      ExpenseData value,
      String lunes,
      String martes,
      String miercoles,
      String jueves,
      String viernes,
      String sabado,
      String domingo
    ){
    
      List<double> values = [
        value.calculateDailyExpenseSummary()[lunes] ?? 0,
        value.calculateDailyExpenseSummary()[martes] ?? 0,
        value.calculateDailyExpenseSummary()[miercoles] ?? 0,
        value.calculateDailyExpenseSummary()[jueves] ?? 0,
        value.calculateDailyExpenseSummary()[viernes] ?? 0,
        value.calculateDailyExpenseSummary()[sabado] ?? 0,
        value.calculateDailyExpenseSummary()[domingo] ?? 0,
      ];

      double total = 0;
      for (int i = 0; i < values.length; i++){
        total += values[i];
      }
    return total.toStringAsFixed(2); // parse to string con 2 decimales
    }

  @override
  Widget build(BuildContext context) {
    // get yyyymmdd for each day of this week
    String lunes = convertDateTimeToString(startOfWeek.add(const Duration(days: 0)));
    String martes = convertDateTimeToString(startOfWeek.add(const Duration(days: 1)));
    String miercoles = convertDateTimeToString(startOfWeek.add(const Duration(days: 2)));
    String jueves = convertDateTimeToString(startOfWeek.add(const Duration(days: 3)));
    String viernes = convertDateTimeToString(startOfWeek.add(const Duration(days: 4)));
    String sabado = convertDateTimeToString(startOfWeek.add(const Duration(days: 5)));
    String domingo = convertDateTimeToString(startOfWeek.add(const Duration(days: 6)));

    return Consumer<ExpenseData>(
      builder: (context, value, child) =>  Column(
        children: [
          // week total
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              children: [
                const Text('Week total: '),
                Text('${calculateWeekTotal(value, lunes, martes, miercoles, jueves, viernes, sabado, domingo)} €')
              ],
            ),
            ),
          SizedBox( //necesario entender este percal
            height: 200,
            child: MyBarGraph( // es aqui donde se dara valor al grafico
              maxY: calculateMax(value, lunes, martes, miercoles, jueves, viernes, sabado, domingo),
              monAmount: value.calculateDailyExpenseSummary()[lunes] ?? 0, //el gasto de cada dia, siendo el index yyyymmdd
              tueAmount: value.calculateDailyExpenseSummary()[martes] ?? 0, 
              wedAmount: value.calculateDailyExpenseSummary()[miercoles] ?? 0, 
              thuAmount: value.calculateDailyExpenseSummary()[jueves] ?? 0, 
              friAmount: value.calculateDailyExpenseSummary()[viernes] ?? 0, 
              satAmount: value.calculateDailyExpenseSummary()[sabado] ?? 0, 
              sunAmount: value.calculateDailyExpenseSummary()[domingo] ?? 0),
          ),
        ],
      ));
  }
}