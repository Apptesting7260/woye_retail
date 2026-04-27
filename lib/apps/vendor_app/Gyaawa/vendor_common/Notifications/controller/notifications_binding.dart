
import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/vendor_common/Notifications/controller/notifications_controllers.dart';

class NotificationsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<NotificationsController>(()=>NotificationsController());
  }
}
