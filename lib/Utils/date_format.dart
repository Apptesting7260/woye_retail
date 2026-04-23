import 'package:intl/intl.dart';

class FormatDate {
  //>>>date format
  static String formatDateString(String inputDate) {
    DateTime parsedDate = DateTime.parse(inputDate);
    String formattedDate = DateFormat('EEE, dd MMM - hh:mm a').format(parsedDate);
    return formattedDate;
  }

  static String ddMMYyyy(String inputDate) {
    DateTime parsedDate = DateTime.parse(inputDate);
    String formattedDate = DateFormat('dd MMM yyyy').format(parsedDate);
    return formattedDate;
  }

  // 12/11/2025

  static String formatDate(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();
    return "$day/$month/$year";
  }


  // yyyy-MM-dd ( 2025-11-22)output --- input 22/11/2025
  static String convertToApiFormat(String date) {
    DateTime parsed = DateFormat('dd/MM/yyyy').parse(date);
    return DateFormat('yyyy-MM-dd').format(parsed);
  }

  // Jan 12, 2034
  static String convertIsoToFormatted(String date) {
    DateTime parsed = DateTime.parse(date);
    return DateFormat('MMM dd, yyyy').format(parsed);
  }


}