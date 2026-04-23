import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:gyaawa/Utils/sized_box.dart';
import 'package:gyaawa/shared/widgets/custom_text_form_field.dart';

import '../../../../../shared/theme/colors.dart';
import '../../../../../shared/theme/font_family.dart';
import '../../../../../shared/theme/font_style.dart';
import '../../../../../shared/widgets/custom_dropdown_api.dart';
import '../../../../../shared/widgets/custom_elevated_button.dart';
import '../../../../../shared/widgets/shimmer_widget.dart';
import '../../common/tab_bar/common_tab_bar.dart';


class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCategoryBar(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(children: [
                  Row(
                    children: [
                      Center(
                          child: IconButton(
                              onPressed: () {Get.back();},
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: AppColors.black,
                                size: 20,
                              ))),
                      Text(
                        "Personal Info",
                        style: AppFontStyle.text_24_500(
                          AppColors.black,
                          fontFamily: AppFontFamily.interBold,
                        ),
                      ),
                    ],
                  ),
                  hBox(30),
                  Stack(
                    children: [
                      _profileImage("https://i.pravatar.cc/150?img=3"),
                      Positioned(
                        bottom: 0,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.black,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 25,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),hBox(30),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(
                        width: 0.5,
                        color: AppColors.borderClr,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Personal Information",
                              style: AppFontStyle.text_14_400(
                                AppColors.black,
                                fontFamily: AppFontFamily.interRegular,
                              ),
                            ),
                            wBox(5),
                            CustomElevatedButton(
                              height: 35,
                              width: 80,
                              color: AppColors.white,
                              borderSide: BorderSide(color: AppColors.borderClr, width: 0.5,),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.close,size: 18,),
                                  wBox(5),
                                  Text(
                                    "Cancel",
                                    style: AppFontStyle.text_12_500(
                                      AppColors.black,
                                      fontFamily: AppFontFamily.interMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            wBox(5),
                            CustomElevatedButton(
                              height: 35,
                              width: 80,
                              color: AppColors.buttonColor,
                              borderSide: BorderSide(color: AppColors.borderClr, width: 0.5,),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.save,size: 18,color: AppColors.white,),
                                  wBox(5),
                                  Text(
                                    "Save",
                                    style: AppFontStyle.text_12_500(
                                      AppColors.white,
                                      fontFamily: AppFontFamily.interMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        hBox(10),
                        Text(
                          "Full Name",
                          style: AppFontStyle.text_12_500(
                            AppColors.black,
                            fontFamily: AppFontFamily.interMedium,
                          ),
                        ),
                        hBox(5),
                        CustomTextFormField(
                          height: 45,
                          borderRadius: BorderRadius.circular(10),
                          fillColor: AppColors.searchText,
                          hintText: "User Name",
                          hintStyle: AppFontStyle.text_14_400(AppColors.buttonHideColor,fontFamily: AppFontFamily.interRegular),
                        ),   hBox(15),
                        Text(
                          "Email Address",
                          style: AppFontStyle.text_12_500(
                            AppColors.black,
                            fontFamily: AppFontFamily.interMedium,
                          ),
                        ),
                        hBox(5),
                        CustomTextFormField(
                          height: 45,
                          borderRadius: BorderRadius.circular(10),
                          fillColor: AppColors.searchText,
                          hintText: "Email",
                          hintStyle: AppFontStyle.text_14_400(AppColors.buttonHideColor,fontFamily: AppFontFamily.interRegular),

                        ),
                        hBox(15),
                        Text(
                          "Phone Number",
                          style: AppFontStyle.text_12_500(
                            AppColors.black,
                            fontFamily: AppFontFamily.interMedium,
                          ),
                        ),
                        hBox(5),
                        CustomTextFormField(
                          height: 45,
                          borderRadius: BorderRadius.circular(10),
                          fillColor: AppColors.searchText,
                          hintText: " Enter Mobile Number",
                          hintStyle: AppFontStyle.text_14_400(AppColors.buttonHideColor,fontFamily: AppFontFamily.interRegular),
                        ),
                        hBox(15),
                        Text(
                          "Location",
                          style: AppFontStyle.text_12_500(
                            AppColors.black,
                            fontFamily: AppFontFamily.interMedium,
                          ),
                        ),
                        hBox(5),
                        CustomTextFormField(
                          height: 45,
                          borderRadius: BorderRadius.circular(10),
                          fillColor: AppColors.searchText,
                          hintText: "Search Location",
                          hintStyle: AppFontStyle.text_14_400(AppColors.buttonHideColor,fontFamily: AppFontFamily.interRegular),
                        ),  hBox(15),
                        Text(
                          "Gender",
                          style: AppFontStyle.text_12_500(
                            AppColors.black,
                            fontFamily: AppFontFamily.interMedium,
                          ),
                        ),
                        hBox(5),
                        CustomDropDownApi(
                          hintText: "Select Gender",
                          hintStyle: AppFontStyle.text_16_400(AppColors.lightText,fontFamily: AppFontFamily.onestRegular),
                          items: genderItems,
                          textStyle: AppFontStyle.text_16_400(AppColors.greyClr,fontFamily: AppFontFamily.onestRegular),
                          // selectedValue: signUpFormController.genderController.text.isEmpty
                          //     ? null
                          //     : signUpFormController.genderController.text,
                          onChanged: (value) {
                            // signUpFormController.genderController.text = value ?? '';
                          },
                          borderRadius: 10,
                          // isExpanded: true,
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _profileImage(String? imageUrl) {
    return SizedBox(
      width: 140.h,
      height: 140.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.r),
        child: imageUrl != null && imageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => const ShimmerWidget(),
                errorWidget: (_, __, ___) => _defaultAvatar(),
              )
            : _defaultAvatar(),
      ),
    );
  }

  Widget _defaultAvatar() {
    return Container(
      color: AppColors.overlayColor.withOpacity(0.4),
      child: Icon(
        Icons.person,
        size: 40.h,
        color: AppColors.greyLightColor.withOpacity(0.5),
      ),
    );
  }
}

class CommonDropDownItem {
  final String id;
  final String name;
  CommonDropDownItem({required this.id, required this.name});
}

final List<CommonDropDownItem> genderItems = [
  CommonDropDownItem(id: "Male", name: "Male"),
  CommonDropDownItem(id: "Female", name: "Female"),
  CommonDropDownItem(id: "Other", name: "Other"),
];
