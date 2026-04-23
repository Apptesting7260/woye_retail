import 'package:get/get.dart';

import '../controller/res_security_settings_controller.dart';

class ResSecuritySettingBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ResSecuritySettingsController());
  }
}