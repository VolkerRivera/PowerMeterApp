import 'package:flutter/material.dart';
import 'package:power_meter/mqtt/state/mqtt_app_state.dart';
import 'package:power_meter/presentation/screens/screen_consumption.dart';
import 'package:provider/provider.dart';

//import 'package:mqtt_client/mqtt_client.dart';
//import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

    int paginaActual = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Power Meter',
      home: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Consumo actual'),
                ),
                body: ChangeNotifierProvider<MQTTAppState>(
                  create: (_) => MQTTAppState(),
                  child: const MQTTView(),
                ),
                bottomNavigationBar:  BottomNavigationBarWidget(paginaActual: paginaActual),
              ),
            );
          } else {
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Consumo actual'),
                ),
                body: ChangeNotifierProvider<MQTTAppState>(
                  create: (_) => MQTTAppState(),
                  child: const Column(
                    children: [
                      Expanded(
                        child: MQTTView(),
                      )
                    ],
                  ),
                ),
                bottomNavigationBar:  BottomNavigationBarWidget(paginaActual: paginaActual),
              ),
            );
          }
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class BottomNavigationBarWidget extends StatefulWidget {
  int paginaActual;
   BottomNavigationBarWidget({
    super.key,
    required this.paginaActual,
  });

  @override
  State<BottomNavigationBarWidget> createState() => _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index){
        setState((){
          widget.paginaActual = index;
        });
      },
      currentIndex: widget.paginaActual,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.stacked_line_chart_outlined), label: 'Graficos'),
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Consumo instantáneo'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Perfil')
      ]);
  }
}