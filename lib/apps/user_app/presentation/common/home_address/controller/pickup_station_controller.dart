import 'package:get/get.dart';

class PickupStationController extends GetxController {
  final RxInt selectedIndex = 1.obs;

  final List<Map<String, dynamic>> stationList = [
    {
      "title": "Achimota Mall Pickup Station",
      "address": "D 888 Abc Road, Greenfield, Abc",
      "distance": "0.3km . Mon-Sat 8:00-5:00pm",
      "type": "Prepaid & COD",
    },
    {
      "title": "Dome Pillar 2 Locker",
      "address": "D 888 Abc Road, Greenfield, Abc",
      "distance": "0.3km . 24/7",
      "type": "Prepaid orders only",
    },
    {
      "title": "GIMPA Pickup Station",
      "address": "D 888 Abc Road, Greenfield, Abc",
      "distance": "0.3km . Mon-Sat 8:00-5:00pm",
      "type": "Prepaid & COD",
    },
  ];
}