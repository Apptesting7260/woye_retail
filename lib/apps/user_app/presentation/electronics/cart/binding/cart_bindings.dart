import 'package:get/get.dart';
import 'package:gyaawa/apps/user_app/presentation/electronics/cart/controller/cart_controller.dart';

class CartBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartController>(()=> CartController());
 }}