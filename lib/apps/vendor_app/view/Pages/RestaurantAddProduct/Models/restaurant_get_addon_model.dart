class RestaurantGetAddOnModel {
  bool? status;
  List<Addons>? addons;

  RestaurantGetAddOnModel({this.status, this.addons});

  RestaurantGetAddOnModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['addons'] != null) {
      addons = <Addons>[];
      json['addons'].forEach((v) {
        addons!.add(Addons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (addons != null) {
      data['addons'] = addons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Addons {
  String? id;
  String? name;

  Addons({this.id, this.name});

  Addons.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
