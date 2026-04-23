import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gyaawa/shared/widgets/vendor_widgets/CustomPhoneNumberField/phone_number_service.dart';

import '../../../theme/colors.dart';
import '../../../theme/font_style.dart';

final PhoneNumberService phoneNumberService = Get.put(PhoneNumberService());

class CustomPhoneNumberField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String initialSelection;

  const CustomPhoneNumberField({
    super.key,
    required this.controller,
    this.hintText = 'Phone Number',
    this.initialSelection = "IN",
  });

  @override
  State<CustomPhoneNumberField> createState() => _CustomPhoneNumberFieldState();
}

class _CustomPhoneNumberFieldState extends State<CustomPhoneNumberField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        }
        if (value.length != phoneNumberService.countryPhoneLength.value) {
          return 'Please enter a valid phone number (${phoneNumberService.countryPhoneLength.value} digits required)';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: CountryCodePicker(
            padding: EdgeInsets.only(left: 10.h),
            onChanged: (CountryCode countryCode) {
              print("country code===========> ${countryCode.code}");
              phoneNumberService.updateCountryCode(countryCode);
              int? countrylength = phoneNumberService
                  .countryPhoneDigitsCheck[countryCode.code.toString()];
              phoneNumberService.countryPhoneLength.value = countrylength!;
              setState(() {});
            },
            initialSelection: widget.initialSelection),
        hintText: widget.hintText,
        hintStyle: AppFontStyle.text_14_400(AppColors.hintText),
        isDense: true,
        contentPadding: REdgeInsets.symmetric(vertical: 15, horizontal: 20),
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.textFieldBorder),
          borderRadius: BorderRadius.all(Radius.circular(15.r)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.textFieldBorder),
          borderRadius: BorderRadius.all(Radius.circular(15.r)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.textFieldBorder),
          borderRadius: BorderRadius.all(Radius.circular(15.r)),
        ),
      ),
    );
  }
}
