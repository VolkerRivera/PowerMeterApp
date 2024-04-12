import 'package:flutter/material.dart';
import 'package:power_meter/mqtt/state/mqtt_app_state.dart';
import 'package:power_meter/presentation/screens/screen_consumption.dart';
import 'package:provider/provider.dart';

//import 'package:mqtt_client/mqtt_client.dart';
//import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Power Meter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Consumo actual'),
        ),
        //body: const PantallaCosumoActual(),
        body: ChangeNotifierProvider<MQTTAppState>(
          create: (_) => MQTTAppState(),
          child: MQTTView(),
        )
      ),
      /*home: ChangeNotifierProvider<MQTTAppState>(
          create: (_) => MQTTAppState(),
          child: MQTTView(),
        )*/

    );
  }
}

