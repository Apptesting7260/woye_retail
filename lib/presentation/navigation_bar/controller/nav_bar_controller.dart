
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class NavigationController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  final List<Map<String, dynamic>> navItems = [
    {'icon': Icons.home_outlined, 'activeIcon': Icons.home_outlined, 'label': 'Home'},
    {'icon': Icons.search, 'activeIcon': Icons.search, 'label': 'Search'},
    {'icon': Icons.shopping_cart_outlined, 'activeIcon': Icons.shopping_cart_outlined, 'label': 'Cart'},
    {'icon': Icons.favorite_outline, 'activeIcon': Icons.favorite, 'label': 'Wishlist'},
    {'icon': Icons.person_2_outlined, 'activeIcon': Icons.person_2_outlined, 'label': 'Account'},
  ];

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}