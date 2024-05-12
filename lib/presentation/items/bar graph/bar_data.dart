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

  BarDataMonth({
    required this.numDias,
    required this.values
  });

  List<IndividualBar> barData = [];

  // initialize bar data

  void initializeBarData(){
    for(int i = 0; i < numDias-1; i++){
      IndividualBar newIndividualBar = IndividualBar(x: i, y: values.elementAt(i));
      barData.add(newIndividualBar);
    }
  }

  
}