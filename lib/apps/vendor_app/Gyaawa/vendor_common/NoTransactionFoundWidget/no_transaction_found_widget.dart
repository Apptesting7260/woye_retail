import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/theme/colors.dart';
import '../../../../../shared/theme/font_family.dart';
import '../../../../../shared/widgets/custom_elevated_button.dart';

class NoTransactionFound extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final VoidCallback? onRetry;
  final IconData? icon;
  const NoTransactionFound({
    Key? key,
    this.title,
    this.subtitle,
    this.onRetry,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// Icon
            Icon(
                icon ?? Icons.receipt_long_outlined,
              size: 80.sp,
              color: AppColors.primary.withAlpha(50)
            ),

            SizedBox(height: 20.h),

            /// Title
            Text(
              title ?? "No Transactions Found",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                fontFamily: AppFontFamily.gilroyMedium
              ),
            ),

            SizedBox(height: 8.h),

            /// Subtitle
            Text(
              subtitle ??
                  "You don’t have any transactions yet.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey.shade600,
                  fontFamily: AppFontFamily.gilroyMedium
              ),
            ),

            if (onRetry != null) ...[
              SizedBox(height: 20.h),

              CustomElevatedButton(
                onPressed: onRetry ?? (){},
                text: "Retry",
              )
            ]
          ],
        ),
      ),
    );
  }
}