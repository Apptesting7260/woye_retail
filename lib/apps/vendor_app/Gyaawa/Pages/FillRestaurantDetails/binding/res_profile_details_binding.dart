import 'package:get/get.dart';
import 'package:gyaawa/apps/vendor_app/Gyaawa/Pages/FillRestaurantDetails/controller/restaurant_profile_details_controller.dart';

class ResProfileDetailsBinding extends Bindings{
  @override
  void dependencies() {
   Get.lazyPut(() => ResProfileDetailsDetailsController());
  }
}