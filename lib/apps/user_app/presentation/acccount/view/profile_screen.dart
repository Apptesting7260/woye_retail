import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gyaawa/shared/widgets/custom_elevated_button.dart';

import '../../../../../Core/Constant/image_constant.dart';
import '../../../../../Utils/sized_box.dart';
import '../../../../../routes/user_routes/user_app_routes.dart';
import '../../../../../shared/theme/colors.dart';
import '../../../../../shared/theme/font_family.dart';
import '../../../../../shared/theme/font_style.dart';
import '../../../../../shared/widgets/shimmer_widget.dart';
import '../../common/tab_bar/common_tab_bar.dart';
import '../controller/profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomCategoryBar(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Account",
                      style: AppFontStyle.text_24_500(
                        AppColors.black,
                        fontFamily: AppFontFamily.interBold,
                      ),
                    ),
                hBox(2),
                Text(
                  "Manage your account settings and preferences",
                  style: AppFontStyle.text_14_400(
                    AppColors.buttonHideColor,
                    fontFamily: AppFontFamily.interRegular,
                  ),
                ),
                hBox(16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(
                          width: 0.5,
                          color: AppColors.borderClr,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              _profileImage("https://i.pravatar.cc/150?img=3"),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.black,
                                  ),
                                  child:  Icon(
                                    Icons.camera_alt,
                                    size: 12,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          hBox(15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.lightButtonClr,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "John Doe",
                                  style: AppFontStyle.text_10_500(
                                    AppColors.blueTextColor,
                                    fontFamily: AppFontFamily.interMedium,
                                  ),
                                ),
                              ),
                            wBox(8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.greenButtonColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "Verified",
                                  style: AppFontStyle.text_10_500(
                                    AppColors.greenTextClr,
                                    fontFamily: AppFontFamily.interMedium,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          hBox(16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "24",
                                    style: AppFontStyle.text_20_500(
                                      AppColors.blueLightColor,
                                      fontFamily: AppFontFamily.interBold,
                                    ),
                                  ),
                                  Text(
                                    "Total Orders",
                                    style: AppFontStyle.text_10_500(
                                      AppColors.buttonHideColor,
                                      fontFamily: AppFontFamily.interRegular,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "GHS 400",
                                    style: AppFontStyle.text_20_500(
                                      AppColors.blueLightColor,
                                      fontFamily: AppFontFamily.interBold,
                                    ),
                                  ),
                                  Text(
                                    "Wallet Balance",
                                    style: AppFontStyle.text_10_500(
                                      AppColors.buttonHideColor,
                                      fontFamily: AppFontFamily.interRegular,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    hBox(20),
                    CustomElevatedButton(
                      color: AppColors.white,
                      borderSide: BorderSide(color: AppColors.borderClr),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          wBox(20),
                          SvgPicture.asset(
                            ImageConstants.orderSvg,
                            height: 15,
                            width: 15,
                          ),
                          wBox(10),
                          Text(
                            "Orders",
                            style: AppFontStyle.text_14_500(
                              AppColors.black,
                              fontFamily: AppFontFamily.interMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    hBox(10),
                    CustomElevatedButton(
                      color: AppColors.white,
                      borderSide: BorderSide(color: AppColors.borderClr),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          wBox(20),
                          SvgPicture.asset(
                            ImageConstants.walletSvg,
                            height: 15,
                            width: 15,
                          ),
                          wBox(10),
                          Text(
                            "Wallet",
                            style: AppFontStyle.text_14_500(
                              AppColors.black,
                              fontFamily: AppFontFamily.interMedium,
                            ),
                          ),
                        ],
                      ),
                    ), hBox(10),
                    CustomElevatedButton(
                      color: AppColors.white,
                      borderSide: BorderSide(color: AppColors.borderClr),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          wBox(20),
                          SvgPicture.asset(
                            ImageConstants.peopleSvg,
                            height: 15,
                            width: 15,
                          ),
                          wBox(10),
                          Text(
                            "Invite Friends",
                            style: AppFontStyle.text_14_500(
                              AppColors.pinkTextClr,
                              fontFamily: AppFontFamily.interMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    hBox(20),
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
                            Text(
                              "Delivery Addresses",
                              style: AppFontStyle.text_14_500(
                                AppColors.black,
                                fontFamily: AppFontFamily.interRegular,
                              ),
                            ),
                            hBox(16),
                            ...controller.addresses.map((address) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    border: Border.all(
                                      width: 0.5,
                                      color: AppColors.borderClr,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            address["label"],
                                            style: AppFontStyle.text_18_600(
                                              AppColors.black,
                                              fontFamily: AppFontFamily.interRegular,
                                            ),
                                          ),
                                          if (address["isDefault"])
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF424242),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                "Default",
                                                style: AppFontStyle.text_12_500(
                                                  AppColors.white,
                                                  fontFamily: AppFontFamily.interRegular,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      hBox(8),
                                      Text(
                                        address["street"],
                                        style: AppFontStyle.text_14_400(
                                          AppColors.greyClr,
                                          fontFamily: AppFontFamily.interRegular,
                                        ),
                                      ),
                                      hBox(4),
                                      Text(
                                        address["city"],
                                        style: AppFontStyle.text_14_400(
                                          AppColors.greyClr,
                                          fontFamily: AppFontFamily.interRegular,
                                        ),
                                      ),
                                      hBox(4),
                                      Text(
                                        address["country"],
                                        style: AppFontStyle.text_14_400(
                                          AppColors.greyClr,
                                          fontFamily: AppFontFamily.interRegular,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                            hBox(10),
                            CustomElevatedButton(
                              color: AppColors.white,
                              borderSide: BorderSide(color: AppColors.borderClr),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.location_on_outlined,size: 20,color: AppColors.black,),
                                  wBox(5),
                                  Text(
                                    "Add New Address",
                                    style: AppFontStyle.text_14_500(
                                      AppColors.black,
                                      fontFamily: AppFontFamily.interMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ] ),
                    ),
                hBox(10),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          CustomElevatedButton(
                            width: 70,
                            height: 35,
                            color: AppColors.white,
                            borderSide: BorderSide(
                              color: AppColors.borderClr,
                              width: 0.5,
                            ),
                            onPressed: () {
                              Get.toNamed(UserRoutes.editProfile);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  ImageConstants.editSvg,
                                  height: 14,
                                  width: 14,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "Edit",
                                  style: AppFontStyle.text_12_500(
                                    AppColors.black,
                                    fontFamily: AppFontFamily.interMedium,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      _profileTile(
                          icon: ImageConstants.paymentSvg,
                          title: 'Payment Method',
                          onTap: () {}),
                      _profileTile(
                          icon: ImageConstants.promotionSvg,
                          title: 'Promotion Code',
                          onTap: () {}),
                      _profileTile(
                          icon: ImageConstants.notificationSvg,
                          title: 'Notifications',
                          onTap: () {}),
                      _profileTile(
                          icon: ImageConstants.settingsSvg,
                          title: 'Settings',
                          onTap: () {}),
                      _profileTile(
                          icon: ImageConstants.termSvg,
                          title: 'Terms & Conditions',
                          onTap: () {}),
                      _profileTile(
                          icon: ImageConstants.privacySvg,
                          title: 'Privacy Policy',
                          onTap: () {}),
                      _profileTile(
                          icon: ImageConstants.helpSvg,
                          title: 'Help',
                          onTap: () {}),
                      _profileTile(
                          icon: ImageConstants.logoutSvg,
                          showArrow: false,
                          title: 'Logout',titleColor: AppColors.buttonColor,
                          onTap: () {}),
                    ],
                  ),
                ),
                    hBox(50),
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
      width: 80.h,
      height: 80.h,
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
  Widget _profileTile({
    required String icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
    bool showArrow = true,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      leading: SvgPicture.asset(
        icon,
        color: iconColor,
        height: 22,
        width: 22,
      ),
      title: Text(
        title,
        style: AppFontStyle.text_14_500(
          titleColor ?? AppColors.blueButtonColor,
          fontFamily: AppFontFamily.interMedium,
        ),
      ),
      trailing:
      showArrow ? const Icon(Icons.arrow_forward_ios, size: 19) : null,
      onTap: onTap,
    );
  }
}