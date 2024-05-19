import 'package:flutter/material.dart';
import 'package:power_meter/presentation/models/expense_item.dart';

enum MQTTRegisterConnectionState { connected, disconnected, connecting }

class MQTTRegisterState with ChangeNotifier{
  
  //Estados que vamos a compartir con el resto de los widget
  MQTTRegisterConnectionState _appConnectionState = MQTTRegisterConnectionState.disconnected;
  String _receivedText = ''; // lo que se recibe en el topic
  String _historyText = ''; // acumulacion de todo lo que hemos recibido o enviado
  final ExpenseItem _newExpense = ExpenseItem(amountKWh: '0.005', amountEuro: '0.003', dateTime: DateTime.now());
  // ignore: prefer_final_fields
  List<ExpenseItem> _expenseListThisDay = [];
  
  //Metodo para modificar el estado de _receivedText y _dataJSON
  void setReceivedText(String text) { //recibe el texto, modifica y actualiza
    _receivedText = text; // string recibido
    _historyText = '$_historyText\n$_receivedText'; //concatenacion con los anteriores
    try{
      //_dataJSON = welcomeFromJson(_receivedText);
      print('Se ha recibido en broker/register: ' + _receivedText);

    }catch(e){
      print('El texto recibido no es un JSON válido: $e');
    
    }   
    if (hasListeners) { //si hay listeners, se notifica
      notifyListeners();
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
  String get getHistoryText => _historyText;
  MQTTRegisterConnectionState get getAppConnectionState => _appConnectionState;
  List<ExpenseItem> get getExpenseList => _expenseListThisDay;
  ExpenseItem get getNewExpense => _newExpense;
}