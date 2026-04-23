import 'package:get/get.dart';
import '../../../../../../Core/Constant/image_constant.dart';
import '../../../../../../shared/widgets/vendor_widgets/pref_utils.dart';
import '../Sub_Screens/Setting/RestaurantInFormation/controller/restaurant_information_controller.dart';

class RestaurantUserProfileController extends GetxController {
  // VendorAccountStatusController vendorAccountStatusController = Get.put(VendorAccountStatusController());
  final FillRestaurantDetailsController fillRestaurantDetailsController =     Get.put(FillRestaurantDetailsController());

  PrefUtils prefUtils = PrefUtils();

  RxList<Map<String, String>> mapList = [
    {"title": "Edit Profile", "image": ImageConstants.profileOutlined},
    {"title": "Restaurant Details", "image": ImageConstants.shopLogo},
    {"title": "Reviews", "image": ImageConstants.starsLogo},
    {"title": "Payment Details", "image": ImageConstants.cardLogo},
    // {"title": "Orders Transactions", "image": ImageConstants.orderTransaction},
    {"title": "Category", "image": ImageConstants.categories},
    {"title": "AddOn", "image": ImageConstants.addOn},
    // {"title": "Invite Friends", "image": ImageConstants.profileOutlined},
    {"title": "Settings", "image": ImageConstants.settingLogo},
    {"title": "Help", "image": ImageConstants.helpLogo},
    {"title": "Logout", "image": ImageConstants.logoutLogo},
  ].obs;

  RxBool getProfile = false.obs;

  @override
  void onInit() {
    if(!getProfile.value){
      fillRestaurantDetailsController.getProfileDetailsApi();
      getProfile.value = true;
    }
    // vendorAccountStatusController.getAccountStatusApi();
    super.onInit();
  }

}
