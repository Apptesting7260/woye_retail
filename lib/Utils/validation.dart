import 'package:flutter/material.dart';

/// Checks if string is email.
bool isValidEmail(String? inputString, {bool isRequired = false,}) {
  bool isInputStringValid = false;

  if (!isRequired && (inputString == null ? true : inputString.isEmpty)) {
    isInputStringValid = true;
  }

  if (inputString != null && inputString.isNotEmpty) {
    const pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    final regExp = RegExp(pattern);

    isInputStringValid = regExp.hasMatch(inputString);
  }

  return isInputStringValid;
}

/// Password should have,
/// at least a upper case letter
///  at least a lower case letter
///  at least a digit
///  at least a special character [@#$%^&+=]
///  length of at least 4
/// no white space allowed
bool isValidPassword(String? inputString, {bool isRequired = false,}) {
  bool isInputStringValid = false;

  if (!isRequired && (inputString == null ? true : inputString.isEmpty)) {
    isInputStringValid = true;
  }

  if (inputString != null && inputString.isNotEmpty) {
    const pattern = r'^(?=.*?[A-Z])(?=(.*[a-z]){1,})(?=(.*[\d]){1,})(?=(.*[\W]){1,})(?!.*\s).{8,}$@';

    final regExp = RegExp(pattern);

    isInputStringValid = regExp.hasMatch(inputString);
  }

  return isInputStringValid;
}

String? validatePassword(String? value) {
  debugPrint(value);
  if (value == null || value.isEmpty) {
    return 'Please enter a password.';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters.';
  }
  return null;
}

/// Checks if string consist only Alphabet. (No Whitespace)
bool isText(String? inputString, {bool isRequired = false,}) {
  bool isInputStringValid = false;

  if (!isRequired && (inputString == null ? true : inputString.isEmpty)) {
    isInputStringValid = true;
  }

  if (inputString != null && inputString.isNotEmpty) {
    const pattern = r'^[a-zA-Z]+$';

    final regExp = RegExp(pattern);

    isInputStringValid = regExp.hasMatch(inputString);
  }

  return isInputStringValid;
}


String? validateStrongPassword(String password) {
  String errorMessage = '';

  if (password.length < 8) {
    errorMessage += 'Password must be longer than 8 characters.\n';
  }

  if (!password.contains(RegExp(r'[A-Z]'))) {
    errorMessage += 'At least one uppercase letter (e.g., A, B, C, ...)\n';
  }

  if (!password.contains(RegExp(r'[a-z]'))) {
    errorMessage += 'At least one lowercase letter (e.g., a, b, c, ...)\n';
  }

  if (!password.contains(RegExp(r'[0-9]'))) {
    errorMessage += 'At least one numeric digit (e.g., 1, 2, 3, ...)\n';
  }

  if (!password.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
    errorMessage += 'At least one special character (e.g., ! @ # \$ & * ~)\n';
  }
  return errorMessage.isEmpty ? null : errorMessage;
}


//-----------------------------

//<<---------------------------------------- Input validator

bool isValidCharacters(String value) {

  final regex = RegExp(r'^[a-zA-Z0-9\s\-_!@#%^&*(),.?":{}|<>]+$');

  return regex.hasMatch(value);
}

bool isValidNumberFormat(String value) {
  final regex = RegExp(r'^\d+(\.\d+)?$');

  return regex.hasMatch(value);
}

///--------------------------------->>>>>>>>>>>>>>>>>>>>>>>>>
// String? validateSocialUrl(String? value, String platform) {
//   if (value == null || value.isEmpty) {
//     return null;
//   }
//
//   RegExp regex;
//
//   switch (platform.toLowerCase()) {
//     case "facebook":
//       regex = RegExp(r'^(https?:\/\/)?(www\.)?facebook\.com\/[A-Za-z0-9\.]{1,}$');
//       break;
//
//     case "instagram":
//       regex = RegExp(r'^(https?:\/\/)?(www\.)?instagram\.com\/[A-Za-z0-9._]{1,}$');
//       break;
//
//     case "twitter":
//     case "x":
//       regex = RegExp(r'^(https?:\/\/)?(www\.)?(twitter|x)\.com\/[A-Za-z0-9_]{1,}$');
//       break;
//
//     case "youtube":
//       regex = RegExp(
//         r'^(https?:\/\/)?(www\.)?(youtube\.com\/(c\/|channel\/|user\/|@)?[A-Za-z0-9_-]+|youtu\.be\/[A-Za-z0-9_-]+)$',
//       );
//       break;
//
//     default:
//       return "Invalid URL";
//   }
//
//   if (!regex.hasMatch(value)) {
//     return "Enter a valid $platform link";
//   }
//
//   return null;
// }

String? validateSocialUrl(String? value, String platform) {
  if (value == null || value.trim().isEmpty) {
    return null;
  }

  final url = value.trim().toLowerCase();

  switch (platform.toLowerCase()) {

    case "facebook":
      if (!url.startsWith("https://www.facebook.com")) {
        return "Enter valid Facebook link: (https://www.facebook.com...)";
      }
      break;

    case "instagram":
      if (!url.startsWith("https://www.instagram.com")) {
        return "Enter valid Instagram link: (https://www.instagram.com...)";
      }
      break;

    case "twitter":
    case "x":
      if (!(url.startsWith("https://www.twitter.com") ||
          url.startsWith("https://www.x.com"))) {
        return "Enter valid X/Twitter link";
      }
      break;

    case "youtube":
      if (!url.startsWith("https://www.youtube.com")) {
        return "Enter valid YouTube link: (https://www.youtube.com..)";
      }
      break;

    default:
      return null;
  }

  return null;
}