class AllCategoryModel {
  bool? status;
  List<Products>? products;

  AllCategoryModel({this.status, this.products});

  AllCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['products'] != null && json['products'] is List) {
      products = <Products>[];
      for (var v in json['products']) {
        products!.add(Products.fromJson(v as Map<String, dynamic>));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String? id;
  String? title;
  String? slug;
  String? sku;
  String? userId;
  String? categoryId;
  String? regularPrice;
  String? salePrice;
  String? quanInStock;
  String? description;
  String? discount;
  String? cuisineType;
  String? rating;
  List<Extra>? extra;
  String? status;
  String? createdAt;
  String? urlImage;

  Products({
    this.id,
    this.title,
    this.slug,
    this.sku,
    this.userId,
    this.categoryId,
    this.regularPrice,
    this.salePrice,
    this.quanInStock,
    this.description,
    this.discount,
    this.cuisineType,
    this.rating,
    this.extra,
    this.status,
    this.createdAt,
    this.urlImage,
  });

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    title = json['title']?.toString();
    slug = json['slug']?.toString();
    sku = json['sku']?.toString();
    userId = json['user_id']?.toString();
    categoryId = json['category_id']?.toString();
    regularPrice = json['regular_price']?.toString();
    salePrice = json['sale_price']?.toString();
    quanInStock = json['quan_in_stock']?.toString();
    description = json['description']?.toString();
    discount = json['discount']?.toString();
    cuisineType = json['cuisine_type']?.toString();
    rating = json['rating']?.toString();

    if (json['extra'] != null && json['extra'] is List) {
      extra = <Extra>[];
      for (var v in json['extra']) {
        extra!.add(Extra.fromJson(v as Map<String, dynamic>));
      }
    }

    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
    urlImage = json['image_url']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['sku'] = sku;
    data['user_id'] = userId;
    data['category_id'] = categoryId;
    data['regular_price'] = regularPrice;
    data['sale_price'] = salePrice;
    data['quan_in_stock'] = quanInStock;
    data['description'] = description;
    data['discount'] = discount;
    data['cuisine_type'] = cuisineType;
    data['rating'] = rating;

    if (extra != null) {
      data['extra'] = extra!.map((v) => v.toJson()).toList();
    }

    data['status'] = status;
    data['created_at'] = createdAt;
    data['image_url'] = urlImage;

    return data;
  }
}

class Extra {
  String? titleid;
  List<Item>? item;
  String? title;

  Extra({this.titleid, this.item, this.title});

  Extra.fromJson(Map<String, dynamic> json) {
    titleid = json['titleid'];
    if (json['item'] != null && json['item'] is List) {
      item = <Item>[];
      for (var v in json['item']) {
        item!.add(Item.fromJson(v as Map<String, dynamic>));
      }
    }

    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['titleid'] = titleid;

    if (item != null) {
      data['item'] = item!.map((v) => v.toJson()).toList();
    }

    data['title'] = title;
    return data;
  }
}

class Item {
  String? id;
  String? name;
  String? price;

  Item({this.id, this.name, this.price});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    price = json['price']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    return data;
  }
}

