// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// class GeneralExceptionWidget extends StatefulWidget {
//   final VoidCallback onPress;
//
//   const GeneralExceptionWidget({super.key, required this.onPress});
//
//   @override
//   State<GeneralExceptionWidget> createState() => _GeneralExceptionWidgetState();
// }
//
// class _GeneralExceptionWidgetState extends State<GeneralExceptionWidget> {
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//
//     return Padding(
//       padding: REdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         children: [
//           SizedBox(
//             height: height * .15,
//           ),
//           Icon(
//             Icons.error,
//             color: Colors.red, // Red to indicate an error
//             size: Get.height * 0.18,
//           ),
//           Padding(
//             padding: REdgeInsets.only(top: 30),
//             child: const Center(
//               child: Text(
//                 "Oops!\nSomething went wrong. Please try again.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w400,
//                   fontFamily: 'RammettoOne',
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: height * .06,
//           ),
//           InkWell(
//             onTap: widget.onPress, // Retry logic passed from the parent widget
//             child: Container(
//               height: 44,
//               width: 160,
//               decoration: BoxDecoration(
//                 color: Colors.red, // Retry button color (red for general error)
//                 borderRadius: BorderRadius.circular(50),
//               ),
//               child: const Center(
//                 child: Text(
//                   "Retry",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w400,
//                     fontFamily: 'RammettoOne',
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/theme/font_family.dart';
import '../../shared/theme/font_style.dart';

class GeneralExceptionWidget extends StatefulWidget {
  final VoidCallback onPress;

  const GeneralExceptionWidget({super.key, required this.onPress});

  @override
  State<GeneralExceptionWidget> createState() => _GeneralExceptionWidgetState();
}

class _GeneralExceptionWidgetState extends State<GeneralExceptionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Center(
      child: Padding(
        padding: REdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Animated Error Icon
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -_animation.value),
                  child: child,
                );
              },
              child: Container(
                height: 120.w,
                width: 120.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: 0.3),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: Colors.white,
                  size: 70,
                ),
              ),
            ),

            SizedBox(height: height * 0.04),

            /// Title
            Text(
              "Something went wrong",
              textAlign: TextAlign.center,
              style: AppFontStyle.text_20_600(Colors.black87,fontFamily: AppFontFamily.gilroyMedium),
            ),

            SizedBox(height: 8.h),

            /// Subtitle
            Text(
              "We’re having a bit of trouble right now.\nPlease try again in a moment.",
              textAlign: TextAlign.center,
              style: AppFontStyle.text_15_400(Colors.grey.shade600,fontFamily: AppFontFamily.gilroyMedium),
            ),

            SizedBox(height: height * 0.05),

            /// Retry Button
            GestureDetector(
              onTap: widget.onPress,
              child: Container(
                height: 40.h,
                width: 150.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.red,
                      Colors.red,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Try Again",
                    style: AppFontStyle.text_16_600(Colors.white,fontFamily: AppFontFamily.gilroyMedium),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

