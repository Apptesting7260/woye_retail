import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../Setting/RestaurantInFormation/controller/restaurant_information_controller.dart';

class RestaurantDetailsController extends GetxController {
  final FillRestaurantDetailsController fillRestaurantDetailsController = Get.put(FillRestaurantDetailsController());
  Rx<File?> image = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    getProfile();
    super.onInit();
  }

  void getProfile(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fillRestaurantDetailsController.getProfileDetailsApi();
    });
  }

  Future<void> pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      image.value = File(pickedImage.path);
    }
  }

  List<Map<String, String>> openHoursList = [
    {"day": "Monday", "time": ""},
    {"day": "Tuesday", "time": ""},
    {"day": "Wednesday", "time": ""},
    {"day": "Thursday", "time": ""},
    {"day": "Friday", "time": ""},
    {"day": "Saturday", "time": ""},
    {"day": "Sunday", "time": ""},

  ];

}
