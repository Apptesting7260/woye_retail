import 'package:get/get.dart';

import '../../../../../../Core/Constant/image_constant.dart';

class RestaurantHelpCenterController extends GetxController{

  RxList<Map<String, String>> tileMapList = [
    {"title": "Support Center", "image": ImageConstants.support},
    {"title": "FAQ’s", "image": ImageConstants.faq},
    {"title": "Privacy Policy", "image": ImageConstants.privacyPolicy},
    {"title": "Terms & Conditions", "image": ImageConstants.tnc},
    {"title": "Vendor Agreement", "image": ImageConstants.tnc},
  ].obs;

}