import 'package:flutter/material.dart';
import 'package:power_meter/data/energia_tiempo.dart';
import 'package:power_meter/mqtt/state/mqtt_app_state.dart';
import 'package:power_meter/presentation/items/bar_chart.dart';
import 'package:power_meter/presentation/items/line_chart.dart';
import 'package:power_meter/presentation/screens/mqtt_view_screen.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(
    /*ChangeNotifierProvider(
      create: (_) => MQTTAppState(), // Para que este estado sea global, asi al cambiar entre pestañas no se hace dispose() y se mantiene la conexión en segundo plano y se evitan bugs
      child: const MyApp(),
    ) */
    const MyApp()
    );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    
    int _paginaActual = 1; //Widget de la lista que se esta mostrando

    //TODO: Las widgets correspondientes a cada pagina solo deben cargar cuando se este en dichas paginas
    final List<Widget> _paginas = [
        Padding( //< Página 0
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: Column(
                  children: [
                  LineChartWidget(energiaTiempo), //< Grafico de lineas
                  const SizedBox(height: 30,),
                  BarChartWidget(costoTiempo), //< Grafico de barras
                  const SizedBox(height: 20,),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(  //< Boton que ajusta el periodo de medida
                      child: const Icon(Icons.calendar_month_outlined),
                      onPressed:() {
                      
                    },),
                  ),
                  const SizedBox(height: 30,),
                  ],
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => MQTTAppState(), // Para que este estado sea global, asi al cambiar entre pestañas no se hace dispose() y se mantiene la conexión en segundo plano y se evitan bugs
          child: const MQTTView(),
        ), //< Página 1

        const Center(child: Text('Perfil')) //< Página 2

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
