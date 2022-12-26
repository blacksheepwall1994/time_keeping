import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:timekeeping/ulti/userinfo.dart';

class HomeController extends GetxController {
  final client = MqttServerClient('broker.mqttdashboard.com', '');
  Rx<PageController> pageController = PageController().obs;
  RxBool isOpened = false.obs;
  RxInt selected = 0.obs;
  Rx<DateTime> currentDay = DateTime.now().obs;
  Rx<DateTime> focusedDay = DateTime.now().obs;
  RxString isData = ''.obs;
  static final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('date');
  RxList<String> data = <String>[].obs;
  RxBool isLoading = true.obs;
  Stream<QuerySnapshot<Map<String, dynamic>>> documentStream =
      FirebaseFirestore.instance.collection('date').snapshots();
  @override
  void onInit() async {
    super.onInit();

    await connectMqtt();

    isLoading(false);
    // print(data);
  }

  //Load các user của từng ngày về database
  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(allData);
  }

  //DateUtils.isSameDay(DateTime.parse('2022-10-10'),DateTime.parse(homeController.title.value.toString()))
  // Future<void> test() async {
  //   title.value = DateTime.parse('2022-11-07');
  // }

  Future<void> connectMqtt() async {
    client.logging(on: true);
    client.port = 1883;
    client.keepAlivePeriod = 60;
    client.websocketProtocols = MqttClientConstants.protocolsSingleDefault;
    //TODO: sửa lại clientidentifier
    final connMess = MqttConnectMessage()
        .withClientIdentifier('${DateTime.now()}')
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.exactlyOnce);
    client.connectionMessage = connMess;
    await client.connect('emqx', 'public');
    client.subscribe('mqtt', MqttQos.exactlyOnce);
  }
}
