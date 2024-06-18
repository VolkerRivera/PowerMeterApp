import 'dart:io';
import 'package:flutter/material.dart';
import 'package:power_meter/mqtt/mqtt_manager.dart';
import 'package:power_meter/mqtt/state/mqtt_power_state.dart';
import 'package:power_meter/mqtt/state/mqtt_register_state.dart';
import 'package:power_meter/presentation/items/card/card.dart';
import 'package:provider/provider.dart';
import 'package:nsd/nsd.dart';

late String ipMQTTServer;
late MQTTManager mqttManager;
class MQTTView extends StatefulWidget{
  const MQTTView({super.key});

  @override
  State<StatefulWidget> createState(){
    return _MQTTViewState();
  }
}

class _MQTTViewState extends State<MQTTView>{
  /* Espacio para los TextEditingControllers */

  /* Variables de estado y management mqtt */
  late MQTTPowerState currentAppState;
  late MQTTRegisterState currentRegisterState;

  
  bool firstmDNSscan = true;

  /* Iniciamos el estado del widget */
  @override
  void initState(){
    super.initState();

  }

  /* Liberamos recursos utilizados por elobjeto State cuando se elimine del widget tree */
  /* Solo cuando se hayan añadido los controller */

  /* ----------------------------------------  */

  @override
  Widget build(BuildContext context) {
    final MQTTPowerState appState = Provider.of<MQTTPowerState>(context); //Cambios de estado de los que nos informa el provider. (desde notifyListeners)
    currentAppState = appState;
    final MQTTRegisterState registerState = Provider.of<MQTTRegisterState>(context);
    currentRegisterState = registerState;
    final Scaffold scaffold = Scaffold(
      body: _buildColumn());
    return scaffold;
  }

  Widget _buildColumn() {
    
    return ListView(
      children: [
        const SizedBox(height: 20,),
        _buildConnectionStateText(),
        _buildVIRow(currentAppState.getPowerData),
        _buildActivePowerRow(currentAppState.getPowerData),
        _buildReactivePowerRow(currentAppState.getPowerData),
        _buildAparentPowerRow(currentAppState.getPowerData),
        _buildPowerFactorRow(currentAppState.getPowerData),
        _buildFrecuencyRow(currentAppState.getPowerData),
        _buildConnectButton(currentAppState.getPowerConnectionState),
      ],
    );
  }

  Future<String> _getLocalIpAddress() async {
    final List<NetworkInterface> interfaces = await NetworkInterface.list(
      type: InternetAddressType.IPv4,
      includeLoopback: false,
    );
    for (var interface in interfaces) {
      for (var address in interface.addresses) {
        if (address.address.startsWith('192.') || address.address.startsWith('10.')) {
          return address.address;
        }
      }
    }
    return '127.0.0.1'; // Default to localhost if no other IP found
  }

 void _configureAndConnect() async {
  String identifier = await _getLocalIpAddress();  // ip host
  String ip = ''; // ip esp8266
  final discoveryIOS = await startDiscovery('_mqtt._tcp', autoResolve: true, ipLookupType: IpLookupType.v4); // descubre servicio mqtt y resuelve la ip
  discoveryIOS.addServiceListener((service, status) {
    if(status == ServiceStatus.found){
      InternetAddress newAdress =  service.addresses!.first;
      ip = newAdress.address;
      mqttManager = MQTTManager(
        host: ip, 
        topicMeasure: 'broker/measure',
        topicRegister: 'broker/register',
        identifier: identifier,
        powerState: currentAppState,
        registerState: currentRegisterState
      );

      mqttManager.initializeMQTTClient();
      mqttManager.connect();
    }
  });

}

void _disconnect() {
  mqttManager.disconnect();
}
  
  _buildConnectionStateText() { //Devuelve el widget que indica el estado de conexion
    String connectionState = '';
    TextStyle textStyle = const TextStyle(color: Colors.red, fontWeight: FontWeight.bold,);
    if(currentAppState.getPowerConnectionState == MQTTPowerConnectionState.connected) {
      connectionState = 'Conectado';
      textStyle = const TextStyle(color: Colors.green, fontWeight: FontWeight.bold);
    }
    if(currentAppState.getPowerConnectionState == MQTTPowerConnectionState.disconnected) {
      connectionState = 'Desconectado';
      textStyle = const TextStyle(color: Colors.red, fontWeight: FontWeight.bold);
    }
    if(currentAppState.getPowerConnectionState == MQTTPowerConnectionState.connecting) {
      connectionState = 'Connectando';
      textStyle = const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold);
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row( //Estado de conexion
              children: [
                Expanded(
                  child: Text(
                    connectionState, 
                    textAlign: TextAlign.center,
                    style: textStyle,
                    ))
              ],
            ),
    );
  }
  
  _buildVIRow(PowerData medida) {
      return  Row(
            children: [
              Expanded(child: MyCard(magnitude: 'VRMS', value: medida.vrms)),
              Expanded(child: MyCard(magnitude: 'IRMS', value: medida.irms)),
              
            ],
          );
  }
  
  _buildActivePowerRow(PowerData medida) {
    return  Row(
            children: [
              Expanded(child: MyCard(magnitude: 'Potencia activa', value: medida.potActiva)),
            ],
          );
  }
  
  _buildReactivePowerRow(PowerData medida) {
    return  Row(
            children: [
              Expanded(child: MyCard(magnitude: 'Potencia reactiva', value: medida.potReactiva)),
            ],
          );
  }
  
  _buildAparentPowerRow(PowerData medida) {
    return  Row(
            children: [
              Expanded(child: MyCard(magnitude: 'Potencia aparente', value: medida.potAparente)),
            ],
          );
  }
  
  _buildPowerFactorRow(PowerData medida) {
    return  Row(
            children: [
              Expanded(child: MyCard(magnitude: 'Factor de potencia', value: medida.powerFactor)),
            ],
          );
  }

  _buildFrecuencyRow(PowerData medida) {
    return  Row(
            children: [
              Expanded(child: MyCard(magnitude: 'Frecuencia', value: medida.frecuencia)),
            ],
          );
  }
  
  _buildConnectButton(MQTTPowerConnectionState state) {
    String textoBoton = state == MQTTPowerConnectionState.disconnected 
          ? 'Conectar'
          : 'Desconectar';
    return TextButton(    
      onPressed: () { 
        state == MQTTPowerConnectionState.disconnected 
          ? _configureAndConnect()
          : _disconnect();
      },
      child: Text(textoBoton),
      );
  }
  
  /*_buildScrollableTextWith(String mensajeRecibido) { // depuracion del mensaje recibido en el topic
  return Expanded(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(mensajeRecibido),
      ),
    ),
  );
}*/

}
