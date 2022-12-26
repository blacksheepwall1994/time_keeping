import 'package:get/get.dart';
import 'package:timekeeping/screen/edit/edit.dart';
import 'package:timekeeping/screen/edit/editcontroller.dart';
import 'package:timekeeping/screen/home/homecontroller.dart';
import 'package:timekeeping/screen/home/homescreen.dart';
import 'package:timekeeping/screen/register/register.dart';
import 'package:timekeeping/screen/register/registercontroller.dart';

abstract class Routes {
  static const home = '/home';
  static const register = '/register';
  static const edit = '/edit';
}

abstract class AppPages {
  static String initial = Routes.home;
  static final routes = [
    GetPage(
        name: Routes.register,
        page: () => const CreateUser(),
        binding: BindingsBuilder.put(() => RegisterController())),
    GetPage(
        name: Routes.edit,
        page: () => const EditUser(),
        binding: BindingsBuilder.put(() => EditController())),
    GetPage(
        name: Routes.home,
        page: () => const HomeScreen(),
        binding: BindingsBuilder.put(() => HomeController())),
  ];
}
