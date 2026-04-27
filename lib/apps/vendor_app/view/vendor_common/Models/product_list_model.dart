class ProductListModel {
  bool? status;
  String? productCount;
  String? productStockLowCount;
  String? productActiveCount;
  String? productInactiveCount;
  List<ProductListFromModel>? productActiveList;
  List<ProductListFromModel>? productInactiveList;
  List<ProductListFromModel>? allProductsList;
  List<ProductListFromModel>? stockRunningLowList;

  ProductListModel(
      {this.status,
        this.productCount,
        this.productStockLowCount,
        this.productActiveCount,
        this.productInactiveCount,
        this.productActiveList,
        this.productInactiveList,
        this.allProductsList,
        this.stockRunningLowList,
      });

  ProductListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    productCount = json['product_count']?.toString();
    productStockLowCount = json['product_stock_low_count']?.toString();
    productActiveCount = json['product_active_count']?.toString();
    productInactiveCount = json['product_inactive_count']?.toString();
    if (json['product_active_list'] != null) {
      productActiveList = <ProductListFromModel>[];
      json['product_active_list'].forEach((v) {
        productActiveList!.add(ProductListFromModel.fromJson(v));
      });
    }
    if (json['product_stock_low_list'] != null) {
      stockRunningLowList = <ProductListFromModel>[];
      json['product_stock_low_list'].forEach((v) {
        stockRunningLowList!.add(ProductListFromModel.fromJson(v));
      });
    }
    if (json['all_products'] != null) {
      allProductsList = <ProductListFromModel>[];
      json['all_products'].forEach((v) {
        allProductsList!.add(ProductListFromModel.fromJson(v));
      });
    }
    if (json['product_inactive_list'] != null) {
      productInactiveList = <ProductListFromModel>[];
      json['product_inactive_list'].forEach((v) {
        productInactiveList!.add(ProductListFromModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['product_count'] = productCount;
    data['product_stock_low_count'] = productStockLowCount;
    data['product_active_count'] = productActiveCount;
    data['product_inactive_count'] = productInactiveCount;
    if (productActiveList != null) {
      data['product_active_list'] =
          productActiveList!.map((v) => v.toJson()).toList();
    }
    if (productInactiveList != null) {
      data['product_inactive_list'] =
          productInactiveList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductListFromModel {
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
  String? image;
  // List<Extra>? extra;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  // List<String>? urlAddimg;
  String? urlImage;
  // List<AddOnWithNames>? addOnWithNames;

  ProductListFromModel(
      {this.id,
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
        this.image,
        // this.extra,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        // this.urlAddimg,
        this.urlImage,
        // this.addOnWithNames
      });

  ProductListFromModel.fromJson(Map<String, dynamic> json) {
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
    image = json['image']?.toString();
    // if (json['extra'] != null) {
    //   extra = <Extra>[];
    //   json['extra'].forEach((v) {
    //     extra!.add(Extra.fromJson(v));
    //   });
    // }
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    deletedAt = json['deleted_at']?.toString();
    // urlAddimg = json['url_addimg'].cast<String>();
    urlImage = json['image_url']?.toString();
    // if (json['add_on_with_names'] != null) {
    //   addOnWithNames = <AddOnWithNames>[];
    //   json['add_on_with_names'].forEach((v) {
    //     addOnWithNames!.add(AddOnWithNames.fromJson(v));
    //   });
    // }
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
    data['image'] = image;
    // if (extra != null) {
    //   data['extra'] = extra!.map((v) => v.toJson()).toList();
    // }
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    // data['url_addimg'] = urlAddimg;
    data['image_url'] = urlImage;
    // if (addOnWithNames != null) {
    //   data['add_on_with_names'] =
    //       addOnWithNames!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Extra {
  String? titleid;
  List<Item>? item;
  String? title;

  Extra({this.titleid, this.item, this.title});

  Extra.fromJson(Map<String, dynamic> json) {
    titleid = json['titleid']?.toString();
    if (json['item'] != null) {
      item = <Item>[];
      json['item'].forEach((v) {
        item!.add(Item.fromJson(v));
      });
    }
    title = json['title']?.toString();
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

class AddOnWithNames {
  String? id;
  String? price;
  String? name;

  AddOnWithNames({this.id, this.price, this.name});

  AddOnWithNames.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    price = json['price']?.toString();
    name = json['name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['price'] = price;
    data['name'] = name;
    return data;
  }
}
