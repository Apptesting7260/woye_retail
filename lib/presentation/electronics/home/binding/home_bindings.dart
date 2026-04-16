import 'package:get/get.dart';
import 'package:gyaawa/presentation/electronics/home/controller/home_controller.dart';

class HomeBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}