// ignore_for_file: avoid_print

import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:power_meter/mqtt/state/mqtt_register_state.dart';
import 'state/mqtt_power_state.dart';

class MQTTManager {
  // Private instance of client
  final MQTTPowerState _currentPowerState; //connected, disconnected, connecting
  final MQTTRegisterState _currentRegisterState; //connected, disconnected, connecting
  MqttServerClient? _client;
  final String _identifier;
  final String _host;
  final String _topicMeasure;
  final String _topicRegister;

  // Constructor
  // ignore: sort_constructors_first
  MQTTManager(
      {required String host,
      required String topicMeasure,
      required String topicRegister,
      required String identifier,
      required MQTTPowerState powerState,
      required MQTTRegisterState registerState,
      })
      : _identifier = identifier,
        _host = host, //url
        _topicMeasure = topicMeasure,
        _topicRegister = topicRegister,
        _currentPowerState = powerState,
        _currentRegisterState = registerState;

  void initializeMQTTClient() { //< Inicializa el cliente
    _client = MqttServerClient(_host, _identifier);
    _client!.port = 1883;
    _client!.keepAlivePeriod = 20;
    _client!.onDisconnected = onDisconnected; //callback if disconnected
    _client!.secure = false;
    _client!.logging(on: true);

    /// Asigna las callbacks 
    _client!.onConnected = onConnected;
    _client!.onSubscribed = onSubscribed;

    /// Configuracion del mensaje de conexion cuando el cliente intenta conectarse al servidor
    /// Este mensaje es parte del protocolo y se envia al broker pra iniciar una sesion de comunicacion
    final MqttConnectMessage connMess = MqttConnectMessage()
      .withClientIdentifier(_identifier) //Establece el id del cliente (unico para cada uno)
      .withWillTopic( //x tema en el que el broker publica si el cliente se desconecta repentinamente
        'willtopic') // If you set this you must set a will message
      .withWillMessage('My Will message') //mensaje que publica en ese topic
      .startClean() // Non persistent session for testing. Una sesion limpia no guarda el estado de las conexiones
      .withWillQos(MqttQos.atLeastOnce); //El mensaje de testamento se entregara al menos una vez
      print('EXAMPLE:MQTT Client connecting....');
      _client!.connectionMessage = connMess;
  }

  // Connect to the host
  // ignore: avoid_void_async
  void connect() async {
    assert(_client != null);//verifica que el cliente no sea nulo
    try {
      print('EXAMPLE::MQTT start client connecting....');
      _currentPowerState.setAppConnectionState(MQTTPowerConnectionState.connecting); //cambia estado de conexion a conectanado
      _currentRegisterState.setAppConnectionState(MQTTRegisterConnectionState.connecting);
      await _client!.connect(); //intenta conectarse con el servidor de forma asincrona
    } on Exception catch (e) {//si hay algun error lo printeamos y desconecamos
      //pueden haber excepciones de red, timeout, credenciales incorrectas, conf cliente, error en el server...
      print('EXAMPLE::client exception - $e');
      disconnect();
    }
  }

  void disconnect() {
    print('Disconnected');
    _client!.unsubscribe(_topicMeasure); //nuevo
    _client!.unsubscribe(_topicRegister); //nuevo
    _client!.disconnect();
  }

  void publish(String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder(); //instancia para construir la carga util del mensaje
    builder.addString(message); //construiccion del payload con el string
    _client!.publishMessage(_topicMeasure, MqttQos.exactlyOnce, builder.payload!); //publucacion en el topic
    _client!.publishMessage(_topicRegister, MqttQos.exactlyOnce, builder.payload!);
    //MqttQos.exactlyOnce garantiza que el mensaje se entregara una sola vez
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (_client!.connectionStatus!.returnCode ==
      MqttConnectReturnCode.noneSpecified) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
    _currentPowerState.setAppConnectionState(MQTTPowerConnectionState.disconnected); // Cambia el estado de conexion a desconectado
    _currentRegisterState.setAppConnectionState(MQTTRegisterConnectionState.disconnected);
  }

  /// The successful connect callback
  void onConnected() {
    _currentPowerState.setAppConnectionState(MQTTPowerConnectionState.connected); //cambia el estado de conexion a conectado
    _currentRegisterState.setAppConnectionState(MQTTRegisterConnectionState.connected);
    print('EXAMPLE::MQTT client connected....');
    //se suscribe al tema. garantiza que el mensaje sera entregado al menos una vez
    _client!.subscribe(_topicMeasure, MqttQos.atLeastOnce); 
    _client!.subscribe(_topicRegister, MqttQos.atLeastOnce); 
    /*listen se aplica al stream updates, que es un stream que emite una lista de mensajes MQTT 
    recibidos cada vez que llega un nuevo mensaje al cliente. */
    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) { //configura un listener
    /*
      // ignore: avoid_as
      //Extrae de la lista el primer mensaje recibido y obtiene su payload
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      // final MqttPublishMessage recMess = c![0].payload;
      final String pt = //convierte el payload de bytes a string
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      // una vez tenemos payload el mensaje en texto plano (string) procesamos y notificamos segun el topic
      if(c[0].topic == _topicMeasure){
        _currentPowerState.setReceivedText(pt);
      } else if(c[0].topic == _topicRegister){
        _currentRegisterState.setReceivedText(pt);
      }*/
      c?.forEach((MqttReceivedMessage<MqttMessage?> message) {
        final MqttPublishMessage recMess = message.payload as MqttPublishMessage;
        final String pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        print('EXAMPLE::Change notification:: topic is <${message.topic}>, payload is <-- $pt -->');

        // Lógica para procesar mensajes según el tópico
        if (message.topic == _topicMeasure) {
          _currentPowerState.setReceivedText(pt);
        } else if (message.topic == _topicRegister) {
          _currentRegisterState.setReceivedText(pt);
        }
        print('EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
        print('');
      });
        print('EXAMPLE::OnConnected client callback - Client connection was sucessful');
    });   
  }
}