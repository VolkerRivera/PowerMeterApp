import 'package:collection/collection.dart';

class EnergiaTiempo{
  final double energy; //eje y
  final int time; //eje x
  

  EnergiaTiempo({
    required this.energy, 
    required this.time});

}

List<EnergiaTiempo> get energiaTiempo{ //devolvemos una lista index-value, 24h - 24 valores
  final data = <double>[
    5.2,5.3,4.1,6.6,3.1,0.2,1.4,
    3.3,4.5,6.6,7.1,5.5,4.3,6.3,
    1.2,3.3,4.1,2.1,8.2,4.6,9.9,
    8.3,4.6,5.5];
  return data
  .mapIndexed(((index, element) => 
    EnergiaTiempo(energy: element, time: index)))
  .toList();
}

class CostoTiempo{
  final double precio;
  final int time; //eje x
  CostoTiempo({
    required this.precio,
    required this.time});

  
}

List<CostoTiempo> get costoTiempo{
  final priceData = <double>[
    0.15, 0.15, 0.15, 0.15, 0.15, 0.15, 0.15,
    0.20, 0.20, 0.20, 0.20, 0.20, 0.20, 0.20,
    0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25,
    0.30, 0.30, 0.30,
  ];

  return priceData
  .mapIndexed((index, element ) => 
  CostoTiempo(precio: element * energiaTiempo[index].energy , time: index))
  .toList();
}