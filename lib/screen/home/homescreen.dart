import 'dart:async';
import 'dart:convert';

import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timekeeping/screen/home/homecontroller.dart';
import 'package:timekeeping/screen/home/mainpage.dart';
import 'package:timekeeping/ulti/userinfo.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int check = 0;
    CollectionReference documentStream =
        FirebaseFirestore.instance.collection('date');
    CollectionReference knownUsers =
        FirebaseFirestore.instance.collection('knownusers');
    final homeController = Get.put(HomeController());
    return StreamBuilder<List<MqttReceivedMessage<MqttMessage>>>(
      stream: controller.client.updates!.asBroadcastStream(),
      builder: (context, snapshot1) {
        return StreamBuilder(
          stream: documentStream.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List availableDates = snapshot.data!.docs
                  .map((e) =>
                      DateFormat('yyyy-MM-dd').format(DateTime.parse(e.id)))
                  .toList();
              if (snapshot1.hasData) {
                final recMess =
                    snapshot1.data![0].payload as MqttPublishMessage;
                final pt = MqttPublishPayload.bytesToStringAsString(
                    recMess.payload.message);
                // print(json.encode(pt));
                // var data = json.decode(pt)['ID'];
                knownUsers
                    .doc(pt)
                    .get()
                    .then((DocumentSnapshot documentSnapshot) {
                  // print(json.decode(pt)['ID']);
                  if (pt == 'Understanding ') {
                    return 1;
                  }
                  // print(pt);
                  if (Get.isDialogOpen!) {
                    return 1;
                  }
                  if (documentSnapshot.exists) {
                    // print('Document data: ${documentSnapshot.data()}');
                    documentStream
                        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()))
                        .set({
                      pt: {
                        'user': documentSnapshot.data(),
                        'time': FieldValue.arrayUnion([DateTime.now()]),
                      },
                      // 'time $pt': DateFormat('HH:mm:ss').format(DateTime.now()),
                    }, SetOptions(merge: true)).then(
                            (value) => homeController.isOpened.value = true);
                    Get.defaultDialog(
                      title: 'Cảnh báo',
                      content: Text('Đã thêm thành công người dùng $pt'),
                    );
                    final builder = MqttClientPayloadBuilder();
                    // print(documentSnapshot.data()!['name']);
                    // var data2 = json.decode(documentSnapshot.data()?.toJson());
                    // print(jsonEncode(documentSnapshot.data()));
                    var data2 = jsonEncode(documentSnapshot.data());
                    builder.addString(json.decode(data2)['name']);
                    controller.client.publishMessage(
                        'listen', MqttQos.exactlyOnce, builder.payload!);
                    Timer(const Duration(seconds: 1), () {
                      Get.back();
                    });
                  } else {
                    if (Get.isDialogOpen!) {
                      return 1;
                    }
                    Get.defaultDialog(
                        title: 'Lỗi',
                        actions: [
                          TextButton(
                              onPressed: () {
                                Get.back();
                                Get.toNamed('/register', arguments: pt);
                              },
                              child: const Text('Tạo người dùng'))
                        ],
                        content: const Text('Người dùng không tồn tại'));
                  }
                });
              }
              return Scafl(
                  homeController: homeController,
                  availableDates: availableDates);
            }
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        );
      },
    );
  }
}

class Scafl extends StatelessWidget {
  const Scafl({
    Key? key,
    required this.homeController,
    required this.availableDates,
  }) : super(key: key);

  final HomeController homeController;
  final List availableDates;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => TableCalendar(
                currentDay: homeController.currentDay.value,
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                startingDayOfWeek: StartingDayOfWeek.monday,
                locale: 'vi_VN',
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.now(),
                focusedDay: homeController.focusedDay.value,
                eventLoader: (day) {
                  if (availableDates
                      .contains(DateFormat('yyyy-MM-dd').format(day))) {
                    return ['1'];
                  }
                  return [];
                },
                onDaySelected: (selectedDay, focusedDay) {
                  homeController.currentDay.value = selectedDay;
                  homeController.focusedDay.value = focusedDay;
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => availableDates.contains(DateFormat('yyyy-MM-dd')
                          .format(homeController.currentDay.value)) &&
                      homeController.isLoading.value == false
                  // ignore: prefer_const_constructors
                  ? MainPage()
                  : const Center(
                      child: Text('Không có dữ liệu'),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
