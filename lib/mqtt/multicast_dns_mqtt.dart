import 'package:flutter_nsd/flutter_nsd.dart';

class DiscoverServices {
  final flutterNsd = FlutterNsd();


  Future<void> init() async {
  final flutterNsd = FlutterNsd();

  flutterNsd.stream.listen((nsdServiceInfo) {
    print('Discovered service name: ${nsdServiceInfo.name}');
    print('Discovered service hostname/IP: ${nsdServiceInfo.hostname}');
    print('Discovered service port: ${nsdServiceInfo.port}');
  }, onError: (e) {
    if (e is NsdError) {
      // Check e.errorCode for the specific error
    }
  });
}

  void startDiscoveryButton() async {
    await flutterNsd.discoverServices('_mqtt._tcp.'); //busco este servicio dentro de mi red
  }

  void stopDiscoveryButton() async {
    await flutterNsd.stopDiscovery();
  }
}