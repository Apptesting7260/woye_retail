import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../Core/Constant/image_constant.dart';
import '../../theme/colors.dart';
import '../../theme/font_family.dart';
import '../../theme/font_style.dart';

class CustomBankAccountCard extends StatelessWidget {
  final String? image;
  final String? title;
  final String? bankAccountNumber;
  final VoidCallback? onTap;
  final VoidCallback? tileOnTap;
  final Color? borderColor;

  const CustomBankAccountCard(
      {super.key, this.image, this.title, this.bankAccountNumber, this.onTap, this.borderColor, this.tileOnTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap:tileOnTap,
      // minTileHeight: 91,
      contentPadding: REdgeInsets.fromLTRB(15, 4, 5, 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
        side: BorderSide(color: borderColor ?? AppColors.primary, width: 1),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Image.asset(
          image!,
          width: 31,
          height: 36,
        ),
      ),
      title: Text(
        title ?? "",
        style: AppFontStyle.text_18_400(
          AppColors.darkText,
          fontFamily: AppFontFamily.gilroySemiBold,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: RichText(
          text: TextSpan(
            children: [
              // TextSpan(
              //     text: "•• •• ••• •••",
              //     style: AppFontStyle.text_22_600(
              //       AppColors.mediumText.withOpacity(0.8),
              //       fontFamily: AppFontFamily.gilroyMedium,
              //     )),
              TextSpan(
                  text: " $bankAccountNumber",
                  style: AppFontStyle.text_18_400(
                    AppColors.mediumText,
                    fontFamily: AppFontFamily.gilroyMedium,
                  )),
            ],
          ),
        ),
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(bottom: 30.0, right: 10),
        child: GestureDetector(
          onTap: onTap,
          child: SvgPicture.asset(
            ImageConstants.addOnDelete,
            height: 24,
            width: 24,
          ),
        ),
      ),
    );
  }
}
