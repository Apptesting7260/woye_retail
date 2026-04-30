import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/colors.dart';
import '../theme/font_family.dart';
import '../theme/font_style.dart';

class OtpInputField extends StatefulWidget {
  final Function(String) onCompleted;
  final FormFieldValidator<String>? validator;

  const OtpInputField({
    super.key,
    required this.onCompleted,
    this.validator,
  });

  @override
  State<OtpInputField> createState() => OtpInputFieldState();
}

class OtpInputFieldState extends State<OtpInputField> {
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
  List.generate(6, (_) => FocusNode());

  String getOtp() => _controllers.map((e) => e.text).join();

  void clearOtp() {
    for (var c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _onChanged(int index, FormFieldState<String> state) {
    if (_controllers[index].text.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
    final otp = getOtp();
    state.didChange(otp);
    widget.onCompleted(otp);
  }

  void _onKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                6,
                    (index) => _buildOtpBox(index, state),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Text(
                  state.errorText ?? "",
                  style: AppFontStyle.text_12_400(
                    AppColors.errorColor,
                    fontFamily: AppFontFamily.interMedium,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildOtpBox(int index, FormFieldState<String> state) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) => _onKeyEvent(event, index),
      child: OtpTextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        hasError: state.hasError,
        onChanged: (_) => _onChanged(index, state),
      ),
    );
  }
}

// ─── Custom OTP TextField ───────────────────────────────────────

class OtpTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final ValueChanged<String>? onChanged;

  const OtpTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hasError,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50.w,
      height: 50.h,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: AppFontStyle.text_16_400(
          AppColors.greyTextColor,
          fontFamily: AppFontFamily.interMedium,
        ),
        decoration: InputDecoration(
          counterText: "",
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(
              color: hasError ? AppColors.errorColor : AppColors.borderClr,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(
              color: hasError ? AppColors.errorColor : AppColors.greyTextColor,
              width: 1.5,
            ),
          ),
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: onChanged,
      ),
    );
  }
}