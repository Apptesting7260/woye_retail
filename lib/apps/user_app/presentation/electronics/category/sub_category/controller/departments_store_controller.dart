import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DepartmentsStoreController extends GetxController {


  final List<Map<String, dynamic>> popularPicks = [
    {"title": "Shop iPhones", "tag": "Hot", },
    {"title": "Android Deals", "tag": "Sale", },
    {"title": "Gaming Laptops", "tag": "New", },
    {"title": "Smart TVs Under GHS 2,000"},
    {"title": "Power Banks"},
    {"title": "Top Rated Phones"},
    {"title": "Gaming Laptops", "tag": "New", },
    {"title": "Smart TVs Under GHS 2,000"},
    {"title": "Power Banks"},
    {"title": "Top Rated Phones"},
  ];

  final List<Map<String, dynamic>> subCategories = [
    {"title": "Phones & Tablets", "count": 18},
    {"title": "Computing", "count": 21},
    {"title": "TV & Audio", "count": 13},
    {"title": "Cameras & Accessories", "count": 10},
    {"title": "Gaming", "count": 8},
    {"title": "Smart Devices", "count": 8},
    {"title": "TV & Audio", "count": 13},
    {"title": "Cameras & Accessories", "count": 10},
    {"title": "Gaming", "count": 8},
    {"title": "Smart Devices", "count": 8},
  ];
}