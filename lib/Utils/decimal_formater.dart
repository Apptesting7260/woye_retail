

import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Allowing digits and one decimal point
    String newText = newValue.text;

    if (newText.isEmpty) {
      return newValue;
    }

    // Check if there's more than one decimal point
    if (newText.contains('.') && newText.split('.').length > 2) {
      return oldValue; // Reject the input if there's more than one decimal point
    }

    // Allow only digits and one decimal point
    final regex = RegExp(r'^[0-9.]*$');
    if (regex.hasMatch(newText)) {
      return newValue; // Accept input if it matches the regex
    }

    return oldValue; // Reject input if it doesn't match
  }
}