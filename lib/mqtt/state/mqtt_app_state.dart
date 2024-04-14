import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

ManageData welcomeFromJson(String str) => ManageData.fromJson(json.decode(str)); //entra string, sale json

String welcomeToJson(ManageData data) => json.encode(data.toJson()); //entra json, sale string

class ManageData {
    final String timestamp;
    final double vrms;
    final double irms;

    ManageData({
        required this.timestamp,
        required this.vrms,
        required this.irms,
    });

    factory ManageData.fromJson(Map<String, dynamic> json) => ManageData(
        timestamp: json["timestamp"],
        vrms: json["Vrms"],
        irms: json["Irms"],
    );

    Map<String, dynamic> toJson() => {
        "timestamp": timestamp,
        "Vrms": vrms,
        "Irms": irms,
    };
}

enum MQTTAppConnectionState { connected, disconnected, connecting }

/* ChangeNotifier ya que proporciona una notificación a los listeners cada vez que cambia
alguna de los campos que lo componen, de esta forma, los listeners podran actualizar el UI
en funcion de dichos cambios */

class MQTTAppState with ChangeNotifier{
  MQTTAppConnectionState _appConnectionState = MQTTAppConnectionState.disconnected;
  String _receivedText = ''; // lo que se recibe en el topic
  String _historyText = ''; // acumulacion de todo lo que hemos recibido o enviado
  ManageData _dataJSON = ManageData(timestamp: '0', vrms: 0.0, irms: 0.0);
  void setReceivedText(String text) { //recibe el texto, modifica y actualiza
    _receivedText = text; // string recibido
    _historyText = '$_historyText\n$_receivedText'; //concatenacion con los anteriores
    try{
      _dataJSON = welcomeFromJson(_receivedText);
    }catch(e){
      // ignore: avoid_print
      print('El texto recibido no es un JSON válido: $e');
    }
    
    notifyListeners(); // notificacion a los listeners de que algo ha cambiado
  }
  void setAppConnectionState(MQTTAppConnectionState state) { // setea el estado de conexion y notifica
    _appConnectionState = state;
    notifyListeners();
  }

  //getters
  String get getReceivedText => _receivedText;
  String get getHistoryText => _historyText;
  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;
  ManageData get getDataJSON => _dataJSON;
}


