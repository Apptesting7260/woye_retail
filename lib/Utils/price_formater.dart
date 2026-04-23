import 'package:intl/intl.dart';

String priceFormatterDouble(double? amount) {
  final formatter = NumberFormat('#,##0.0', 'en_US');
  return formatter.format(amount ?? 0);
}

String formatPoints(String input) {
  return input.replaceAllMapped(RegExp(r'(\d+)(\.\d+)? points'), (match) {
    return '${match[1]} points';
  });
}