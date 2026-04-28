import 'package:get/get.dart';

import '../controller/res_notification_settings_controller.dart';

class ResNotificationSettingsBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ResNotificationSettingController());
  }
}