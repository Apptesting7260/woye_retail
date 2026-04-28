import 'package:get/get.dart';

import '../../../../../../../../Core/Constant/image_constant.dart';

class RestaurantMyAccountController extends GetxController {
  RxList<Map<String, String>> mapList = [
    {"title": "Edit Profile", "image": ImageConstants.profileOutlined},
    {"title": "Change Password", "image": ImageConstants.lockLogoOutlined},
  ].obs;
}
