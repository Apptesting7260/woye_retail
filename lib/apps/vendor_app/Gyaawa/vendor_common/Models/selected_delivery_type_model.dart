
class SelectedDeliveryDropdownItem{
  final String name;
  final String id;

  SelectedDeliveryDropdownItem({required this.name, required this.id});
}
final statusItems = [
  SelectedDeliveryDropdownItem(name: "Free", id: "1"),
  SelectedDeliveryDropdownItem(name: "Not Free", id: "0"),
];

final selectedDeliveryItems = [
  SelectedDeliveryDropdownItem(name: "Not Free Delivery",id: "0"),
  SelectedDeliveryDropdownItem(name: "Free Delivery",id: "1"),
  // SelectedDeliveryDropdownItem(name: "Pre-Order Delivery",id: "2"),

];