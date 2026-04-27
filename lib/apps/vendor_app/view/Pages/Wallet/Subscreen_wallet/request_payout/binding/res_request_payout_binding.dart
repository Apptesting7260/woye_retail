import 'package:get/get.dart';
import '../controller/res_request_payout_controller.dart';

class ResRequestPayloadBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ResRequestPayoutController());
  }
}