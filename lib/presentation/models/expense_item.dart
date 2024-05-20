
import 'dart:convert';

ExpenseItem expenseItemFromJson(String str) => ExpenseItem.fromJson(json.decode(str));

String expenseItemToJson(ExpenseItem data) => json.encode(data.toJson());

class ExpenseItem { //ira  enfocado al consumo en €
  final String amountKWh; // nombre del gasto --> innecesario en este caso
  final String amountEuro; // cuantía del gasto
  final DateTime dateTime; //fecha del gasto

  ExpenseItem({
    required this.amountKWh,
    required this.amountEuro,
    required this.dateTime
  });
  factory ExpenseItem.fromJson(Map<String, dynamic> json) => ExpenseItem(
        amountKWh: json["amountKWh"].toString(),
        amountEuro: json["amountEuro"].toString(),
        dateTime: DateTime.parse(json["dateTime"]),
    );

    Map<String, dynamic> toJson() => {
        "amountKWh": amountKWh,
        "amountEuro": amountEuro,
        "dateTime": dateTime.toIso8601String(),
    };
}