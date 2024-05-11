// ignore_for_file: avoid_print

import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'state/mqtt_app_state.dart';

class MQTTManager {
  // Private instance of client
  final MQTTAppState _currentState; //connected, disconnected, connecting
  MqttServerClient? _client;
  final String _identifier;
  final String _host;
  final String _topic;

  // Constructor
  // ignore: sort_constructors_first
  MQTTManager(
      {required String host,
      required String topic,
      required String identifier,
      required MQTTAppState state})
      : _identifier = identifier,
        _host = host, //url
        _topic = topic,
        _currentState = state;

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
      _currentState.setAppConnectionState(MQTTAppConnectionState.connecting); //cambia estado de conexion a conectanado
      await _client!.connect(); //intenta conectarse con el servidor de forma asincrona
    } on Exception catch (e) {//si hay algun error lo printeamos y desconecamos
      //pueden haber excepciones de red, timeout, credenciales incorrectas, conf cliente, error en el server...
      print('EXAMPLE::client exception - $e');
      disconnect();
    }
  }

  void disconnect() {
    print('Disconnected');
    _client!.disconnect();
  }

  void publish(String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder(); //instancia para construir la carga util del mensaje
    builder.addString(message); //construiccion del payload con el string
    _client!.publishMessage(_topic, MqttQos.exactlyOnce, builder.payload!); //publucacion en el topic
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
    _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected); // Cambia el estado de conexion a desconectado
  }

  /// The successful connect callback
  void onConnected() {
    _currentState.setAppConnectionState(MQTTAppConnectionState.connected); //cambia el estado de conexion a conectado
    print('EXAMPLE::MQTT client connected....');
    _client!.subscribe(_topic, MqttQos.atLeastOnce); //se suscribe al tema. garantiza que el mensaje sera entregado al menos una vez
    /*listen se aplica al stream updates, que es un stream que emite una lista de mensajes MQTT 
    recibidos cada vez que llega un nuevo mensaje al cliente. */
    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) { //configura un listener
      // ignore: avoid_as
      //Extrae de la lista el primer mensaje recibido y obtiene su payload
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;

      // final MqttPublishMessage recMess = c![0].payload;
      final String pt = //convierte el payload de bytes a string
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        _currentState.setReceivedText(pt);
      print(
          'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      print('');
    });
    print(
        'EXAMPLE::OnConnected client callback - Client connection was sucessful');
  }
}