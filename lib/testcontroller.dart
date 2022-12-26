import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class TestController extends GetxController {
  final client = MqttServerClient('broker.mqttdashboard.com', '');
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    client.logging(on: true);
    client.port = 1883;
    client.keepAlivePeriod = 60;
    client.websocketProtocols = MqttClientConstants.protocolsSingleDefault;
    //TODO: sửa lại clientidentifier
    final connMess = MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueId')
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atMostOnce);
    client.connectionMessage = connMess;
    await client.connect('emqx', 'public');
    client.subscribe('mqtt', MqttQos.atMostOnce);

    // client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
    //   final recMess = c![0].payload as MqttPublishMessage;
    //   final pt =
    //       MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    //   print(
    //       'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
    // });
  }
}
