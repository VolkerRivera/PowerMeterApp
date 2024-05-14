import 'package:power_meter/datetime/date_time_helper.dart';
import 'package:power_meter/presentation/items/bar%20graph/individual_bar.dart';

class BarDataWeek{
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thuAmount;
  final double friAmount;
  final double satAmount;
  final double sunAmount;

  BarDataWeek({
    required this.monAmount, 
    required this.tueAmount,
    required this.wedAmount, 
    required this.thuAmount, 
    required this.friAmount, 
    required this.satAmount, 
    required this.sunAmount
  });

  List<IndividualBar> barData = [];

  // initialize bar data
  void initializeBarData(){ // para datos semanales
    barData = [
      IndividualBar(x: 0, y: monAmount),
      IndividualBar(x: 1, y: tueAmount),
      IndividualBar(x: 2, y: wedAmount),
      IndividualBar(x: 3, y: thuAmount),
      IndividualBar(x: 4, y: friAmount),
      IndividualBar(x: 5, y: satAmount),
      IndividualBar(x: 6, y: sunAmount),
    ];
  }

}

class BarDataMonth{
  final int numDias;
  final List<double> values;
  final DateTime startOfMonth;

  BarDataMonth({
    required this.numDias,
    required this.values,
    required this.startOfMonth
  });

  List<IndividualBar> barData = [
    ];

  List<String> titleWeekRange = []; //pendiente inicializar las semanas

  //initialize bottom titles, week ranges

  void initializeTitleWeekRange(){
    

    int diaDelMes = startOfMonth.day;
    int diaDeLaSemana = startOfMonth.weekday;
    DateTime dayAux = startOfMonth;
    DateTime from = dayAux.subtract(Duration(days: diaDeLaSemana - 1));
    DateTime to = from.add(const Duration(days: 6));

    while(diaDelMes <= numDias){
      if(diaDeLaSemana == 7 || diaDelMes == numDias){ //si domingo o ultimo dia de mes

          String newRange = '${from.day} ${nombreMes(from)}';
          //String newRange = '${from.day} ${nombreMes(from)} - ${to.day} ${nombreMes(to)}'; // creamos string a partir del rango
          //String newRange = '${from.day}/${from.month} - ${to.day}/${to.month}';
          titleWeekRange.add(newRange); // la añadimos al grafico

          from = from.add(const Duration(days: 7));
          to = to.add(const Duration(days: 7));
      }
         
    diaDelMes++;
    diaDeLaSemana++;
    if(diaDeLaSemana == 8) diaDeLaSemana = 1;
    }
  }

  // initialize bar data
  void initializeBarData(){
    double consumoSemana = 0;
    int diaDelMes = startOfMonth.day; 
    int diaDeLaSemana = startOfMonth.weekday;  
    int indexIndividualBar = 0;

    //important: avoid direct memory access, otherwise dart cries, crush and burns
    // for example: while(diaActual.day .. && startOfMonth.day ...)
    while(diaDelMes <= numDias){
      consumoSemana = consumoSemana + values.elementAt(diaDelMes - 1); //aumentamos consumo
      if(diaDeLaSemana == 7 || diaDelMes == numDias){ //si domingo o ultimo dia de mes
        IndividualBar newIndividualBar = IndividualBar(x: indexIndividualBar, y: consumoSemana); // creamos barra
        barData.add(newIndividualBar); // la añadimos al grafico
        consumoSemana = 0; //reseteamos consumo
        indexIndividualBar++; //añadimos la siguiente barra al grafico si no es fin de mes
      }   
    diaDelMes++;
    diaDeLaSemana++;
    if(diaDeLaSemana==8) diaDeLaSemana = 1;
    }
  }
}