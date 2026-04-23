import 'package:get/get.dart';

class SelectDeliveryAddressController extends GetxController {
  RxInt selectedAddress = 0.obs;
  RxInt selectedPickup = 0.obs;
  RxInt selectedIndex = 0.obs;

  final List<PickupModel> pickupList = [
    PickupModel(
      title: "Achimota Pickup Station",
      address: "D 888 Abc Road, Greenfield, Abc\nManchester, 199",
      phone: "+791 12 123 1234",
    ), PickupModel(
      title: "Achimota Pickup Station",
      address: "D 888 Abc Road, Greenfield, Abc\nManchester, 199",
      phone: "+791 12 123 1234",
    ), PickupModel(
      title: "Achimota Pickup Station",
      address: "D 888 Abc Road, Greenfield, Abc\nManchester, 199",
      phone: "+791 12 123 1234",
    ),
    PickupModel(
      title: "Kumasi Pickup Station",
      address: "XYZ Road, Kumasi Center",
      phone: "+233 55 123 4567",
    ),
  ];
  final List<AddressModel> addressList = [
    AddressModel(
      type: "Home",
      name: "Jone Deo",
      address: "D 888 Abc Road, Greenfield, Abc\nManchester, 199",
      phone: "+791 12 123 1234",
      isDefault: true,
    ),
    AddressModel(
      type: "Office",
      name: "Jone Deo",
      address: "D 888 Abc Road, Greenfield, Abc\nManchester, 199",
      phone: "+791 12 123 1234",
    ),  AddressModel(
      type: "Office",
      name: "Jone Deo",
      address: "D 888 Abc Road, Greenfield, Abc\nManchester, 199",
      phone: "+791 12 123 1234",
    ),  AddressModel(
      type: "Office",
      name: "Jone Deo",
      address: "D 888 Abc Road, Greenfield, Abc\nManchester, 199",
      phone: "+791 12 123 1234",
    ),
  ];
}
class PickupModel {
  final String title;
  final String address;
  final String phone;

  PickupModel({
    required this.title,
    required this.address,
    required this.phone,
  });
}
class AddressModel {
  final String type;
  final String name;
  final String address;
  final String phone;
  final bool isDefault;

  AddressModel({
    required this.type,
    required this.name,
    required this.address,
    required this.phone,
    this.isDefault = false,
  });
}