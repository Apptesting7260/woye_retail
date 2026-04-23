import 'package:get/get.dart';

class WishlistController extends GetxController {
  var selectedCategory = "All".obs;

  final categories = ["All", "Electronics", "Fashion"].obs;

  final products = [
    {
      "category": "Electronics",
      "image": "https://via.placeholder.com/150",
      "title": "Gaming Laptop",
      "subtitle": "High Performance",
      "price": "₹59999",
      "oldPrice": "₹79999",
      "discount": "25% OFF",
    },
    {
      "category": "Fashion",
      "image": "https://via.placeholder.com/150",
      "title": "T-Shirt",
      "subtitle": "Cotton Wear",
      "price": "₹499",
      "oldPrice": "₹999",
      "discount": "50% OFF",
    },
  ];

  List<Map<String, dynamic>> get filteredProducts {
    if (selectedCategory.value == "All") return products;

    return products
        .where((e) => e["category"] == selectedCategory.value)
        .toList();
  }
}