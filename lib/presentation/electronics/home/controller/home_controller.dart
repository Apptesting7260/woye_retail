import 'dart:async';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {

  var currentSliderIndex = 0.obs;
  var hours = 23.obs;
  var minutes = 45.obs;
  var seconds = 12.obs;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    ever(seconds, (_) {});
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds.value > 0) {
        seconds.value--;
      } else if (minutes.value > 0) {
        minutes.value--;
        seconds.value = 59;
      } else if (hours.value > 0) {
        hours.value--;
        minutes.value = 59;
        seconds.value = 59;
      } else {
        timer.cancel();
      }
    });
  }

  final List<Map<String, dynamic>> flashSaleProducts = [
    {
      "image":"https://images.unsplash.com/photo-1516826957135-700dedea698c",
      "brand": "TechCorp",
      "name": "Premium Wireless Laptop - 15 inch Display, 16GB RAM, 512GB SSD",
      "rating": "4.8",
      "reviews": "324",
      "price": "GHS 3899.99",
      "originalPrice": "GHS 4599.99",
      "discount": "-15%",
    },
    {
      "image":"https://images.unsplash.com/photo-1516826957135-700dedea698c",
      "brand": "Audi",
      "name": "Professional Camera with Accessories",
      "rating": "4.5",
      "reviews": "210",
      "price": "GHS 2999.99",
      "originalPrice": "GHS 3599.99",
      "discount": "-15%",
    },
  ];
  final List<Map<String, dynamic>> dummyData = [
    {
     "image":"https://images.unsplash.com/photo-1516826957135-700dedea698c",
      "title": "Christmas Fashion",
      "subtitle": "Holiday Outfits",
      "desc": "Look festive and stylish with Christmas sweaters, party dresses, and holiday accessories",
      "tags": ["Christmas Sweaters", "Party Dresses", "Holiday Accessories", "Festive Ties"],
      "buttonText": "Shop Christmas Fashion",
    },
    {
      "image":"https://images.unsplash.com/photo-1516826957135-700dedea698c",
      "title": "Winter Sale",
      "subtitle": "New Arrivals",
      "desc": "Stay warm with premium winter collection",
      "tags": ["Jackets", "Hoodies", "Coats", "Thermals"],
      "buttonText": "Shop Winter Sale",
    }
  ];
  List<Map<String, String>> dummyCategories = [
    {"name": "Electronics", "image": "assets/images/electronics.png"},
    {"name": "Fashion", "image": "assets/images/fashion.png"},
    {"name": "Home & Garden", "image": "assets/images/electronics.png"},
    {"name": "Home & Garden", "image": "assets/images/fashion.png"},
    {"name": "Home & Garden", "image": "assets/images/home.png"},
    {"name": "Home & Garden", "image": "assets/images/fashion.png"},
    {"name": "Home & Garden", "image": "assets/images/electronics.png"},
  ];
  final List<Map<String, String>> items = [
    {"title": "Wireless Headphones", "percent": "+13%"},
    {"title": "Smart Watch", "percent": "+22%"},
    {"title": "Yoga Mat", "percent": "+30%"},
    {"title": "Coffee Maker", "percent": "+11%"},
    {"title": "Gaming Chair", "percent": "+20%"},
    {"title": "Running Shoes", "percent": "+39%"},
    {"title": "Smartphone Cases", "percent": "+32%"},
    {"title": "Laptop Stand", "percent": "+32%"},
    {"title": "Air Purifier", "percent": "+19%"},
    {"title": "Bluetooth Speaker", "percent": "+37%"},
  ];
  final List<Map<String, dynamic>> products = [
    {
      "image":"https://images.unsplash.com/photo-1516826957135-700dedea698c",
      "brand": "TechCorp",
      "name": "Premium Wireless Laptop - 15 inch",
      "price": "GHS 3899.99",
      "originalPrice": "4599.99",
      "rating": "4.8",
      "reviews": "324",
      "discount": "-15%",
      "isNew": true,
      "isBest": true,
    },
    {
      "image":"https://images.unsplash.com/photo-1516826957135-700dedea698c",
      "brand": "AudioMax",
      "name": "Professional Wireless Headphones - Noise",
      "price": "GHS 1099.99",
      "originalPrice": "1299.99",
      "rating": "4.8",
      "reviews": "892",
      "discount": "",
      "isNew": true,
      "isBest": true,
    },
    {
      "image":"https://images.unsplash.com/photo-1516826957135-700dedea698c",
      "brand": "MobileTech",
      "name": "Latest Smartphone - Large OLED Display",
      "price": "GHS 2999.99",
      "originalPrice": "",
      "rating": "4.7",
      "reviews": "155",
      "discount": "",
      "isNew": true,
      "isBest": true
      ,
    },
    {
      "image":"https://images.unsplash.com/photo-1516826957135-700dedea698c",
      "brand": "StyleHub",
      "name": "Casual Summer Dress - Floral Print",
      "price": "GHS 199.99",
      "originalPrice": "249.99",
      "rating": "4.4",
      "reviews": "178",
      "discount": "-39%",
      "isNew": true,
      "isBest": true,
    },
  ];
  final List<Map<String, dynamic>> productList = List.generate(4, (index) {
    return {
      "brandName": "TechCorp $index",
      "description": "Leading technology retailer specializing in cutting-edge electronics and innovative gadgets",
      "category": "Electronics & Tech Gadgets",
      "rating": 4.5 + (index * 0.1),
      "reviews": 1200 + (index * 50),
      "products": 1000 + (index * 100),
      "yearsActive": 5 + index,
      "topTag": index % 2 == 0 ? "Top Seller" : "New",
      "bannerImageUrl": "https://picsum.photos/300/120?random=$index",
      "logoImageUrl": "https://picsum.photos/300/120?random=$index",
      "popularProducts": [
        {"title": "Wireless", "image": "https://picsum.photos/80?random=1$index"},
        {"title": "Smart Watches", "image": "https://picsum.photos/80?random=2$index"},
        {"title": "Laptops & Tablets", "image": "https://picsum.photos/80?random=3$index"},
      ],
      "badges": ["Best Tech Vendor 2024", "98.8% Positive Feedback", "+1 more"],
    };
  });
}