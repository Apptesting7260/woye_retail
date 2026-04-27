import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/vendor_common/Notifications/sub_screens/notification_settings/controller/res_notification_settings_controller.dart';

class ResNotificationSettingsBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ResNotificationSettingController());
  }
}