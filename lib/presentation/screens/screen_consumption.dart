import 'package:flutter/material.dart';
import 'package:power_meter/mqtt/mqtt_manager.dart';
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
  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('MQTT'),
      backgroundColor: Colors.teal.shade50,
    );
  }
  Widget _buildColumn() {
    
    return Column(
      children: <Widget>[
        _buildConnectionStateText(),
        _buildVIRow(currentAppState.getDataJSON),
        _buildActivePowerRow(),
        _buildReactivePowerRow(),
        _buildAparentPowerRow(),
        _buildPowerFactorRow(),
        _buildConnectButton(currentAppState.getAppConnectionState),
        _buildScrollableTextWith(currentAppState.getReceivedText)
      ],
    );
  }

  void _configureAndConnect(){
    mqttManager = MQTTManager(
      host: '192.168.1.154', 
      topic: 'broker/measure', 
      identifier: 'FASTO', 
      state: currentAppState);

    mqttManager.initializeMQTTClient();
    mqttManager.connect();
  }
  
  _buildConnectionStateText() {
    return const Row( //Estado de conexion
            children: [
              Expanded(
                child: Text('Estado de conexión',textAlign: TextAlign.center,))
            ],
          );
  }
  
  _buildVIRow(ManageData medida) {
      return  Row(
            children: [
              Expanded(child: MyCard(magnitude: 'Vrms', value: medida.vrms)),
              Expanded(child: MyCard(magnitude: 'Corriente', value: medida.irms)),
              
            ],
          );
  }
  
  _buildActivePowerRow() {
    return const Row(
            children: [
              Expanded(child: MyCard(magnitude: 'Potencia activa', value: 4)),
            ],
          );
  }
  
  _buildReactivePowerRow() {
    return const Row(
            children: [
              Expanded(child: MyCard(magnitude: 'Potencia reactiva', value: 1)),
            ],
          );
  }
  
  _buildAparentPowerRow() {
    return const Row(
            children: [
              Expanded(child: MyCard(magnitude: 'Potencia aparente', value: 5)),
            ],
          );
  }
  
  _buildPowerFactorRow() {
    return const Row(
            children: [
              Expanded(child: MyCard(magnitude: 'Factor de potencia', value: 1)),
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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(mensajeRecibido),
      );
  }

}
