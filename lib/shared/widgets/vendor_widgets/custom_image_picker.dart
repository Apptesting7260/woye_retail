import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Utils/sized_box.dart';
import '../../theme/colors.dart';
import '../../theme/font_style.dart';

class CustomImagePicker extends StatelessWidget {
  const CustomImagePicker({super.key, required this.controller});

  final dynamic controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 5,
              blurStyle: BlurStyle.outer)
        ],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r)),
        color: Colors.white,
        // gradient: LinearGradient(
        //     colors: [Colors.white, AppColors.primary.withOpacity(0.05)],
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter),
      ),
      child: Padding(
        padding: REdgeInsets.all(12.0),
        child: Column(
          children: [
            Text("Pick an Image",
                style: GoogleFonts.poppins(
                  textStyle: AppFontStyle.text_18_400(AppColors.mediumText),
                )),
            hBox(18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    controller.pickImage(ImageSource.camera);
                    // _pickImageFromCamera();
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: REdgeInsets.all(10.h),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 5,
                            blurStyle: BlurStyle.outer)
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(8.r)),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.photo_camera_outlined,
                          color: AppColors.lightText,
                          size: 24.h,
                        ),
                        Text(
                          "Camera",
                          style: AppFontStyle.text_16_400(AppColors.lightText),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.pickImage(ImageSource.gallery);

                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: REdgeInsets.all(10.h),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 5,
                            blurStyle: BlurStyle.outer)
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(8.r)),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.photo_library_outlined,
                          color: AppColors.lightText,
                          size: 24.h,
                        ),
                        Text(
                          "Gallery",
                          style: AppFontStyle.text_16_400(AppColors.lightText),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
