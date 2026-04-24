
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:gyaawa/Core/Constant/image_constant.dart';
import 'package:gyaawa/apps/user_app/presentation/common/home_address/controller/door_delivery_address_controller.dart';
import 'package:gyaawa/apps/user_app/presentation/common/tab_bar/common_tab_bar.dart';
import 'package:gyaawa/shared/widgets/custom_dropdown_api.dart';
import '../../../../../../Utils/sized_box.dart';
import '../../../../../../shared/theme/colors.dart';
import '../../../../../../shared/theme/font_family.dart';
import '../../../../../../shared/theme/font_style.dart';
import '../../../../../../shared/widgets/custom_elevated_button.dart';
import '../../../../../../shared/widgets/custom_text_form_field.dart';

class AddNewDoorDeliveryAddress extends StatefulWidget {
  const AddNewDoorDeliveryAddress({super.key});

  @override
  State<AddNewDoorDeliveryAddress> createState() =>
      _AddNewDoorDeliveryAddressState();
}

class _AddNewDoorDeliveryAddressState extends State<AddNewDoorDeliveryAddress> {
  final DoorDeliveryAddressController controller = Get.put(DoorDeliveryAddressController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomCategoryBar(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Icon(Icons.arrow_back_ios,
                                color: Colors.black, size: 23),
                          ),
                          wBox(10),
                          Text(
                            "Delivery Address",
                            style: AppFontStyle.text_22_600(AppColors.black,
                                fontFamily: AppFontFamily.interBold),
                          ),
                        ],
                      ),
                      hBox(20),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border:
                              Border.all(width: 0.7, color: AppColors.borderClr),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              hBox(24),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined,
                                      size: 24, color: AppColors.black),
                                  wBox(6),
                                  Text(
                                    "Door Delivery Information ",
                                    style: AppFontStyle.text_14_400(
                                        AppColors.black,
                                        fontFamily: AppFontFamily.interRegular),
                                  ),
                                ],
                              ),
                              hBox(15),
                              Text(
                                "Full Name",
                                style: AppFontStyle.text_12_500(AppColors.black,
                                    fontFamily: AppFontFamily.interMedium),
                              ),
                              hBox(10),
                              CustomTextFormField(
                                fillColor: AppColors.searchText,
                                height: 50,
                                hintText: "Jhon Doe",
                              ),
                              hBox(10),
                              Text(
                                "Phone Number",
                                style: AppFontStyle.text_12_500(AppColors.black,
                                    fontFamily: AppFontFamily.interMedium),
                              ),
                              hBox(10),
                              CustomTextFormField(
                                height: 52,
                                hintText: "Phone Number",
                                textInputType: TextInputType.phone,
                                fillColor: AppColors.searchText,
                                prefixIcon: CountryCodePicker(
                                  textStyle: AppFontStyle.text_15_400(
                                      AppColors.greyTextColor,
                                      fontFamily: AppFontFamily.interRegular),
                                  padding: const EdgeInsets.only(left: 10),
                                  showFlag: false,
                                  showDropDownButton: true,
                                ),
                              ),
                              hBox(10),
                              Text(
                                "Address",
                                style: AppFontStyle.text_12_500(AppColors.black,
                                    fontFamily: AppFontFamily.interMedium),
                              ),
                              hBox(10),
                              CustomTextFormField(
                                fillColor: AppColors.searchText,
                                height: 50,
                                hintText: "123 Main Street",
                              ),
                              hBox(10),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "City",
                                          style: AppFontStyle.text_12_500(
                                            AppColors.black,
                                            fontFamily: AppFontFamily.interMedium,
                                          ),
                                        ),
                                        hBox(6),
                                        CustomTextFormField(
                                          fillColor: AppColors.searchText,
                                          height: 47,
                                          hintText: "Accra",
                                        ),
                                      ],
                                    ),
                                  ),
                                  wBox(10),
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "State/Region",
                                          style: AppFontStyle.text_12_500(
                                            AppColors.black,
                                            fontFamily: AppFontFamily.interMedium,
                                          ),
                                        ),
                                        hBox(6),
                                        CustomDropDownApi(
                                          hintText: "Select state",
                                          borderColor: AppColors.searchText,
                                          items: controller.stateList,
                                          onChanged: (val) {},
                                        ),
                                      ],
                                    ),
                                  ),
                                   wBox(10),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Zip Code",
                                          style: AppFontStyle.text_12_500(
                                            AppColors.black,
                                            fontFamily: AppFontFamily.interMedium,
                                          ),
                                        ),
                                        hBox(6),
                                        CustomTextFormField(
                                          height: 47,
                                          fillColor: AppColors.searchText,
                                          hintText: "00000",
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              hBox(20),
                              Obx(() => Row(
                                children: [
                                  _addressType("Home", Icons.home_outlined),
                                  wBox(10),
                                  _addressType("Office", Icons.apartment_outlined),
                                  wBox(10),
                                  _addressType("Other", Icons.location_on_outlined),
                                ],
                              )),
                              hBox(15),
                              Obx(() => Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      controller.isDefault.value = !controller.isDefault.value;
                                    },
                                    child: Container(
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: AppColors.blackClr, width: 1,
                                        ),
                                        color: controller.isDefault.value
                                            ? AppColors.buttonColor
                                            : Colors.transparent,
                                      ),
                                      child: controller.isDefault.value
                                          ? Icon(
                                        Icons.check, size: 23, color: Colors.white,) : null,
                                    ),
                                  ),
                                  wBox(10),
                                  Text(
                                    "Set default",
                                    style: AppFontStyle.text_14_400(
                                      AppColors.black,
                                      fontFamily: AppFontFamily.onestRegular,
                                    ),
                                  ),
                                ],
                              )),
                              hBox(20),
                            ],
                          ),
                        ),
                      ),hBox(20),
                      Center(
                        child: CustomElevatedButton(
                          color: AppColors.buttonColor,
                          height: 45,
                          width: 331.w,
                          text: "Save Address",
                          onPressed: () {},
                        ),
                      ),
                      hBox(20),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:AppColors.fillClr2,
                          border: Border.all(color: AppColors.borderClr),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.lightBlueClr,
                              child:SvgPicture.asset(
                                ImageConstants.homeSvg,
                              ),
                            ),
                            wBox(10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Never miss a delivery!",
                                    style: AppFontStyle.text_14_600(
                                      AppColors.blueColor,
                                      fontFamily: AppFontFamily.onestSemiBold,
                                    ),
                                  ),
                                  hBox(6),
                                  Text(
                                    "Our self-service lockers and pickup stations are a convenient way to get your package on your own",
                                    maxLines: 4,
                                    style: AppFontStyle.text_12_400(
                                      AppColors.lightBlueTextClr,
                                      fontFamily: AppFontFamily.interRegular,
                                    ),
                                  ),
                                  hBox(10),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.lightBlueClr),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "Find A Station",
                                      style: AppFontStyle.text_12_500(
                                        AppColors.lightBlueTextClr,
                                        fontFamily: AppFontFamily.interMedium,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            hBox(30),
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
  Widget _addressType(String title, IconData icon) {
    bool isSelected =
        controller.selectedAddressType.value == title;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          controller.selectedAddressType.value = title;
        },
        child: Container(
          height: 45,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.btnClr
                : AppColors.white,
            border: Border.all(
              color: isSelected
                  ? AppColors.buttonColor
                  : AppColors.borderClr,
              width: 1.2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected
                    ? AppColors.buttonColor
                    : Colors.black,
              ),
              wBox(6),
              Text(
                title,
                style: AppFontStyle.text_14_500(
                  isSelected
                      ? AppColors.buttonColor
                      : AppColors.black,
                  fontFamily: AppFontFamily.interMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }}
