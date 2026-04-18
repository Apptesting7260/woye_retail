
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../presentation/common/login/view/login_screen.dart';
import '../presentation/common/sign_up/signup_screen.dart';
import '../presentation/common/verify/view/verify_screen.dart';
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

class AppRoutes {
  static const String signupScreen = '/signupScreen';
  static const String loginScreen = '/loginScreen';
  static const String verifyScreen = '/verifyScreen';
  static const String homeScreen = '/homeScreen';
  static const String productDetailsScreen = '/productDetailsScreen';
  static const String categoryScreen = '/categoryScreen';
  static const String allCategoriesScreen = '/allCategoriesScreen';
  static const String subcategoriesScreen = '/subcategoriesScreen';
  static const String departmentsStoreScreen = '/departmentsStoreScreen';
  static const String searchResultScreen = '/searchResultScreen';
  static const String resultFilterScreen = '/resultFilterScreen';

  static List<GetPage> pages = <GetPage>[
  GetPage(name: signupScreen, page: () => const SignupScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: verifyScreen, page: () => const VerifyScreen()),
    GetPage(name: allCategoriesScreen, page: () => const AllCategoriesScreen(),binding: AllCategoryBinding()),
    GetPage(name: categoryScreen, page: () => const CategoryScreen()),
    GetPage(name: searchResultScreen, page: () => const SearchResultScreen()),
    GetPage(name: departmentsStoreScreen, page: () => const DepartmentsStoreScreen(),binding: DepartmentsStoreBinding()),
    GetPage(name: subcategoriesScreen, page: () => const SubcategoriesScreen(),binding: SubCategoriesBinding()),
    GetPage(name: homeScreen, page: () => const HomeScreen(),binding: HomeBinding()),
    GetPage(name: productDetailsScreen, page: () => const ProductDetailsScreen(),binding: ProductDetailsBindings()),
    GetPage(name: resultFilterScreen, page: () => const ResultFilterScreen(),binding: SearchResultBindings()),

  ];
}