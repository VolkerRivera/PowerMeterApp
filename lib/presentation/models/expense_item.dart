
import 'dart:convert';

ExpenseItem expenseItemFromJson(String str) => ExpenseItem.fromJson(json.decode(str));

String expenseItemToJson(ExpenseItem data) => json.encode(data.toJson());

class ExpenseItem { 
  final String amountWh; // nombre del gasto 
  final String amountEuro; // cuantía del gasto
  final DateTime dateTime; //fecha del gasto

  ExpenseItem({
    required this.amountWh,
    required this.amountEuro,
    required this.dateTime
  });
  factory ExpenseItem.fromJson(Map<String, dynamic> json) => ExpenseItem(
        amountWh: json["amountWh"].toString(),
        amountEuro: json["amountEuro"].toString(),
        dateTime: DateTime.parse(json["dateTime"]),
    );

    Map<String, dynamic> toJson() => {
        "amountWh": amountWh,
        "amountEuro": amountEuro,
        "dateTime": dateTime.toIso8601String(),
    };
}