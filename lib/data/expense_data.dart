import 'package:flutter/material.dart';
import 'package:power_meter/data/hive_database.dart';
import 'package:power_meter/datetime/date_time_helper.dart';
import 'package:power_meter/presentation/models/expense_item.dart';

class ExpenseData extends ChangeNotifier{
  // lista de TODOS los gastos
  List<ExpenseItem> overallExpenseList = [];

  // obtener la lista de gastos
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  final database = HiveDatabase();

  // prepare data to dispplay
  void prepareData(){
    // if there exists data, get it
    if(database.readData().isNotEmpty){
      overallExpenseList = database.readData();
    } //otherwise it will remain blank
  }

  // añadir nuevo gasto
  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);//se añade objetp a la lista
    notifyListeners(); // para que todos los listeners sean avisados
    // everytime we add a new expense, apart from notify to listeners, we also have to save that change
    database.saveData(overallExpenseList); //se actualiza la lista guardada 
  }

  // eliminar gasto
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);
    notifyListeners(); // para que todos los listeners sean avisados
    database.saveData(overallExpenseList); //se actualiza la lista guardada 
  }

  //get weekday (mon, tues, etc) from DateTime object
  String getDayName(DateTime dateTime) {
    //Tras meterle un yyyy/mm/dd hh:mm:ss:az devuelve solo el dia de la semana en string
    switch (dateTime.weekday) {
      case 1:
        return 'L';
      case 2:
        return 'M';
      case 3:
        return 'X';
      case 4:
        return 'J';
      case 5:
        return 'V';
      case 6:
        return 'S';
      case 7:
        return 'D';
      default:
        return '';
    }
  }

  //get month (E,F,M) from DateTime object
  String getMonthName(DateTime datetime) {
    switch (datetime.month) {
      case 1:
        return 'E';
      case 2:
        return 'F';
      case 3:
        return 'M';
      case 4:
        return 'A';
      case 5:
        return 'M';
      case 6:
        return 'J';
      case 7:
        return 'J';
      case 8:
        return 'A';
      case 9:
        return 'S';
      case 10:
        return 'O';
      case 11:
        return 'N';
      case 12:
        return 'D';
      default:
        return '';
    }
  }

  // get the date for the start of the week (lunes)

  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    // get todays date
    DateTime today = DateTime.now();

    // go backwards from today to find monday
    /* this line calculates the date i days before the current date (today). For example, when i is 0, 
    it calculates today's date. When i is 1, it calculates yesterday's date, and so on. */
    for (int i = 0; i < 7; i++) {
      // vamos i dias hacia atras a partir de la fecha de hoy
      if (getDayName(today.subtract(Duration(days: i))) == 'L') { //va restando días hasta que da con el lunes
        // Cuando coincide que hace i dias fue lunes, obtenemos la fecha para dicho dia, lo asignamos a startOfWeek y retornamos
        startOfWeek = today.subtract(Duration(days: i)); // para semanas pasadas bucle [1,7] y asi se retorna el anterior lunes??
      }
    }
    return startOfWeek!; // la exclamacion es cuando estamos seguros de que tendra valor aun siendo nullable
  }

  /*
  Convert a list of expenses into a daily expense summary
  p.ej 
  overallExpenseList = 
  [
    [n kWh, 02/01/2024 01:00, n € ],
    [n kWh, 02/01/2024 02:00, n € ],
    [n kWh, 02/01/2024 03:00, n € ],
    [n kWh, 02/01/2024 04:00, n € ],
    [n kWh, 02/01/2024 05:00, n € ],
    [n kWh, 02/01/2024 06:00, n € ],
    [n kWh, 02/01/2024 07:00, n € ] ...
  ]

  -> DailyExpenseSummary = 
  [
    [20240201, n kWh, n€],
    [20240202, n kWh, n€],
    [020240203, n kWh, n€]...
  ]
   */

  Map<String, double> calculateDailyExpenseSummaryEuros() {
    // UNICAMENTE TOTAL DIARIO

    //inicializammos el mapa
    Map<String, double> dailyExpenseEuroSummary = {
      // date (yyyymmdd : totalAmountForDayEuro)
    };

    // iteramos el mapa de tooooooodos los gastos para sacar solo el daily
    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense
          .dateTime); // Para que irtere bien esta fecha tiene que tener el formato del video
      double amount = double.parse(expense.amountEuro);

      if (dailyExpenseEuroSummary.containsKey(date)) {
        //suma todos los que coincidan en fecha
        double currentAmount = dailyExpenseEuroSummary[date]!;
        currentAmount += amount;
        dailyExpenseEuroSummary[date] = currentAmount;
      } else {
        dailyExpenseEuroSummary.addAll(
            {date: amount}); //cuando cambia de dia añade el par date-amount
      }
    }
    return dailyExpenseEuroSummary;
  }

  Map<String, double> calculateDailyExpenseSummarykWh() {
    // UNICAMENTE TOTAL DIARIO

    //inicializammos el mapa
    Map<String, double> dailyExpensekWhSummary = {
      // date (yyyymmdd : totalAmountForDay)
    };

    // iteramos el mapa de tooooooodos los gastos para sacar solo el daily
    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense
          .dateTime); // Para que irtere bien esta fecha tiene que tener el formato del video
      double amount = double.parse(expense.amountKWh);

      if (dailyExpensekWhSummary.containsKey(date)) {
        //suma todos los que coincidan en fecha
        double currentAmount = dailyExpensekWhSummary[date]!;
        currentAmount += amount;
        dailyExpensekWhSummary[date] = currentAmount;
      } else {
        dailyExpensekWhSummary.addAll(
            {date: amount}); //cuando cambia de dia añade el par date-amount
      }
    }
    return dailyExpensekWhSummary;
  }

  Map<String, double> calculateMonthlyExpenseSummary() {
    // UNICAMENTE TOTAL MENSUAL

    //inicializammos el mapa
    Map<String, double> monthlyExpenseSummary = {
      // date (yyyymm : totalAmountForMonth)
    };

    // iteramos el mapa de tooooooodos los gastos para sacar solo el monthly
    for (var expense in overallExpenseList) {
      String month = convertDateTimeToMonthString(expense.dateTime); // Para que irtere bien esta fecha tiene que tener el formato del video
      double amount = double.parse(expense.amountEuro);

      if (monthlyExpenseSummary.containsKey(month)) {
        //suma todos los que coincidan en fecha
        double currentAmount = monthlyExpenseSummary[month]!;
        currentAmount += currentAmount;
        monthlyExpenseSummary[month] = currentAmount;
      } else {
        monthlyExpenseSummary.addAll(
            {month: amount}); //cuando cambia de dia añade el par date-amount
      }
    }

    return monthlyExpenseSummary;
  }
}
