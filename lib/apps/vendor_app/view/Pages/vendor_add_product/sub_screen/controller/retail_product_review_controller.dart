import 'package:get/get.dart';

class RetailProductReviewController extends GetxController {
  final List<Map<String, String>> variants = List.generate(
    9,
        (index) => {
      'color': 'Space Gray',
      'storage': '64GB',
      'ram': '4GB',
      'price': 'GHC 12,000',
      'stock': 'Stock: 47',
    },
  );

}