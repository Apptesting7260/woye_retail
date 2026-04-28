// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gyaawa/Utils/sized_box.dart';
// import 'package:gyaawa/shared/theme/font_family.dart';
// import 'package:gyaawa/shared/theme/font_style.dart';
//
// class CustomCategoryBar extends StatefulWidget {
//   final List<String> categories;
//   final Function(int)? onTap;
//   final int initialIndex;
//
//   const CustomCategoryBar({
//     super.key,
//     this.categories = const [
//       'All Categories',
//       'Featured',
//       'Editor\'s Choice',
//       'Gift',
//     ],
//     this.onTap,
//     this.initialIndex = 0,
//   });
//
//   @override
//   State<CustomCategoryBar> createState() => _CustomCategoryBarState();
// }
//
// class _CustomCategoryBarState extends State<CustomCategoryBar> {
//   late int selectedIndex;
//
//   @override
//   void initState() {
//     super.initState();
//     selectedIndex = widget.initialIndex;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 48.h,
//       color: const Color(0xFF2E3A4E),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         padding: EdgeInsets.symmetric(horizontal: 3.w),
//         child: Row(
//           children: List.generate(widget.categories.length, (index) {
//             return GestureDetector(
//               onTap: () {
//                 setState(() => selectedIndex = index);
//                 widget.onTap?.call(index);
//               },
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 8.w),
//                 child: Row(
//                   children: [
//                     if (index == 0) ...[
//                       IconButton(
//                         onPressed: () {},
//                         icon: const Icon(
//                           Icons.menu,
//                           color: Colors.white,
//                           size: 20,
//                         ),
//                       ),
//                       ],
//                     Text(
//                       widget.categories[index],
//                       style: AppFontStyle.text_13_400(
//                         Colors.white,
//                         fontFamily: selectedIndex == index
//                             ? AppFontFamily.interMedium
//                             : AppFontFamily.interMedium,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gyaawa/shared/theme/font_family.dart';
import 'package:gyaawa/shared/theme/font_style.dart';

import '../../../../../routes/user_routes/user_app_routes.dart';


class CustomCategoryBar extends StatefulWidget {
  final List<String> categories;
  final Function(int)? onTap;
  final int initialIndex;

  const CustomCategoryBar({
    super.key,
    this.categories = const [
      'All Categories',
      'Featured',
      'Editor\'s Choice',
      'Gift',
    ],
    this.onTap,
    this.initialIndex = 0,
  });

  @override
  State<CustomCategoryBar> createState() => _CustomCategoryBarState();
}

class _CustomCategoryBarState extends State<CustomCategoryBar> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  void _handleCategoryTap(int index) {
    widget.onTap?.call(index);
    switch (index) {
      case 0:
     Get.toNamed(UserRoutes.allCategoriesScreen);
        break;
      case 1:
        Get.toNamed(UserRoutes.featuredScreen);
        break;
      case 2:
        Get.toNamed(UserRoutes.editorChoiceScreen);
        break;
      case 3:
        Get.toNamed(UserRoutes.giftScreen);
        break;
      default:
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      color: const Color(0xFF2E3A4E),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: Row(
          children: List.generate(widget.categories.length, (index) {
            return GestureDetector(
              onTap: () => _handleCategoryTap(index),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Row(
                  children: [
                    if (index == 0) ...[
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                    Text(
                      widget.categories[index],
                      style: AppFontStyle.text_13_400(
                        Colors.white,
                        fontFamily: selectedIndex == index
                            ? AppFontFamily.interMedium
                            : AppFontFamily.interMedium,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}