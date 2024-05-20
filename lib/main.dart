import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:power_meter/data/expense_data.dart';
import 'package:power_meter/mqtt/state/mqtt_power_state.dart';
import 'package:power_meter/mqtt/state/mqtt_register_state.dart';
import 'package:power_meter/presentation/screens/graphics_screen.dart';
import 'package:power_meter/presentation/screens/mqtt_view_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  // initialize hive
  await Hive.initFlutter();

  // open a hive box
  await Hive.deleteBoxFromDisk('expense_database4');
  await Hive.openBox('expense_database4');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MQTTRegisterState(),
        ),
        ChangeNotifierProvider(
          create: (_) => MQTTPowerState(), 
        ),
        
      ],
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
        /*Padding( //< Página 0
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
        ),*/

        ChangeNotifierProvider(
          create: (context) => ExpenseData(), // los estados que si cambian notifican al que escucha
          builder: (context, child) => const GraphicsPage() // el widget que escucha
        ),

        /*ChangeNotifierProvider(
          create: (_) => MQTTPowerState(), // Para que este estado sea global, asi al cambiar entre pestañas no se hace dispose() y se mantiene la conexión en segundo plano y se evitan bugs
          child: const MQTTView(),
        ),*/ //< Página 1
        const MQTTView(),
        
        const Center(child: Text('Perfil')) //< Página 2

    ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Power Meter',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('es'),
        Locale('es')
      ],
      home: SafeArea(
              child: Scaffold(
                /*appBar: AppBar(
                  centerTitle: true,
                  title: const Text('ADE9153A'),
                ),*/
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
                  //BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Perfil')
                ]),
              ),
            )
    );
  }
}
