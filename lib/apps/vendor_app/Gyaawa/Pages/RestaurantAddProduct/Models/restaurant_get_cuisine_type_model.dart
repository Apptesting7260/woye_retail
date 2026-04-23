class RestaurantCuisineTypeModel {
  bool? status;
  List<Cuisine>? cuisine;
  List<Cuisine>? brand;
  List<Cuisine>? packaging;
  List<Application>? application;

  RestaurantCuisineTypeModel({this.status, this.cuisine,this.brand,this.packaging, this.application});

  RestaurantCuisineTypeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['cuisine'] != null) {
      cuisine = <Cuisine>[];
      json['cuisine'].forEach((v) {
        cuisine?.add(Cuisine.fromJson(v));
      });
    }
    if (json['brand'] != null) {
      brand = <Cuisine>[];
      json['brand'].forEach((v) {
        brand?.add(Cuisine.fromJson(v));
      });
    }
    if (json['packaging'] != null) {
      packaging = <Cuisine>[];
      json['packaging'].forEach((v) {
        packaging?.add(Cuisine.fromJson(v));
      });
    }
    if (json['application'] != null) {
      application = <Application>[];
      json['application'].forEach((v) {
        application!.add(new Application.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (cuisine != null) {
      data['cuisine'] = cuisine?.map((v) => v.toJson()).toList();
    }
    if (brand != null) {
      data['brand'] = brand?.map((v) => v.toJson()).toList();
    }
    if (packaging != null) {
      data['packaging'] = packaging?.map((v) => v.toJson()).toList();
    }
    if (application != null) {
      data['application'] = application!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Application {
  String? id;
  String? name;

  Application({this.id, this.name});

  Application.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['route_name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['route_name'] = name;
    return data;
  }
}

class Cuisine {
  String? id;
  String? name;

  Cuisine({this.id, this.name});

  Cuisine.fromJson(Map<String, dynamic> json) {
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
