import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/vendor_common/order_transaction_details/controller/order_transaction_details_controller.dart';

class OrderTransactionDetailsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<OverviewOrderTransactionDetailsController>(() => OverviewOrderTransactionDetailsController(),
    );
  }
}