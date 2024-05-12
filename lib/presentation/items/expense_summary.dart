import 'package:flutter/material.dart';
import 'package:power_meter/data/expense_data.dart';
import 'package:power_meter/datetime/date_time_helper.dart';
import 'package:power_meter/presentation/items/bar%20graph/bar_graph.dart';
import 'package:provider/provider.dart';

class ExpenseSummaryWeekEuro extends StatelessWidget {
  final DateTime startOfWeek;
  final bool euro;
  const ExpenseSummaryWeekEuro({
    super.key, 
    required this.startOfWeek, 
    required this.euro});

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

      if(euro){
        List<double> values = [
        value.calculateDailyExpenseSummaryWeekEuros()[lunes] ?? 0,
        value.calculateDailyExpenseSummaryWeekEuros()[martes] ?? 0,
        value.calculateDailyExpenseSummaryWeekEuros()[miercoles] ?? 0,
        value.calculateDailyExpenseSummaryWeekEuros()[jueves] ?? 0,
        value.calculateDailyExpenseSummaryWeekEuros()[viernes] ?? 0,
        value.calculateDailyExpenseSummaryWeekEuros()[sabado] ?? 0,
        value.calculateDailyExpenseSummaryWeekEuros()[domingo] ?? 0,
        ];
        // sort form smalles to largest
        values.sort();

        //get largest amount (which is at the end of the list)
        max = values.last * 1.1;
      }else{
        List<double> values = [
        value.calculateDailyExpenseSummaryWeekkWh()[lunes] ?? 0,
        value.calculateDailyExpenseSummaryWeekkWh()[martes] ?? 0,
        value.calculateDailyExpenseSummaryWeekkWh()[miercoles] ?? 0,
        value.calculateDailyExpenseSummaryWeekkWh()[jueves] ?? 0,
        value.calculateDailyExpenseSummaryWeekkWh()[viernes] ?? 0,
        value.calculateDailyExpenseSummaryWeekkWh()[sabado] ?? 0,
        value.calculateDailyExpenseSummaryWeekkWh()[domingo] ?? 0,
        ];
        // sort form smalles to largest
        values.sort();

        //get largest amount (which is at the end of the list)
        max = values.last * 1.1;
      }
      

      
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

      double total = 0;
      if(euro){
        List<double> values = [
        value.calculateDailyExpenseSummaryWeekEuros()[lunes] ?? 0,
        value.calculateDailyExpenseSummaryWeekEuros()[martes] ?? 0,
        value.calculateDailyExpenseSummaryWeekEuros()[miercoles] ?? 0,
        value.calculateDailyExpenseSummaryWeekEuros()[jueves] ?? 0,
        value.calculateDailyExpenseSummaryWeekEuros()[viernes] ?? 0,
        value.calculateDailyExpenseSummaryWeekEuros()[sabado] ?? 0,
        value.calculateDailyExpenseSummaryWeekEuros()[domingo] ?? 0,
        ];
        for (int i = 0; i < values.length; i++){
          total += values[i];
        }
      }else{
        List<double> values = [
        value.calculateDailyExpenseSummaryWeekkWh()[lunes] ?? 0,
        value.calculateDailyExpenseSummaryWeekkWh()[martes] ?? 0,
        value.calculateDailyExpenseSummaryWeekkWh()[miercoles] ?? 0,
        value.calculateDailyExpenseSummaryWeekkWh()[jueves] ?? 0,
        value.calculateDailyExpenseSummaryWeekkWh()[viernes] ?? 0,
        value.calculateDailyExpenseSummaryWeekkWh()[sabado] ?? 0,
        value.calculateDailyExpenseSummaryWeekkWh()[domingo] ?? 0,
        ];
        for (int i = 0; i < values.length; i++){
          total += values[i];
        }
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
                Text('${calculateWeekTotal(value, lunes, martes, miercoles, jueves, viernes, sabado, domingo)} ${euro ? '€' : 'kWh'}')
              ],
            ),
            ),
          SizedBox( //necesario entender este percal
            height: 200,
            child: euro ?
            MyBarGraph( // es aqui donde se dara valor al grafico
              maxY: calculateMax(value, lunes, martes, miercoles, jueves, viernes, sabado, domingo),
              monAmount: value.calculateDailyExpenseSummaryWeekEuros()[lunes] ?? 0, //el gasto de cada dia, siendo el index yyyymmdd
              tueAmount: value.calculateDailyExpenseSummaryWeekEuros()[martes] ?? 0, 
              wedAmount: value.calculateDailyExpenseSummaryWeekEuros()[miercoles] ?? 0, 
              thuAmount: value.calculateDailyExpenseSummaryWeekEuros()[jueves] ?? 0, 
              friAmount: value.calculateDailyExpenseSummaryWeekEuros()[viernes] ?? 0, 
              satAmount: value.calculateDailyExpenseSummaryWeekEuros()[sabado] ?? 0, 
              sunAmount: value.calculateDailyExpenseSummaryWeekEuros()[domingo] ?? 0)

            : MyBarGraph( // es aqui donde se dara valor al grafico
              maxY: calculateMax(value, lunes, martes, miercoles, jueves, viernes, sabado, domingo),
              monAmount: value.calculateDailyExpenseSummaryWeekkWh()[lunes] ?? 0, //el gasto de cada dia, siendo el index yyyymmdd
              tueAmount: value.calculateDailyExpenseSummaryWeekkWh()[martes] ?? 0, 
              wedAmount: value.calculateDailyExpenseSummaryWeekkWh()[miercoles] ?? 0, 
              thuAmount: value.calculateDailyExpenseSummaryWeekkWh()[jueves] ?? 0, 
              friAmount: value.calculateDailyExpenseSummaryWeekkWh()[viernes] ?? 0, 
              satAmount: value.calculateDailyExpenseSummaryWeekkWh()[sabado] ?? 0, 
              sunAmount: value.calculateDailyExpenseSummaryWeekkWh()[domingo] ?? 0)
          ),
        ],
      ));
  }
}
