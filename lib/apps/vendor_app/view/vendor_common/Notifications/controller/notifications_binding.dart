
import 'package:get/get.dart';

import 'notifications_controllers.dart';

class NotificationsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<NotificationsController>(()=>NotificationsController());
  }
}
