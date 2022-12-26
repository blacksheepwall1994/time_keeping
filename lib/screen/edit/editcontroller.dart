import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditController extends GetxController {
  RxString id = ''.obs;
  CollectionReference knownUsers =
      FirebaseFirestore.instance.collection('knownusers');
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('date');
  Rx<TextEditingController> dateController = TextEditingController().obs;
  Rx<TextEditingController> idController = TextEditingController().obs;
  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> phoneController = TextEditingController().obs;
  Rx<TextEditingController> homeTownController = TextEditingController().obs;
  Rx<TextEditingController> adressController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    idController.value.text = Get.arguments['id'];
    nameController.value.text = Get.arguments['name'];
    phoneController.value.text = Get.arguments['phone'];
    homeTownController.value.text = Get.arguments['home'];
    adressController.value.text = Get.arguments['adress'];
    dateController.value.text = Get.arguments['birth'];
  }

  void createUser() {
    knownUsers.doc(idController.value.text).set({
      'name': nameController.value.text,
      'phone': phoneController.value.text,
      'home': homeTownController.value.text,
      'adress': adressController.value.text,
      'birth': dateController.value.text,
      'id': idController.value.text,
    }).then((value) {
      Get.back();

      Get.back();

      Get.snackbar('Thành công', 'Sửa thành công người dùng',
          snackPosition: SnackPosition.BOTTOM);
    });
  }
}
