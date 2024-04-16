import 'package:flutter/material.dart';
import 'package:power_meter/mqtt/mqtt_manager.dart';
import 'package:power_meter/mqtt/multicast_dns_mqtt.dart';
import 'package:power_meter/mqtt/state/mqtt_app_state.dart';
import 'package:power_meter/presentation/items/card.dart';
import 'package:provider/provider.dart';

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
  late MQTTAppState currentAppState;
  late MQTTManager mqttManager;
  late DiscoverServices discover;

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
    final MQTTAppState appState = Provider.of<MQTTAppState>(context); //Cambios de estado de los que nos informa el provider. (desde notifyListeners)
    currentAppState = appState; // lo registramos
    final Scaffold scaffold = Scaffold(body: _buildColumn());
    return scaffold;
  }
  /*Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('MQTT'),
      backgroundColor: Colors.teal.shade50,
    );
  }*/
  Widget _buildColumn() {
    
    return Column(
      children: <Widget>[
        _buildConnectionStateText(),
        _buildVIRow(currentAppState.getDataJSON),
        _buildActivePowerRow(currentAppState.getDataJSON),
        _buildReactivePowerRow(currentAppState.getDataJSON),
        _buildAparentPowerRow(currentAppState.getDataJSON),
        _buildPowerFactorRow(currentAppState.getDataJSON),
        _buildConnectButton(currentAppState.getAppConnectionState),
        _buildScrollableTextWith(currentAppState.getReceivedText)
      ],
    );
  }

 void _configureAndConnect() async {
  discover = DiscoverServices();
  await discover.init(); // Espera a que se complete el descubrimiento.
  discover.startDiscoveryButton(); // Inicia el descubrimiento de servicios.
  
  final nsdServiceInfo = await discover.flutterNsd.stream.first;
  print(nsdServiceInfo.hostname);

  if (nsdServiceInfo != null) {
    mqttManager = MQTTManager(
      host: nsdServiceInfo.hostname?? '', // Set the host to the discovered service name
      topic: 'broker/measure',
      identifier: 'FASTO',
      state: currentAppState,
    );

    mqttManager.initializeMQTTClient();
    mqttManager.connect();
    // Detiene el descubrimiento de servicios una vez que se haya conectado o si no se encontró el servicio.
    } else {
    print('No se pudo descubrir el servicio mDNS.');
  }
  
  // Detiene el descubrimiento de servicios una vez que se haya conectado o si no se encontró el servicio.
  discover.stopDiscoveryButton();
}
  
  _buildConnectionStateText() {
    String connectionState = '';
    TextStyle textStyle = const TextStyle(color: Colors.red, fontWeight: FontWeight.bold,);;
    if(currentAppState.getAppConnectionState == MQTTAppConnectionState.connected) {
      connectionState = 'Conectado';
      textStyle = const TextStyle(color: Colors.green, fontWeight: FontWeight.bold);
    }
    if(currentAppState.getAppConnectionState == MQTTAppConnectionState.disconnected) {
      connectionState = 'Desconectado';
      textStyle = const TextStyle(color: Colors.red, fontWeight: FontWeight.bold);
    }
    if(currentAppState.getAppConnectionState == MQTTAppConnectionState.connecting) {
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
  
  _buildVIRow(ManageData medida) {
      return  Row(
            children: [
              Expanded(child: MyCard(magnitude: 'VRMS', value: medida.vrms)),
              Expanded(child: MyCard(magnitude: 'IRMS', value: medida.irms)),
              
            ],
          );
  }
  
  _buildActivePowerRow(ManageData medida) {
    return  Row(
            children: [
              Expanded(child: MyCard(magnitude: 'Potencia activa', value: medida.potActiva)),
            ],
          );
  }
  
  _buildReactivePowerRow(ManageData medida) {
    return  Row(
            children: [
              Expanded(child: MyCard(magnitude: 'Potencia reactiva', value: medida.potReactiva)),
            ],
          );
  }
  
  _buildAparentPowerRow(ManageData medida) {
    return  Row(
            children: [
              Expanded(child: MyCard(magnitude: 'Potencia aparente', value: medida.potAparente)),
            ],
          );
  }
  
  _buildPowerFactorRow(ManageData medida) {
    return  Row(
            children: [
              Expanded(child: MyCard(magnitude: 'Factor de potencia', value: medida.powerFactor)),
            ],
          );
  }
  
  _buildConnectButton(MQTTAppConnectionState state) {
    return TextButton(    
      onPressed: () { 
        state == MQTTAppConnectionState.disconnected 
          ? _configureAndConnect()
          :null;
      },
      child: const Text('Conectar'),
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
