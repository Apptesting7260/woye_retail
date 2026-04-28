class ChooseCategoriesModel {
  bool? status;
  List<Category>? category;

  ChooseCategoriesModel({this.status, this.category});

  ChooseCategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (category != null) {
      data['category'] = category!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? productsCount;
  String? image;
  String? parentCategory;
  String? userId;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;

  Category(
      {this.id,
        this.name,
        this.productsCount,
        this.image,
        this.parentCategory,
        this.userId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.imageUrl});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    productsCount = json['products_count'];
    image = json['image'];
    parentCategory = json['parent_category'];
    userId = json['user_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['products_count'] = productsCount;
    data['image'] = image;
    data['parent_category'] = parentCategory;
    data['user_id'] = userId;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image_url'] = imageUrl;
    return data;
  }
}
