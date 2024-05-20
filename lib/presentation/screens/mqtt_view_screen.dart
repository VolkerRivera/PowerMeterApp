import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:network_tools/network_tools.dart';
import 'package:power_meter/mqtt/mqtt_manager.dart';
import 'package:power_meter/mqtt/multicast_dns_mqtt.dart';
import 'package:power_meter/mqtt/state/mqtt_power_state.dart';
import 'package:power_meter/mqtt/state/mqtt_register_state.dart';
import 'package:power_meter/presentation/items/card.dart';
import 'package:provider/provider.dart';
import 'package:multicast_dns/multicast_dns.dart';

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
  late DiscoverServices discover;
  
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
    // añadir provider of MQTTRegisterState
    currentAppState = appState; // lo registramos
    final MQTTRegisterState registerState = Provider.of<MQTTRegisterState>(context);
    currentRegisterState = registerState;
    final Scaffold scaffold = Scaffold(body: _buildColumn());
    return scaffold;
  }

  Widget _buildColumn() {
    
    return Column( //Columna de widgets de la pantalla de en medio
      children: <Widget>[
        _buildConnectionStateText(),
        _buildVIRow(currentAppState.getPowerData),
        _buildActivePowerRow(currentAppState.getPowerData),
        _buildReactivePowerRow(currentAppState.getPowerData),
        _buildAparentPowerRow(currentAppState.getPowerData),
        _buildPowerFactorRow(currentAppState.getPowerData),
        _buildConnectButton(currentAppState.getPowerConnectionState),
        _buildScrollableTextWith(currentAppState.getReceivedText),
      ],
    );
  }

 void _configureAndConnect() async {
  
  if(Platform.isIOS){
    /* MULTICAST_DNS LIBRARY */
    const String name = '_mqtt._tcp.local';
    String ip = '';
    final MDnsClient client = MDnsClient(rawDatagramSocketFactory:
      (dynamic host, int port,
        {bool? reuseAddress, bool? reusePort, int? ttl}) {
        return RawDatagramSocket.bind(host, port,
      reuseAddress: true, reusePort: false, ttl: ttl!);
    });  
    
    if (ip != '') {
    mqttManager = MQTTManager(
      host: ip, // Set the host to the discovered service name
      topicMeasure: 'broker/measure',
      topicRegister: 'broker/register',
      identifier: 'FASTO',
      powerState: currentAppState,
      registerState: currentRegisterState
    );

    mqttManager.initializeMQTTClient();
    mqttManager.connect();
     //Detiene el descubrimiento de servicios una vez que se haya conectado o si no se encontró el servicio.
    } else {
      print('No se pudo descubrir el servicio mDNS.');
    }
  
    // Detiene el descubrimiento de servicios una vez que se haya conectado o si no se encontró el servicio.
    client.stop();
  }
  
  if(Platform.isAndroid){
    if(firstmDNSscan){//la primera vez que se escanea se hace el mDNS scan, el resto no porque ya se tiene la IP
      discover = DiscoverServices();
      await discover.init(); // Espera a que se complete el descubrimiento.
      discover.startDiscoveryButton(); // Inicia el descubrimiento de servicios.
      final nsdServiceInfo = await discover.flutterNsd.stream.first;
      print(nsdServiceInfo.hostname);
      ipMQTTServer = nsdServiceInfo.hostname ?? '';
      firstmDNSscan = false;
      discover.stopDiscoveryButton();
    }
    //En iOS y macOS de momento no se devuelve el hostAddresses
    //if (nsdServiceInfo != null) {
      mqttManager = MQTTManager(
        host: ipMQTTServer, // Set the host to the discovered service name
        topicMeasure: 'broker/measure',
        topicRegister: 'broker/register',
        identifier: 'FASTO',
        powerState: currentAppState,
        registerState: currentRegisterState,
      );
      mqttManager.initializeMQTTClient();
      mqttManager.connect();
     
      //Detiene el descubrimiento de servicios una vez que se haya conectado o si no se encontró el servicio.
    //} else {
    //  print('No se pudo descubrir el servicio mDNS.');
    //}
  
    // Detiene el descubrimiento de servicios una vez que se haya conectado o si no se encontró el servicio.
    //discover.stopDiscoveryButton();
  }
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
  
  _buildScrollableTextWith(String mensajeRecibido) {
  return Expanded(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(mensajeRecibido),
      ),
    ),
  );
}

}
