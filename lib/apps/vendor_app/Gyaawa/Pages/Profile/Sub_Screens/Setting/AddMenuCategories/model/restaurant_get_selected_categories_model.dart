class GetSelCategoryModel {
  bool? status;
  String? message;
  List<Categories>? categories;

  GetSelCategoryModel({this.status, this.message, this.categories});

  GetSelCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  String? id;
  String? name;
  String? imageUrl;
  String? productsCount;

  Categories({this.id, this.name, this.imageUrl, this.productsCount});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    imageUrl = json['image_url']?.toString();
    productsCount = json['products_count']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image_url'] = imageUrl;
    data['products_count'] = productsCount;
    return data;
  }
}
