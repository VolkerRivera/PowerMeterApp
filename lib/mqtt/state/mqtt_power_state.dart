import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

PowerData welcomeFromJson(String str) => PowerData.fromJson(json.decode(str)); //entra string, sale json

String welcomeToJson(PowerData data) => json.encode(data.toJson()); //entra json, sale string

class PowerData {
    final String timestamp;
    final double vrms;
    final double irms;
    final double potActiva;
    final double potReactiva;
    final double potAparente;
    final double powerFactor;

    PowerData({
        required this.timestamp,
        required this.vrms,
        required this.irms,
        required this.potActiva,
        required this.potReactiva,
        required this.potAparente,
        required this.powerFactor,

    });

    factory PowerData.fromJson(Map<String, dynamic> json) => PowerData(
        timestamp:    json["timestamp"],
        vrms:         json["Vrms"],
        irms:         json["Irms"], 
        potActiva:    json["W"], 
        potReactiva:  json["VAR"], 
        potAparente:  json["VA"], 
        powerFactor:  json["PF"],
    );

    Map<String, dynamic> toJson() => {
        "timestamp": timestamp,
        "Vrms"     : vrms,
        "Irms"     : irms,
        "W"        : potActiva,
        "VAR"      : potReactiva,
        "VA"       : potAparente,
        "PF"       : powerFactor,
    };
}

enum MQTTPowerConnectionState { connected, disconnected, connecting }

/* ChangeNotifier ya que proporciona una notificación a los listeners cada vez que cambia
alguna de los campos que lo componen, de esta forma, los listeners podran actualizar el UI
en funcion de dichos cambios */



class MQTTPowerState with ChangeNotifier{
  
  //Estados que vamos a compartir con el resto de los widget
  MQTTPowerConnectionState _appConnectionState = MQTTPowerConnectionState.disconnected;
  String _receivedText = ''; // lo que se recibe en el topic
  String _historyText = ''; // acumulacion de todo lo que hemos recibido o enviado
  PowerData _newPowerData = PowerData(timestamp: '0', vrms: 0.0, irms: 0.0, potActiva: 0.0, potReactiva: 0.0, potAparente: 0.0, powerFactor: 0.0);
  
  //Metodo para modificar el estado de _receivedText y _dataJSON
  void setReceivedText(String text) { //recibe el texto, modifica y actualiza
    _receivedText = text; // string recibido
    _historyText = '$_historyText\n$_receivedText'; //concatenacion con los anteriores
    try{
      _newPowerData = welcomeFromJson(_receivedText);
    }catch(e){
      
      print('El texto recibido no es un JSON válido: $e');
    }
    
    if (hasListeners) { //si hay listeners, se notifica
      notifyListeners();
    }
  }

  //Metodo para modificar el estado de _appConnectionState
  //Param : nuevo estado
  void setAppConnectionState(MQTTPowerConnectionState state) { // setea el estado de conexion y notifica
    _appConnectionState = state; //se cambia el estado del objeto de esta clase
    notifyListeners(); //se notifica a todos los widgets de arriba que esten escuchando
  }

  //getters del valor actual de estos estados
  String get getReceivedText => _receivedText;
  String get getHistoryText => _historyText;
  MQTTPowerConnectionState get getPowerConnectionState => _appConnectionState;
  PowerData get getPowerData => _newPowerData;
}


