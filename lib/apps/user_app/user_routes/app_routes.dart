
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:gyaawa/apps/user_app/presentation/common/home_address/sub_screen/add_new_door_delivery_address.dart';
import '../presentation/acccount/sub_screen/edit_profile.dart';
import '../presentation/common/home_address/bindings/door_delivery_bindings.dart';
import '../presentation/common/home_address/bindings/pickup_station_bindings.dart';
import '../presentation/common/home_address/sub_screen/pickup_station_screen.dart';
import '../presentation/common/home_address/sub_screen/select_delivery_address.dart';
import '../presentation/common/login/binding/login_bindings.dart';
import '../presentation/common/login/view/login_screen.dart';
import '../presentation/common/sign_up/binding/sign_up_binding.dart';
import '../presentation/common/sign_up/view/signup_screen.dart';
import '../presentation/common/tab_bar/sub_screen/view/editor_choice_screen.dart';
import '../presentation/common/tab_bar/sub_screen/view/featured_screen.dart';
import '../presentation/common/tab_bar/sub_screen/view/gift_screen.dart';
import '../presentation/common/verify/view/verify_screen.dart';
import '../presentation/electronics/cart/sub_screen/shipping_payment_screen.dart';
import '../presentation/electronics/category/sub_category/bindings/all_category_binding.dart';
import '../presentation/electronics/category/sub_category/bindings/departments_store_binding.dart';
import '../presentation/electronics/category/sub_category/bindings/sub_categories_binding.dart';
import '../presentation/electronics/category/sub_category/view/all_category_screen.dart';
import '../presentation/electronics/category/sub_category/view/departments_store_screen.dart';
import '../presentation/electronics/category/sub_category/view/subcategories_screen.dart';
import '../presentation/electronics/category/view/category_screen.dart';
import '../presentation/electronics/home/binding/home_bindings.dart';
import '../presentation/electronics/home/view/home_screen.dart';
import '../presentation/electronics/product_ditails/bindings/product_details_bindings.dart';
import '../presentation/electronics/product_ditails/product_ditails_screen/produt_screen.dart';
import '../presentation/electronics/search/sub_search_screen/bindings/search_result_bindings.dart';
import '../presentation/electronics/search/sub_search_screen/search_result_screen.dart';
import '../presentation/electronics/search/view/result_filter_screen.dart';

class UserRoutes {
  static const String signupScreen = '/signupScreen';
  static const String loginScreen = '/loginScreen';
  static const String verifyScreen = '/verifyScreen';
  static const String homeScreen = '/homeScreen';
  static const String productDetailsScreen = '/productDetailsScreen';
  static const String categoryScreen = '/categoryScreen';
  static const String allCategoriesScreen = '/allCategoriesScreen';
  static const String featuredScreen = '/featuredScreen';
  static const String giftScreen = '/giftScreen';
  static const String subcategoriesScreen = '/subcategoriesScreen';
  static const String departmentsStoreScreen = '/departmentsStoreScreen';
  static const String searchResultScreen = '/searchResultScreen';
  static const String resultFilterScreen = '/resultFilterScreen';
  static const String editProfile = '/editProfile';
  static const String editorChoiceScreen = '/editorChoiceScreen';
  static const String shippingPaymentScreen = '/shippingPaymentScreen';
  static const String selectDeliveryAddress = '/selectDeliveryAddress';
  static const String addNewDoorDeliveryAddress = '/addNewDoorDeliveryAddress';
  static const String pickupStationScreen = '/pickupStationScreen';

  static List<GetPage> pages = <GetPage>[
    GetPage(name: signupScreen, page: () =>  SignupScreen(),binding: SignupBinding()),
    GetPage(name: editorChoiceScreen, page: () => const EditorChoiceScreen()),
    GetPage(name: shippingPaymentScreen, page: () =>  ShippingPaymentScreen()),
    GetPage(name: loginScreen, page: () =>  LoginScreen(),binding: LoginBinding()),
    GetPage(name: selectDeliveryAddress, page: () => const SelectDeliveryAddress()),
    GetPage(name: verifyScreen, page: () => const VerifyScreen()),
    GetPage(name: allCategoriesScreen, page: () => const AllCategoriesScreen(),binding: AllCategoryBinding()),
    GetPage(name: categoryScreen, page: () => const CategoryScreen()),
    GetPage(name: searchResultScreen, page: () => const SearchResultScreen()),
    GetPage(name: featuredScreen, page: () => const FeaturedScreen()),
    GetPage(name: giftScreen, page: () => const GiftScreen()),
    GetPage(name: editProfile, page: () => const EditProfile()),
    GetPage(name: departmentsStoreScreen, page: () => const DepartmentsStoreScreen(),binding: DepartmentsStoreBinding()),
    GetPage(name: subcategoriesScreen, page: () => const SubcategoriesScreen(),binding: SubCategoriesBinding()),
    GetPage(name: homeScreen, page: () => const HomeScreen(),binding: HomeBinding()),
    GetPage(name: productDetailsScreen, page: () => const ProductDetailsScreen(),binding: ProductDetailsBindings()),
    GetPage(name: resultFilterScreen, page: () => const ResultFilterScreen(),binding: SearchResultBindings()),
    GetPage(name: addNewDoorDeliveryAddress, page: () => const AddNewDoorDeliveryAddress(),binding: DoorDeliveryBindings()),
    GetPage(name: pickupStationScreen, page: () =>  PickupStationScreen(),binding: PickupStationBindings()),

  ];
}