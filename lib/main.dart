import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timekeeping/routes/routes.dart';
import 'package:timekeeping/screen/home/homecontroller.dart';
import 'package:timekeeping/screen/home/homescreen.dart';
import 'package:timekeeping/test.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        initialBinding: BindingsBuilder(() {
          Get.put(HomeController());
          Get.put(PageController());
        }),
        getPages: AppPages.routes,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen()
        // home: TestMqtt(),
        );
  }
}
