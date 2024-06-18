import 'package:hive_flutter/hive_flutter.dart';
import 'package:power_meter/data/expenses/expense_item.dart';

class HiveDatabase {
  // reference our box
  final _myBox = Hive.box('expense_database4');


  //write data
void saveData(List<ExpenseItem> allExpense){
  /*
  Hive can only store strings and dataTime, and not custom objects like ExpenseItem becase adapters are needed
  So lets convert ExpenseItem objects into types that can be stored in our database

  allExpense = 
  [
    ExpenseItem ( ammountKWh / amountEuro / dateTime )
    ...
  ]

  ->

  [
    [ammountKWh, amountEuro, dateTime]
    ...
  ]
  */

  List<List<dynamic>> allExpensesFormatted = [];

  for (var expense in allExpense){
    // convert each ExpenseItem into a list of storable types (strings, dateTime)
    List<dynamic> expenseFormatted = [
      expense.amountWh,
      expense.amountEuro,
      expense.dateTime
    ];
    // once its converted, add it to the list of lists
    allExpensesFormatted.add(expenseFormatted);
  }

  // finally lets store in our database
  _myBox.put('ALL_EXPENSES4', allExpensesFormatted); //(key, data)

}
  
  //read data
  List<ExpenseItem> readData(){
    /*
    Data is stored in Hive as a list of strings + dateTime so lets convert our 
    saved data into ExpenseItem objects.

    savedData = [
      [amountKWh, amountEuro, dateTime]
      ...
    ]

    ->

    [
      ExpenseItem (amountKWh / amountEuro / dateTime)
      ...
    ]
    */

    //cogemos los datos que se encuentren asociados a esa llave
    // lista de listas
    List savedExpenses = _myBox.get('ALL_EXPENSES4') ?? []; //si la caja esta vacia dara null asi que devolvemos una lista vacia
    
    //lista de ExpenseItem
    List<ExpenseItem> allExpenses = [];

    for(int i = 0; i < savedExpenses.length; i++){
      // collect individual expense data
      String amountKWh = savedExpenses[i][0];
      String amountEuro = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      // create expense item
      ExpenseItem expense = ExpenseItem
      (amountWh: amountKWh, 
      amountEuro: amountEuro, 
      dateTime: dateTime);

      // add expense to overall list of expenses
      allExpenses.add(expense);
    }
    return allExpenses;

  }

}