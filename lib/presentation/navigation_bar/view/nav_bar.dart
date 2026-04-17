import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gyaawa/Utils/sized_box.dart';
import '../../../shared/theme/colors.dart';
import '../../../shared/theme/font_family.dart';
import '../../electronics/home/view/home_screen.dart';
import '../../electronics/product_ditails/product_ditails_screen/produt_screen.dart';
import '../controller/nav_bar_controller.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final NavigationController controller = Get.put(NavigationController());

  List<Widget> get screens => [
    const HomeScreen(),
    const ProductDetailsScreen(),
    const HomeScreen(),
    const HomeScreen(),
    const HomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final index = controller.selectedIndex.value;
        if (index < 0 || index >= screens.length) {
          return const HomeScreen();
        }
        return screens[index];
      }),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController controller = Get.find<NavigationController>();

    return Obx(
          () => Container(
        color: AppColors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: List.generate(
                controller.navItems.length,
                    (index) => Expanded(
                  child: Container(
                    height: controller.selectedIndex.value == index
                        ? 1.7.h
                        : 0.8.h,
                    color: controller.selectedIndex.value == index
                        ? AppColors.red
                        : AppColors.black,
                  ),
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    controller.navItems.length,
                        (index) => _buildNavItem(controller, index),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(NavigationController controller, int index) {
    final bool isSelected = controller.selectedIndex.value == index;

    return GestureDetector(
      onTap: () => controller.changeIndex(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              isSelected
                  ? controller.navItems[index]['activeIcon']
                  : controller.navItems[index]['icon'],
              color: isSelected ? AppColors.red : AppColors.greyTextColor,
              size: 25.r,
            ),
            hBox(4),
            Text(
              controller.navItems[index]['label'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                fontFamily: isSelected
                    ? AppFontFamily.interMedium
                    : AppFontFamily.interRegular,
                color: isSelected ? AppColors.red : AppColors.greyTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}