 import 'package:get/get_state_manager/get_state_manager.dart';

class ProfileController extends GetxController{

  List<Map<String, dynamic>> addresses = [
    {
      "label": "Home",
      "street": "123 Example Street",
      "city": "Accra, Greater Accra",
      "country": "Ghana",
      "isDefault": true,
    },
    {
      "label": "Office",
      "street": "456 Business Avenue",
      "city": "Kumasi, Ashanti Region",
      "country": "Ghana",
      "isDefault": false,
    },
    {
      "label": "Parent's House",
      "street": "789 Family Road",
      "city": "Takoradi, Western Region",
      "country": "Ghana",
      "isDefault": false,
    },
  ];
}