

class ExpenseItem { //ira  enfocado al consumo en €
  final String amountKWh; // nombre del gasto --> innecesario en este caso
  final String amountEuro; // cuantía del gasto
  final DateTime dateTime; //fecha del gasto

  ExpenseItem({
    required this.amountKWh,
    required this.amountEuro,
    required this.dateTime
  });

}