import 'package:collection/collection.dart';
import 'package:power_meter/data/get_precios.dart';

class EnergiaTiempo{
  final double energy; //eje y
  final int time; //eje x

  EnergiaTiempo({
    required this.energy, 
    required this.time});

}

List<EnergiaTiempo> get energiaTiempo{ //devolvemos una lista index-value, 24h - 24 valores
  final data = <double>[ //Lo que debe ser flexible es este array, ya que contendra n datos dependiendo de 
  // la escala de tiempo (horas, dias, meses)
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
  final double precio; //eje y
  final int time; //eje x
  
  

  CostoTiempo({
    required this.precio,
    required this.time});
  
}

Future<List<CostoTiempo>> get costoTiempo async{

  /*final priceData = <double>[ //precios SIEMPRE seran por hora
    0.15, 0.15, 0.15, 0.15, 0.15, 0.15, 0.15,
    0.20, 0.20, 0.20, 0.20, 0.20, 0.20, 0.20,
    0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25,
    0.30, 0.30, 0.30,
  ];*/
  final GetPricesFromAPI getPricesFromAPI = GetPricesFromAPI();
  final priceData = await getPricesFromAPI.getPrices();
  
  // IMPORTANTE:Esto solo se podra hacer cuando time sea por horas, posteriormente
  // se hara lo mismo para cada dia que pertenezca al intervalo de tiempo y se sumará
  // el precio de cada hora
  return priceData 
  .mapIndexed((index, element ) => 
  CostoTiempo(precio: element * energiaTiempo[index].energy , time: index))
  .toList();
}