
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:power_meter/data/expenses/expense_item.dart';

enum MQTTRegisterConnectionState { connected, disconnected, connecting }

class MQTTRegisterState with ChangeNotifier{
  
  //Estados que vamos a compartir con el resto de los widget
  MQTTRegisterConnectionState _appConnectionState = MQTTRegisterConnectionState.disconnected;
  String _receivedText = ''; // lo que se recibe en el topic
  // ignore: prefer_final_fields
  List<ExpenseItem> _expenseListThisDay = [];
  
  //Metodo para modificar el estado de _receivedText y _dataJSON
  void setReceivedText(String text) { //recibe el texto, modifica y actualiza
    _receivedText = text; // string recibidoconcatenacion con los anteriores
    try{
      print('Se ha recibido en broker/register: $_receivedText');
      
      if(_receivedText != 'updateInfo'){
        List<String> lines = _receivedText.split('\r\n');

        for (String line in lines) {
          // Eliminamos espacios en blanco al inicio y final de la línea
          line = line.trim();  

          if (line.isNotEmpty) { // Solo analizamos líneas no vacías
            //print(line);
            Map<String, dynamic> jsonData = jsonDecode(line);
            ExpenseItem expenseItem = ExpenseItem.fromJson(jsonData);
            _expenseListThisDay.add(expenseItem);
          }
        }
        if (hasListeners) { //si hay listeners, se notifica
          //print('JSON procesado correctamente');
          notifyListeners();
        }
      }

    }catch(e){
      // ignore: avoid_print
      print('El texto recibido no es un JSON válido: $e');
    
    }   
    
  }

  //Metodo para modificar el estado de _appConnectionState
  //Param : nuevo estado
  void setAppConnectionState(MQTTRegisterConnectionState state) { // setea el estado de conexion y notifica
    _appConnectionState = state; //se cambia el estado del objeto de esta clase
    notifyListeners(); //se notifica a todos los widgets de arriba que esten escuchando
  }

  //getters del valor actual de estos estados
  String get getReceivedText => _receivedText;
  MQTTRegisterConnectionState get getAppConnectionState => _appConnectionState;
  List<ExpenseItem> get getExpenseList => _expenseListThisDay;


  void clearExpenseList() {
    _expenseListThisDay = [];
    //notifyListeners(); // Notifica a los listeners que la lista ha cambiado
  }
}