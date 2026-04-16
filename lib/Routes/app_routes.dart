
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../presentation/common/login/view/login_screen.dart';
import '../presentation/common/sign_up/signup_screen.dart';
import '../presentation/common/verify/view/verify_screen.dart';
import '../presentation/electronics/home/binding/home_bindings.dart';
import '../presentation/electronics/home/view/home_screen.dart';

class AppRoutes {
  static const String signupScreen = '/signupScreen';
  static const String loginScreen = '/loginScreen';
  static const String verifyScreen = '/verifyScreen';
  static const String homeScreen = '/homeScreen';

  static List<GetPage> pages = <GetPage>[
  GetPage(name: signupScreen, page: () => const SignupScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: verifyScreen, page: () => const VerifyScreen()),
    GetPage(name: homeScreen, page: () => const HomeScreen(),binding: HomeBinding()),

  ];
}