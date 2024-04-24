import 'package:dio/dio.dart';

//dio tambien sirve para hacer descargas

//https://api.preciodelaluz.org/v1/prices/all?zone=PCB -> Península, Canarias y Baleares
//https://api.preciodelaluz.org/v1/prices/all?zone=CYM -> Ceuta y Melilla
    

class GetPricesFromAPI{
  final _dio = Dio();
  
  Future <List<double>> getPrices() async{
    
    final response = await _dio.get('https://api.preciodelaluz.org/v1/prices/all?zone=PCB');
    print(response.data.toString());
    //final Map<String, dynamic> jsonMap = jsonDecode(response.data.toString());
    final Map<String, dynamic> jsonMap = response.data;
    final Map<String, dynamic> pricesMap = {
    for (var entry in jsonMap.entries)
      entry.key: {"price": entry.value['price']}
    };

    final List<double> priceList = pricesMap.values.map((entry) {
    
    return (entry['price'] as num).toDouble()/1000; // MWh -> kWh
    }).toList();

    print(priceList);
    return priceList;

  }
}
