import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/view/Pages/FillVendorDetails/controller/vendor_profile_details_controller.dart';

class ProfileDetailsBinding extends Bindings{
  @override
  void dependencies() {
   Get.lazyPut(() => VendorProfileDetailsController());
  }
}