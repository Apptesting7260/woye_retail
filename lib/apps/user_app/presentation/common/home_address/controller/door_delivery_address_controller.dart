import 'package:get/get.dart';

class DoorDeliveryAddressController extends GetxController {
  RxString selectedAddressType = "Home".obs;
  RxBool isDefault = false.obs;

  List<DummyItem> stateList = [
    DummyItem(id: "1", name: "Rajasthan"),
    DummyItem(id: "2", name: "Gujarat"),
    DummyItem(id: "3", name: "Maharashtra"),
  ];
}
class DummyItem {
  final String id;
  final String name;

  DummyItem({required this.id, required this.name});
}