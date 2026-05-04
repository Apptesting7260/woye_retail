import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gyaawa/routes/user_routes/user_app_routes.dart';
import 'package:gyaawa/routes/vendor_routes/vendor_app_routes.dart';
import 'package:gyaawa/shared/theme/colors.dart';
import 'apps/user_app/presentation/common/splash/view/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

GlobalKey<ScaffoldState>? scaffoldKey = GlobalKey<ScaffoldState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            // scaffoldBackgroundColor: AppColors.backGroundColor,
            scaffoldBackgroundColor: AppColors.backgroundClr,
            dividerColor: Colors.transparent,
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            ),
          ),
          // getPages: UserRoutes.pages,
          getPages: [
            ...UserRoutes.pages,
            ...VendorAppRoutes.pages,
          ],
          // getPages: VendorAppRoutes.pages,
          home: SplashScreen(),
        );
      },
    );
  }
}