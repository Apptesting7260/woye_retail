class CommonAddProductModel {
  bool? status;
  String? message;
  String? error;
  List<String>? errors;
  ProductAdd? product;

  CommonAddProductModel({this.status, this.message, this.errors, this.product});

  CommonAddProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
    error = json['error']?.toString();
    if (json['errors'] != null && json['errors'] is List) {
      errors = List<String>.from(json['errors']);
    } else {
      errors = [];
    }
    product =
    json['product'] != null ? ProductAdd.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['errors'] = errors;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

class ProductAdd {
  String? id;
  String? title;
  String? description;
  String? categoryId;
  String? categoryName;
  String? status;
  String? imageUrl;

  ProductAdd(
      {this.id,
        this.title,
        this.description,
        this.categoryId,
        this.categoryName,
        this.status,
        this.imageUrl});

  ProductAdd.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    title = json['title']?.toString();
    description = json['description']?.toString();
    categoryId = json['category_id']?.toString();
    categoryName = json['category_name']?.toString();
    status = json['status']?.toString();
    imageUrl = json['image_url']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['status'] = status;
    data['image_url'] = imageUrl;
    return data;
  }
}