import 'package:dio/dio.dart';

//dio tambien sirve para hacer descargas

//https://api.preciodelaluz.org/v1/prices/all?zone=PCB -> Península, Canarias y Baleares
//https://api.preciodelaluz.org/v1/prices/all?zone=CYM -> Ceuta y Melilla
    

class GetPricesFromAPI{
  final _dio = Dio();
  
  Future <List<double>> getPrices() async{
    
    final response = await _dio.get('https://api.preciodelaluz.org/v1/prices/all?zone=PCB');
    final Map<String, dynamic> jsonMap = response.data;
    /*response.data es ya un Map<String, dynamic>, String es la etiqueta principal, en este caso los entries, y
    por otro lado el dynamic corresponde al valor, dicho valor puede ser un String, un int, otra lista, un mapa...*/
    
    
    final Map<String, dynamic> pricesMap = { //Creamos un nuevo mapa pero esta vez String = 'price' y dynamic = double = price.value
    /*Iteramos para cada entry, y cada entry tendra una clave y un valor. Basicamente estamos creando otro mapa pero
    unicamente con los precios de cada entrada*/
    for (var entry in jsonMap.entries) 
      entry.key: {"price": entry.value['price']}
    };

    /* creamos una Lista de doubles y vamos asignando valores a partir del valor de cada index del mapa*/
    final List<double> priceList = pricesMap.values.map((entry) {
    
    return (entry['price'] as num).toDouble()/1000; // MWh -> kWh
    }).toList();

    return priceList;

  }
}
