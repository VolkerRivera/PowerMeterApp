import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final String magnitude;
  final int value;

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
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(magnitude, style: textStyleMagnitude,),
            Text('$value V', style: textStyleValue,),
          ],
        ),
      ),
    );
  }
}