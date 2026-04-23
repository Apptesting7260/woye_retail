class MenuModel {
  bool? status;
  String? message;
  Summary? summary;
  List<Products>? products;
  List<Categories>? categories;
  List<Cuisines>? cuisines;
  List<ProductAttributes>? productAttributes;
  List<Brand>? brand;
  List<Packaging>? packaging;
  List<Application>? application;
  Pagination? pagination;

  MenuModel({
    this.status,
    this.message,
    this.summary,
    this.products,
    this.categories,
    this.cuisines,
    this.productAttributes,
    this.brand,
    this.packaging,
    this.application,
    this.pagination,
  });

  MenuModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];

    summary =
    json['summary'] != null ? Summary.fromJson(json['summary']) : null;

    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;

    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }

    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }

    if (json['cuisines'] != null) {
      cuisines = <Cuisines>[];
      json['cuisines'].forEach((v) {
        cuisines!.add(Cuisines.fromJson(v));
      });
    }

    if (json['product_attributes'] != null) {
      productAttributes = <ProductAttributes>[];
      json['product_attributes'].forEach((v) {
        productAttributes!.add(ProductAttributes.fromJson(v));
      });
    }

    if (json['brand'] != null) {
      brand = <Brand>[];
      json['brand'].forEach((v) {
        brand!.add(Brand.fromJson(v));
      });
    }

    if (json['packaging'] != null) {
      packaging = <Packaging>[];
      json['packaging'].forEach((v) {
        packaging!.add(Packaging.fromJson(v));
      });
    }

    if (json['application'] != null) {
      application = <Application>[];
      json['application'].forEach((v) {
        application!.add(Application.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;

    if (summary != null) {
      data['summary'] = summary!.toJson();
    }

    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }

    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (cuisines != null) {
      data['cuisines'] = cuisines!.map((v) => v.toJson()).toList();
    }
    if (productAttributes != null) {
      data['product_attributes'] =
          productAttributes!.map((v) => v.toJson()).toList();
    }
    if (brand != null) {
      data['brand'] = brand!.map((v) => v.toJson()).toList();
    }
    if (packaging != null) {
      data['packaging'] = packaging!.map((v) => v.toJson()).toList();
    }
    if (application != null) {
      data['application'] =
          application!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Summary {
  String? totalProduct;
  String? availableItems;
  String? seasonalLimited;
  String? totalOrders;
  String? averageRating;
  //grocery
  String? inStock;
  String? lowStock;
  String? organicProducts;
  String? prescription;

  Summary(
      {this.totalProduct,
        this.availableItems,
        this.seasonalLimited,
        this.totalOrders,
        this.averageRating,
        this.inStock,
        this.lowStock,
        this.organicProducts,
        this.prescription,
      });

  Summary.fromJson(Map<String, dynamic> json) {
    totalProduct = json['total_product']?.toString();
    availableItems = json['available_items']?.toString();
    seasonalLimited = json['seasonal_limited']?.toString();
    totalOrders = json['total_orders']?.toString();
    averageRating = json['average_rating']?.toString();
    inStock = json['in_stock']?.toString();
    lowStock = json['low_stock']?.toString();
    organicProducts = json['organic_products']?.toString();
    prescription = json['prescription']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_product'] = totalProduct;
    data['available_items'] = availableItems;
    data['seasonal_limited'] = seasonalLimited;
    data['total_orders'] = totalOrders;
    data['average_rating'] = averageRating;
    data['in_stock'] = inStock;
    data['low_stock'] = lowStock;
    data['organic_products'] = organicProducts;
    return data;
  }
}

class Products {
  String? id;
  String? title;
  String? slug;
  String? sku;
  String? description;
  String? image;
  String? vendorId;
  String? categoryId;
  String? cuisineId;
  String? brandId;
  String? packagingId;
  String? applicationId;
  String? ndcNumber;
  String? strength;
  String? department;
  String? shelfLifeType;
  String? shelfLifeValue;
  String? menuSection;
  String? regularPrice;
  String? salePrice;
  String? discount;
  String? quantityInStock;
  String? prescription;
  String? preparationTime;
  String? rating;
  String? type;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? imageUrl;
  String? categoryName;

  Products(
      {this.id,
        this.title,
        this.slug,
        this.sku,
        this.description,
        this.image,
        this.vendorId,
        this.categoryId,
        this.cuisineId,
        this.brandId,
        this.packagingId,
        this.applicationId,
        this.ndcNumber,
        this.strength,
        this.department,
        this.shelfLifeType,
        this.shelfLifeValue,
        this.menuSection,
        this.regularPrice,
        this.salePrice,
        this.discount,
        this.quantityInStock,
        this.prescription,
        this.preparationTime,
        this.rating,
        this.type,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.categoryName,
        this.imageUrl});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    title = json['title']?.toString();
    slug = json['slug']?.toString();
    sku = json['sku']?.toString();
    description = json['description']?.toString();
    image = json['image']?.toString();
    vendorId = json['vendor_id']?.toString();
    categoryId = json['category_id']?.toString();
    cuisineId = json['cuisine_id']?.toString();
    brandId = json['brand_id']?.toString();
    packagingId = json['packaging_id']?.toString();
    applicationId = json['application_id']?.toString();
    ndcNumber = json['ndc_number']?.toString();
    strength = json['strength']?.toString();
    department = json['department']?.toString();
    shelfLifeType = json['shelf_life_type']?.toString();
    shelfLifeValue = json['shelf_life_value']?.toString();
    menuSection = json['menu_section']?.toString();
    regularPrice = json['regular_price']?.toString();
    salePrice = json['sale_price']?.toString();
    discount = json['discount']?.toString();
    quantityInStock = json['quantity_in_stock']?.toString();
    prescription = json['prescription']?.toString();
    preparationTime = json['preparation_time']?.toString();
    rating = json['rating']?.toString();
    type = json['type']?.toString();
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    deletedAt = json['deleted_at']?.toString();
    imageUrl = json['image_url']?.toString();
    categoryName = json['category_name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['sku'] = sku;
    data['description'] = description;
    data['image'] = image;
    data['vendor_id'] = vendorId;
    data['category_id'] = categoryId;
    data['cuisine_id'] = cuisineId;
    data['brand_id'] = brandId;
    data['packaging_id'] = packagingId;
    data['application_id'] = applicationId;
    data['ndc_number'] = ndcNumber;
    data['strength'] = strength;
    data['department'] = department;
    data['shelf_life_type'] = shelfLifeType;
    data['shelf_life_value'] = shelfLifeValue;
    data['menu_section'] = menuSection;
    data['regular_price'] = regularPrice;
    data['sale_price'] = salePrice;
    data['discount'] = discount;
    data['quantity_in_stock'] = quantityInStock;
    data['prescription'] = prescription;
    data['preparation_time'] = preparationTime;
    data['rating'] = rating;
    data['type'] = type;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['image_url'] = imageUrl;
    data['category_name'] = categoryName;
    return data;
  }

  Products copyWith({
    String? title,
    String? description,
    String? imageUrl,
    String? categoryId,
    String? categoryName,
    String? status,
    String? rating,
  }) {
    return Products(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      // slug: slug,
      // sku: sku,
      // image: image,
      // vendorId: vendorId,
      // cuisineId: cuisineId,
      // brandId: brandId,
      // packagingId: packagingId,
      // applicationId: applicationId,
      // ndcNumber: ndcNumber,
      // strength: strength,
      // department: department,
      // shelfLifeType: shelfLifeType,
      // shelfLifeValue: shelfLifeValue,
      // menuSection: menuSection,
      // regularPrice: regularPrice,
      // salePrice: salePrice,
      // discount: discount,
      // quantityInStock: quantityInStock,
      // prescription: prescription,
      // preparationTime: preparationTime,
      // rating: rating,
      // type: type,
      // createdAt: createdAt,
      // updatedAt: updatedAt,
      // deletedAt: deletedAt,
      // categoryName: categoryName,
    );
  }
}



class Categories {
  String? name;
  String? id;
  String? imageUrl;
  String? productsCount;

  Categories({this.name, this.id, this.imageUrl, this.productsCount});

  Categories.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
    id = json['id']?.toString();
    imageUrl = json['image_url']?.toString();
    productsCount = json['products_count']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['image_url'] = imageUrl;
    data['products_count'] = productsCount;
    return data;
  }
}

class Cuisines {
  String? name;
  String? id;

  Cuisines({this.name, this.id});

  Cuisines.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
    id = json['id']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}

class ProductAttributes {
  String? groupName;
  List<Items>? items;

  ProductAttributes({this.groupName, this.items});

  ProductAttributes.fromJson(Map<String, dynamic> json) {
    groupName = json['group_name']?.toString();
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['group_name'] = groupName;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? id;
  String? name;

  Items({this.id, this.name});

  Items.fromJson(Map<String, dynamic> json) {
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
class Brand {
  String? id;
  String? name;
  String? manufacturer;
  String? country;
  String? established;
  String? category;
  String? description;
  String? type;
  String? status;
  String? createdAt;
  String? updatedAt;

  Brand(
      {this.id,
        this.name,
        this.manufacturer,
        this.country,
        this.established,
        this.category,
        this.description,
        this.type,
        this.status,
        this.createdAt,
        this.updatedAt});

  Brand.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    manufacturer = json['manufacturer']?.toString();
    country = json['country']?.toString();
    established = json['established']?.toString();
    category = json['category']?.toString();
    description = json['description']?.toString();
    type = json['type']?.toString();
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['manufacturer'] = manufacturer;
    data['country'] = country;
    data['established'] = established;
    data['category'] = category;
    data['description'] = description;
    data['type'] = type;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}


class Pagination {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;
  int? from;
  int? to;

  Pagination({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
    this.from,
    this.to,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'] != null ? int.tryParse(json['current_page'].toString()) : 1;
    lastPage = json['last_page'] != null ? int.tryParse(json['last_page'].toString()) : 1;
    perPage = json['per_page'] != null ? int.tryParse(json['per_page'].toString()) : 10;
    total = json['total'] != null ? int.tryParse(json['total'].toString()) : 0;
    from = json['from'] != null ? int.tryParse(json['from'].toString()) : 0;
    to = json['to'] != null ? int.tryParse(json['to'].toString()) : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    data['per_page'] = perPage;
    data['total'] = total;
    data['from'] = from;
    data['to'] = to;
    return data;
  }
}

class Application {
  String? id;
  String? routeName;

  Application({
    this.id,
    this.routeName,
  });

  Application.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    routeName = json['route_name']?.toString();
  }

  /// ✅ ADD THIS GETTER
  String get name => routeName ?? '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['route_name'] = routeName;
    return data;
  }
}


class Packaging {
  String? id;
  String? name;
  String? category;
  String? description;
  String? longDescription;
  String? icon;
  String? symbol;
  String? type;
  String? status;
  String? createdAt;
  String? updatedAt;

  Packaging(
      {this.id,
        this.name,
        this.category,
        this.description,
        this.longDescription,
        this.icon,
        this.symbol,
        this.type,
        this.status,
        this.createdAt,
        this.updatedAt});

  Packaging.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    category = json['category']?.toString();
    description = json['description']?.toString();
    longDescription = json['long_description']?.toString();
    icon = json['icon']?.toString();
    symbol = json['symbol']?.toString();
    type = json['type']?.toString();
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['category'] = category;
    data['description'] = description;
    data['long_description'] = longDescription;
    data['icon'] = icon;
    data['symbol'] = symbol;
    data['type'] = type;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }



}
