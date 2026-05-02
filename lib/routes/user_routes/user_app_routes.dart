
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:gyaawa/apps/user_app/presentation/common/home_address/sub_screen/add_new_door_delivery_address.dart';
import 'package:gyaawa/apps/user_app/presentation/electronics/cart/binding/cart_bindings.dart';
import 'package:gyaawa/apps/user_app/presentation/electronics/cart/sub_screen/place_order_screen.dart';
import 'package:gyaawa/apps/user_app/presentation/navigation_bar/view/user_nav_bar.dart';
import '../../apps/user_app/presentation/acccount/sub_screen/edit_profile.dart';
import '../../apps/user_app/presentation/common/forgot_password/binding/forgot_password_bindings.dart';
import '../../apps/user_app/presentation/common/forgot_password/sub_screen/view/change_password_screen.dart';
import '../../apps/user_app/presentation/common/forgot_password/view/forgot_password_screen.dart';
import '../../apps/user_app/presentation/common/home_address/bindings/door_delivery_bindings.dart';
import '../../apps/user_app/presentation/common/home_address/bindings/pickup_station_bindings.dart';
import '../../apps/user_app/presentation/common/home_address/sub_screen/pickup_station_screen.dart';
import '../../apps/user_app/presentation/common/home_address/sub_screen/select_delivery_address.dart';
import '../../apps/user_app/presentation/common/login/binding/login_bindings.dart';
import '../../apps/user_app/presentation/common/login/view/login_screen.dart';
import '../../apps/user_app/presentation/common/sign_up/binding/sign_up_binding.dart';
import '../../apps/user_app/presentation/common/sign_up/view/signup_screen.dart';
import '../../apps/user_app/presentation/common/tab_bar/sub_screen/view/editor_choice_screen.dart';
import '../../apps/user_app/presentation/common/tab_bar/sub_screen/view/featured_screen.dart';
import '../../apps/user_app/presentation/common/tab_bar/sub_screen/view/gift_screen.dart';
import '../../apps/user_app/presentation/common/verify/binding/verify_bindings.dart';
import '../../apps/user_app/presentation/common/verify/view/verify_screen.dart';
import '../../apps/user_app/presentation/common/welcome/view/welcome_screen.dart';
import '../../apps/user_app/presentation/electronics/cart/view/cart_screen.dart';
import '../../apps/user_app/presentation/electronics/category/sub_category/bindings/all_category_binding.dart';
import '../../apps/user_app/presentation/electronics/category/sub_category/bindings/departments_store_binding.dart';
import '../../apps/user_app/presentation/electronics/category/sub_category/bindings/sub_categories_binding.dart';
import '../../apps/user_app/presentation/electronics/category/sub_category/view/all_category_screen.dart';
import '../../apps/user_app/presentation/electronics/category/sub_category/view/departments_store_screen.dart';
import '../../apps/user_app/presentation/electronics/category/sub_category/view/subcategories_screen.dart';
import '../../apps/user_app/presentation/electronics/category/view/category_screen.dart';
import '../../apps/user_app/presentation/electronics/home/binding/home_bindings.dart';
import '../../apps/user_app/presentation/electronics/home/view/home_screen.dart';
import '../../apps/user_app/presentation/electronics/product_ditails/bindings/product_details_bindings.dart';
import '../../apps/user_app/presentation/electronics/product_ditails/product_ditails_screen/produt_screen.dart';
import '../../apps/user_app/presentation/electronics/search/sub_search_screen/bindings/search_result_bindings.dart';
import '../../apps/user_app/presentation/electronics/search/sub_search_screen/search_result_screen.dart';
import '../../apps/user_app/presentation/electronics/search/view/result_filter_screen.dart';
import '../../apps/user_app/presentation/navigation_bar/binding/user_nar_bar_bindings.dart';
class UserRoutes {
  static const String signupScreen = '/signupScreen';
  static const String welcomeScreen = '/welcomeScreen';
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
  static const String cartScreen = '/cartScreen';
  static const String mainScreen = '/mainScreen';
  static const String forgotPasswordScreen = '/forgotPasswordScreen';
  static const String changePasswordScreen = '/changePasswordScreen';

  static List<GetPage> pages = <GetPage>[
    GetPage(name: signupScreen, page: () =>  SignupScreen(),binding: SignupBinding()),
    GetPage(name: editorChoiceScreen, page: () => const EditorChoiceScreen()),
    GetPage(name: shippingPaymentScreen, page: () =>  PlaceOrderScreen()),
    GetPage(name: loginScreen, page: () =>  LoginScreen(),binding: LoginBinding()),
    GetPage(name: selectDeliveryAddress, page: () => const SelectDeliveryAddress()),
    GetPage(name: verifyScreen, page: () => const VerifyScreen(),binding: VerifyBinding()),
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
    GetPage(name: cartScreen, page: () =>  CartScreen(),binding: CartBindings()),
    GetPage(name: mainScreen, page: () =>  MainScreen(),binding: MainBinding()),
    GetPage(name: welcomeScreen, page: () =>  WelcomeScreen()),
    GetPage(name: forgotPasswordScreen, page: () => ForgotPasswordScreen(),binding: ForgotPasswordBindings()),
    GetPage(name: changePasswordScreen, page: () => ChangePasswordScreen(),),

  ];
}