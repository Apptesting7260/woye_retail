import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RestaurantWithdrawController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Rx<TextEditingController> amountController = TextEditingController().obs;
  RxBool isError = false.obs;

}
