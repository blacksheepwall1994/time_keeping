import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:timekeeping/screen/home/homecontroller.dart';

class MainPage extends GetView<HomeController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();

    Stream<DocumentSnapshot> documentStream = FirebaseFirestore.instance
        .collection('date')
        .doc(DateFormat('yyyy-MM-dd').format(homeController.currentDay.value))
        .snapshots();

    return StreamBuilder<DocumentSnapshot>(
      stream: documentStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Expanded(
            child: ListView.builder(
              itemCount: snapshot.data.data().keys.toList().length,
              itemBuilder: (context, index) => Column(
                children: [
                  // Text(snapshot.data.data().keys.toList()[index]),
                  // Text(snapshot.data
                  //     .data()
                  //     .values
                  //     .toList()[index]['user']
                  //     .toString()),
                  ListTile(
                    onTap: () {
                      Get.dialog(
                        // AlertDialog(
                        //   title: Text('User'),
                        //   content: Text(snapshot.data
                        //       .data()
                        //       .values
                        //       .toList()[index]['user']
                        //       .toString()),
                        //   actions: [
                        //     TextButton(
                        //       onPressed: () {
                        //         Get.back();
                        //       },
                        //       child: Text('Close'),
                        //     ),
                        //   ],
                        // ),
                        AlertDialog(
                          content: SizedBox(
                            height: 150,
                            child: Center(
                              child: Column(children: [
                                ListTile(
                                  onTap: () {
                                    Get.toNamed('/edit', arguments: {
                                      'id': snapshot.data
                                          .data()
                                          .values
                                          .toList()[index]['user']['id']
                                          .toString(),
                                      'name': snapshot.data
                                          .data()
                                          .values
                                          .toList()[index]['user']['name']
                                          .toString(),
                                      'phone': snapshot.data
                                          .data()
                                          .values
                                          .toList()[index]['user']['phone']
                                          .toString(),
                                      'home': snapshot.data
                                          .data()
                                          .values
                                          .toList()[index]['user']['home'],
                                      'adress': snapshot.data
                                          .data()
                                          .values
                                          .toList()[index]['user']['adress']
                                          .toString(),
                                      'birth': snapshot.data
                                          .data()
                                          .values
                                          .toList()[index]['user']['birth'],
                                    });
                                  },
                                  title: const Text('Sửa người dùng'),
                                ),
                                ListTile(
                                  onTap: () async {
                                    FirebaseFirestore.instance
                                        .collection('knownusers')
                                        .doc(snapshot.data
                                            .data()
                                            .values
                                            .toList()[index]['user']['id']
                                            .toString())
                                        .delete()
                                        .then((value) {
                                      Get.back();
                                      Get.back();
                                      Get.snackbar('Thành công',
                                          'Xoá thành công người dùng ${snapshot.data.data().values.toList()[index]['user']['name']} trong database');
                                    });
                                  },
                                  title: const Text('Xoá người dùng'),
                                ),
                              ]),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text('Đóng'),
                            ),
                          ],
                        ),
                      );
                    },
                    leading: Text(
                      'ID :${snapshot.data.data().values.toList()[index]['user']['id'].toString()}',
                      textAlign: TextAlign.center,
                    ),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Tên: ${snapshot.data.data().values.toList()[index]['user']['name'].toString()}'),
                        Text(
                            'Ngày sinh: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(snapshot.data.data().values.toList()[index]['user']['birth'])).toString()}'),
                      ],
                    ),
                    subtitle: Text(
                        'Lần cuối checkin ${DateFormat('HH:mm:ss').format(snapshot.data.data().values.toList()[index]['time'].last.toDate()).toString()}'),
                  )
                ],
              ),
            ),
          );
        }
        return const Text('loading');
      },
    );
  }
}
