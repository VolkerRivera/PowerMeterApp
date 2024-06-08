import 'package:flutter/material.dart';
import 'package:power_meter/data/expense_data.dart';
import 'package:power_meter/datetime/date_time_helper.dart';
import 'package:power_meter/presentation/items/bar%20graph/bar_graph.dart';
import 'package:provider/provider.dart';

class ExpenseSummaryWeek extends StatelessWidget {
  final DateTime startOfWeek;
  final bool euro;
  const ExpenseSummaryWeek({
    super.key, 
    required this.startOfWeek, 
    required this.euro});

    

    // calculate max amount in bar graph
    double calculateMaxThisWeek( // referente a 1 semana
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
        value.calculateDailyExpenseSummaryEuros()[lunes] ?? 0,
        value.calculateDailyExpenseSummaryEuros()[martes] ?? 0,
        value.calculateDailyExpenseSummaryEuros()[miercoles] ?? 0,
        value.calculateDailyExpenseSummaryEuros()[jueves] ?? 0,
        value.calculateDailyExpenseSummaryEuros()[viernes] ?? 0,
        value.calculateDailyExpenseSummaryEuros()[sabado] ?? 0,
        value.calculateDailyExpenseSummaryEuros()[domingo] ?? 0,
        ];
        // sort form smallest to largest
        values.sort();

        //get largest amount (which is at the end of the list)
        max = values.last * 1.1;
      }else{
        List<double> values = [
        value.calculateDailyExpenseSummarykWh()[lunes] ?? 0,
        value.calculateDailyExpenseSummarykWh()[martes] ?? 0,
        value.calculateDailyExpenseSummarykWh()[miercoles] ?? 0,
        value.calculateDailyExpenseSummarykWh()[jueves] ?? 0,
        value.calculateDailyExpenseSummarykWh()[viernes] ?? 0,
        value.calculateDailyExpenseSummarykWh()[sabado] ?? 0,
        value.calculateDailyExpenseSummarykWh()[domingo] ?? 0,
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
        value.calculateDailyExpenseSummaryEuros()[lunes] ?? 0,
        value.calculateDailyExpenseSummaryEuros()[martes] ?? 0,
        value.calculateDailyExpenseSummaryEuros()[miercoles] ?? 0,
        value.calculateDailyExpenseSummaryEuros()[jueves] ?? 0,
        value.calculateDailyExpenseSummaryEuros()[viernes] ?? 0,
        value.calculateDailyExpenseSummaryEuros()[sabado] ?? 0,
        value.calculateDailyExpenseSummaryEuros()[domingo] ?? 0,
        ];
        for (int i = 0; i < values.length; i++){
          total += values[i];
        }
      }else{
        List<double> values = [
        value.calculateDailyExpenseSummarykWh()[lunes] ?? 0, //< lunes es el nombre del String, el valor es del tipo yyyymmdd, se le da valor en linea 111
        value.calculateDailyExpenseSummarykWh()[martes] ?? 0,
        value.calculateDailyExpenseSummarykWh()[miercoles] ?? 0,
        value.calculateDailyExpenseSummarykWh()[jueves] ?? 0,
        value.calculateDailyExpenseSummarykWh()[viernes] ?? 0,
        value.calculateDailyExpenseSummarykWh()[sabado] ?? 0,
        value.calculateDailyExpenseSummarykWh()[domingo] ?? 0,
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
    String lunes = convertDateTimeToString(startOfWeek.add(const Duration(days: 0))); // al startOfWeek aka lunes se le añade 0 -> lunes
    String martes = convertDateTimeToString(startOfWeek.add(const Duration(days: 1))); // -> martes ...
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
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Row(
                children: [
                  RichText(
                    text: 
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Total semana: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // Pone el texto en negrita
                              color: Colors.black, // Color del texto
                            ),
                          ),
                          TextSpan(
                            text: '${calculateWeekTotal(value, lunes, martes, miercoles, jueves, viernes, sabado, domingo)} ${euro ? '€' : 'kWh'}',
                            style: const TextStyle(
                            color: Colors.black, // Color del texto
                            ),
                          ),
                        ],
                      ),
                  ),
                ],
              ),
            ),
            ),
          SizedBox( //necesario entender este percal
            height: 275,
            child: euro ?
            MyBarGraphWeek( // es aqui donde se dara valor al grafico
              maxY: calculateMaxThisWeek(value, lunes, martes, miercoles, jueves, viernes, sabado, domingo),
              monAmount: value.calculateDailyExpenseSummaryEuros()[lunes] ?? 0, //el gasto de cada dia, siendo el index yyyymmdd
              tueAmount: value.calculateDailyExpenseSummaryEuros()[martes] ?? 0, 
              wedAmount: value.calculateDailyExpenseSummaryEuros()[miercoles] ?? 0, 
              thuAmount: value.calculateDailyExpenseSummaryEuros()[jueves] ?? 0, 
              friAmount: value.calculateDailyExpenseSummaryEuros()[viernes] ?? 0, 
              satAmount: value.calculateDailyExpenseSummaryEuros()[sabado] ?? 0, 
              sunAmount: value.calculateDailyExpenseSummaryEuros()[domingo] ?? 0)

            : MyBarGraphWeek( // es aqui donde se dara valor al grafico
              maxY: calculateMaxThisWeek(value, lunes, martes, miercoles, jueves, viernes, sabado, domingo),
              monAmount: value.calculateDailyExpenseSummarykWh()[lunes] ?? 0, //el gasto de cada dia, siendo el index yyyymmdd
              tueAmount: value.calculateDailyExpenseSummarykWh()[martes] ?? 0, 
              wedAmount: value.calculateDailyExpenseSummarykWh()[miercoles] ?? 0, 
              thuAmount: value.calculateDailyExpenseSummarykWh()[jueves] ?? 0, 
              friAmount: value.calculateDailyExpenseSummarykWh()[viernes] ?? 0, 
              satAmount: value.calculateDailyExpenseSummarykWh()[sabado] ?? 0, 
              sunAmount: value.calculateDailyExpenseSummarykWh()[domingo] ?? 0)
          ),
        ],
      ));
  }
}

class ExpenseSummaryMonth extends StatelessWidget {
  final DateTime startOfMonth;
  final bool euro;
  const ExpenseSummaryMonth({
    super.key, 
    required this.startOfMonth, 
    required this.euro
  });

  // calculate num days this month
  int numDiasThisMonth(){
    //DateTime lastOfMonth = startOfMonth.subtract(const Duration(days: 1)); //restamos 1 al primer dia para saber cual es el ultimo del mes
    //ultimo dia de mes actual = ( 1 / mes actual + 1 mes / año actual ) - 1 dia
    DateTime lastOfMonth = DateTime(startOfMonth.year, startOfMonth.month + 1, 1).subtract(const Duration(days: 1));
    int numDias = lastOfMonth.day;
    return numDias;
  }
  //calculate total amount this month
  String calculateMonthTotal(ExpenseData value){
    double total = 0;
    int numDias = numDiasThisMonth();
    //DateTime startThisMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);

    if(euro){
      // generamos la lista en base al numero de dias
      List<double> values = List<double>.generate(
        numDias, 
        (int index) =>  value.calculateDailyExpenseSummaryEuros()[convertDateTimeToString(startOfMonth.add(Duration(days: index)))] ?? 0, 
        growable: false);
      
      // calculamos el computo global del mes
      for (int i = 0; i < values.length; i++){
          total += values[i];
        }
    }else{
      // generamos la lista en base al numero de dias
      List<double> values = List<double>.generate(
        numDias, 
        (int index) =>  value.calculateDailyExpenseSummarykWh()[convertDateTimeToString(startOfMonth.add(Duration(days: index)))] ?? 0, 
        growable: false);

        // calculamos el computo global del mes
      for (int i = 0; i < values.length; i++){
          total += values[i];
        }
      total = total;
    }
    return total.toStringAsFixed(2);
  }

  //calculate total amount this month
  double calculateMonthMax(ExpenseData value){
    double? max = 100;
    double consumo = 0;
    int numDias = numDiasThisMonth();
    int diaDelMes = startOfMonth.day; 
    int diaDeLaSemana = startOfMonth.weekday;  

    //DateTime startThisMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    List<double> consumoSemana = [];
    if(euro){
      // generamos la lista en base al numero de dias
      List<double> values = List<double>.generate(
        numDias, 
        (int index) =>  value.calculateDailyExpenseSummaryEuros()[convertDateTimeToString(startOfMonth.add(Duration(days: index)))] ?? 0, 
        growable: false);
      
      while(diaDelMes <= numDias){
        consumo = consumo + values.elementAt(diaDelMes - 1);
        if(diaDeLaSemana == 7 || diaDelMes == numDias){
          consumoSemana.add(consumo);
          consumo = 0;
        }
        diaDelMes++;
        diaDeLaSemana++;
        if(diaDeLaSemana==8) diaDeLaSemana = 1;
      }

      //ordenamos valores de menos a mayor
      consumoSemana.sort();

      // cogemos el mayor de la lista, el cual se encuentra al final
      max = consumoSemana.last * 1.1;
      
    }else{
      // generamos la lista en base al numero de dias
      List<double> values = List<double>.generate(
        numDias, 
        (int index) =>  value.calculateDailyExpenseSummarykWh()[convertDateTimeToString(startOfMonth.add(Duration(days: index)))] ?? 0, 
        growable: false);

      //ordenamos valores de menos a mayor
      while(diaDelMes <= numDias){
        consumo = consumo + values.elementAt(diaDelMes - 1);
        if(diaDeLaSemana == 7 || diaDelMes == numDias){
          consumoSemana.add(consumo);
          consumo = 0;
        }
        diaDelMes++;
        diaDeLaSemana++;
        if(diaDeLaSemana==8) diaDeLaSemana = 1;
      }
      consumoSemana.sort();

      // cogemos el mayor de la lista, el cual se encuentra al final
      max = consumoSemana.last * 1.1;
      
    }
    return max == 0 ? 100 : max;
  }

  // list of expenses in a month €
  List<double> valuesEuroMonth(ExpenseData value){
    int numDias = numDiasThisMonth();
    //DateTime startThisMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    // generamos la lista en base al numero de dias
    List<double> values = List<double>.generate(
      numDias, 
      (int index) =>  value.calculateDailyExpenseSummaryEuros()[convertDateTimeToString(startOfMonth.add(Duration(days: index)))] ?? 0, 
      growable: false);
    
    return values;
  }
  // list of expenses in a month kWh
  List<double> valueskWhMonth(ExpenseData value){
    int numDias = numDiasThisMonth();
    //DateTime startThisMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    // generamos la lista en base al numero de dias
    List<double> values = List<double>.generate(
      numDias, 
      (int index) =>  value.calculateDailyExpenseSummarykWh()[convertDateTimeToString(startOfMonth.add(Duration(days: index)))] ?? 0, 
      growable: false);
    
    return values;
  }

 @override
  Widget build(BuildContext context) {

    return Consumer<ExpenseData>(
      builder: (context, value, child) =>  Column( // Texto de total mes + gráfico
        children: [
          // week total
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Row(
                children: [
                  RichText(
                    text: 
                      TextSpan( // Texto plano
                        children: [
                          const TextSpan(
                            text: 'Total mes: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // Pone el texto en negrita
                              color: Colors.black, // Color del texto
                            ),
                          ),
                          TextSpan( // consumo.string
                            text: '${calculateMonthTotal(value)} ${euro ? '€' : 'kWh'}',
                            style: const TextStyle(
                            color: Colors.black, // Color del texto
                            ),
                          ),
                        ],
                      ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox( //necesario entender este percal
            height: 275,
            child: MyBarGraphMonth( // grafico de barras mes
              maxY: calculateMonthMax(value), //value -> ExpenseData 
              numDias: numDiasThisMonth(), 
              values: euro ? valuesEuroMonth(value) : valueskWhMonth(value), // lista con Euro o kWh por cada dia del mes
              startOfMonth: startOfMonth,
              )),
        ],
      ));
  }
}

class ExpenseSummaryDay extends StatelessWidget {
  final DateTime dayToConsult;
  final bool euro;
  const ExpenseSummaryDay({
    super.key,
    required this.dayToConsult,
    required this.euro});

  double calculateMaxThisDay(ExpenseData value){
    double? max = 100;
    DateTime initDayToConsult = DateTime(
      dayToConsult.year, 
      dayToConsult.month,
      dayToConsult.day,
      0 // hora
    );

    if(euro){
      List<double>values = List<double>.generate(
      24,
      (int index) => value.calculateHourlyExpenseSummaryEuros()[convertDateTimeToHourString(initDayToConsult.add(Duration(hours: index)))] ?? 0,
      growable: false
      );
      values.sort();
      max = values.last * 1.1;

    }else{
      List<double>values = List<double>.generate(
      24,
      (int index) => value.calculateHourlyExpenseSummaryWh()[convertDateTimeToHourString(initDayToConsult.add(Duration(hours: index)))] ?? 0,
      growable: false
      );
      values.sort();
      max = values.last * 1.1;
    }
    return max == 0 ? 100 : max;
  }

  String calculateDayTotal(ExpenseData value){
    double total = 0;
    DateTime initDayToConsult = DateTime(
      dayToConsult.year, 
      dayToConsult.month,
      dayToConsult.day,
      0 // hora
    );

    if(euro){
      List<double>values = List<double>.generate(
      24,
      (int index) => value.calculateHourlyExpenseSummaryEuros()[convertDateTimeToHourString(initDayToConsult.add(Duration(hours: index)))] ?? 0,
      growable: false
      );

      for(int i = 0; i<24; i++){
        total += values[i];
      }
    }else{
      List<double>values = List<double>.generate(
      24,
      (int index) => value.calculateHourlyExpenseSummaryWh()[convertDateTimeToHourString(initDayToConsult.add(Duration(hours: index)))] ?? 0,
      growable: false
      );
      for(int i = 0; i<24; i++){
        total += values[i];
      }
    }

    return total.toStringAsFixed(2);
  }

  List<double> valuesEuroDay(ExpenseData value){
    DateTime initDayToConsult = DateTime(
      dayToConsult.year, 
      dayToConsult.month,
      dayToConsult.day,
      0 // hora
      );

    List<double>values = List<double>.generate(
      24,
      (int index) => value.calculateHourlyExpenseSummaryEuros()[convertDateTimeToHourString(initDayToConsult.add(Duration(hours: index)))] ?? 0,
      growable: false
    );
    return values;
  }

  List<double> valueskWhDay(ExpenseData value){
    DateTime initDayToConsult = DateTime(
      dayToConsult.year, 
      dayToConsult.month,
      dayToConsult.day,
      0 // hora
      );

    List<double>values = List<double>.generate(
      24,
      (int index) => value.calculateHourlyExpenseSummaryWh()[convertDateTimeToHourString(initDayToConsult.add(Duration(hours: index)))] ?? 0,
      growable: false
    );
    return values;
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<ExpenseData>(
      builder: (context, value, child) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Row(
                children: [
                  RichText(
                    text: 
                      TextSpan( // Texto plano
                        children: [
                          const TextSpan(
                            text: 'Total día: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold, // Pone el texto en negrita
                              color: Colors.black, // Color del texto
                            ),
                          ),
                          TextSpan( // consumo.string
                            text: '${calculateDayTotal(value)} ${euro ? '€' : 'Wh'}',
                            style: const TextStyle(
                            color: Colors.black, // Color del texto
                            ),
                          ),
                        ],
                      ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 275,
            child: MyBarGraphDay(
              maxY: calculateMaxThisDay(value), 
              values: euro ? valuesEuroDay(value) : valueskWhDay(value),
              dayToConsult: dayToConsult),
          )
        ],
      )
    );
  }
}