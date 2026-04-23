import 'package:get/get.dart';

class ShippingPaymentController extends GetxController {
  var selectedShipping = "Standard Shipping (3-5 days)".obs;
  var selectedPayment = 3.obs;

  final List<Map<String, String>> shippingMethods = [
    {"title": "Standard Shipping (3-5 days)", "subtitle": "Included"},
    {"title": "Express Shipping (2-3 days)", "subtitle": "+GHS 25.00"},
    {"title": "Overnight Shipping (1 day)", "subtitle": "+GHS 70.00"},
  ];

  final List<String> paymentTitles = [
    "My Wallet (\$400)",
    "MTN  +34 •• 321",
    "Cash on Delivery",
    "•••• •••• •••• 8888",
  ];

}