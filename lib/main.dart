import 'package:flutter/material.dart';
import 'package:power_meter/mqtt/state/mqtt_app_state.dart';
import 'package:power_meter/presentation/screens/screen_consumption.dart';
import 'package:provider/provider.dart';

//import 'package:mqtt_client/mqtt_client.dart';
//import 'package:provider/provider.dart';



void main(){
  runApp(
    ChangeNotifierProvider(
      create: (_) => MQTTAppState(), // Para que este estado sea global, asi al cambiar entre pestañas no se hace dispose() y se mantiene la conexión en segundo plano y se evitan bugs
      child: const MyApp(),
    ) 
    );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

    int _paginaActual = 1; //Widget de la lista que se esta mostrando

    final List<Widget> _paginas = [
      const Center(child: Text('Gráficos')),
      const MQTTView(),
      const Center(child: Text('Perfil'))
    ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Power Meter',
      home: SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: const Text('ADE9153A'),
                ),
                body: _paginas[_paginaActual],
                bottomNavigationBar:  BottomNavigationBar( //Gestiona toda la barra de navegación
                  currentIndex: _paginaActual, //indica la página actual
                  onTap: (value) {
                    setState(() {
                      _paginaActual = value; //actualiza la pagina que se mostrara según donde se haya hecho tap
                    });
                  },
                  items: const [ //array de icons
                  BottomNavigationBarItem(icon: Icon(Icons.stacked_line_chart_outlined), label: 'Graficos'),
                  BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Consumo instantáneo'),
                  BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Perfil')
                ]),
              ),
            )
    );
  }
}

