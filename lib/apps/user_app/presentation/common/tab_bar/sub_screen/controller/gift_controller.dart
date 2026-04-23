import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
class GiftController extends GetxController {
  RxInt  selectedIndex = 0.obs;
  String selectedCategory = "All Gifts";
  String selectedPrice = "All Prices";

  final List<Map<String, dynamic>> categories = [
    {
      "title": "All Gifts",
      "subtitle": "Perfect for any occasion",
      "icon": Icons.card_giftcard_outlined,
    },
    {
      "title": "For Her",
      "subtitle": "Beauty, fashion & lifestyle",
      "icon": Icons.auto_awesome_outlined,
    },
    {
      "title": "For Him",
      "subtitle": "Tech, sports & accessories",
      "icon": Icons.people_outline,
    },
    {
      "title": "For Home",
      "subtitle": "Decor & living essentials",
      "icon": Icons.favorite_border,
    },
  ];

}