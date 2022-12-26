import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:timekeeping/testcontroller.dart';

class TestMqtt extends GetView<TestController> {
  const TestMqtt({super.key});

  @override
  Widget build(BuildContext context) {
    final TestController controller = Get.put(TestController());
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            StreamBuilder(
              stream: controller.client.updates!.asBroadcastStream(),
              builder: (context,
                  AsyncSnapshot<List<MqttReceivedMessage<MqttMessage>>>
                      snapshot) {
                final recMess = snapshot.data![0].payload as MqttPublishMessage;

                final pt = MqttPublishPayload.bytesToStringAsString(
                    recMess.payload.message);
                print(pt);
                return Text(pt.toString());
              },
            )
          ],
        ),
      ),
    );
  }
}
