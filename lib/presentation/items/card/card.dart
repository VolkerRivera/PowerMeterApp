import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final String magnitude;
  final double value;

  const MyCard({super.key, required this.magnitude, required this.value});

  @override
  Widget build(BuildContext context) {
    const textStyleMagnitude = TextStyle(
      fontFamily: 'CupertinoSystemText',
      fontSize: 15
    );

    const textStyleValue = TextStyle(
      fontFamily: 'CupertinoSystemText',
      fontSize: 25
    );
    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(magnitude, style: textStyleMagnitude,),
            Text(valueToRepresent(magnitude, value), style: textStyleValue,),
          ],
        ),
      ),
    );
  }
}

String valueToRepresent (String magnitude, double value){
  String valueToRepresent = '';
  switch(magnitude){
    case 'VRMS':
      valueToRepresent = '$value V';
      break;
    case 'IRMS':
      valueToRepresent = '$value A';
      break;
    case 'Potencia activa':
      valueToRepresent = '$value W';
      break;
    case 'Potencia reactiva':
      valueToRepresent = '$value VAR';
      break;
    case 'Potencia aparente':
      valueToRepresent = '$value VA';
      break;
    case 'Factor de potencia':
      valueToRepresent = '$value';
      break;  
    case 'Frecuencia':
      valueToRepresent = '$value Hz';
      break;  
  }

  return valueToRepresent;
}