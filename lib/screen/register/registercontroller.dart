import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RegisterController extends GetxController {
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
    id.value = Get.arguments;
    idController.value.text = id.value;
  }

  bool isDate(String input, String format) {
    try {
      final DateTime d = DateFormat(format).parseStrict(input);
      //print(d);
      return true;
    } catch (e) {
      //print(e);
      return false;
    }
  }

  void createUser() {
    if (nameController.value.text == '' ||
        phoneController.value.text == '' ||
        homeTownController.value.text == '' ||
        adressController.value.text == '') {
      Get.snackbar(
          'Thông tin không hợp lệ!', 'Xin vui lòng nhập đầy đủ thông tin!');
      return;
    }
    if (!isDate(dateController.value.text, 'yyyy-MM-dd')) {
      Get.snackbar('Ngày không hợp lệ!',
          'Xin vui lòng ấn vào ô chọn ngày sinh để chọn ngày!');
      return;
    }
    knownUsers.doc(idController.value.text).set({
      'name': nameController.value.text,
      'phone': phoneController.value.text,
      'home': homeTownController.value.text,
      'adress': adressController.value.text,
      'birth': dateController.value.text,
      'id': idController.value.text,
    });
    collectionRef.doc(DateFormat('yyyy-MM-dd').format(DateTime.now())).set({
      idController.value.text: {
        'user': {
          'name': nameController.value.text,
          'phone': phoneController.value.text,
          'home': homeTownController.value.text,
          'adress': adressController.value.text,
          'birth': dateController.value.text,
          'id': idController.value.text,
        },
        'time': FieldValue.arrayUnion([DateTime.now()]),
      },
    }, SetOptions(merge: true));
    Get.back();
  }
}
