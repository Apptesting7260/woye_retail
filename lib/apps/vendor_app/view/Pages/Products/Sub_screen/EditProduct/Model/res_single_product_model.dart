class ResSingleProductModel {
  bool? status;
  String? message;
  Product? product;
  List<ProductAttributeItem>? getProductAttributesList;
  List<ProductVariantItem>? getProductVariantsList;

  ResSingleProductModel({
    this.status,
    this.message,
    this.product,
    this.getProductAttributesList,
    this.getProductVariantsList,
  });

  ResSingleProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
    product = json['details'] != null ? Product.fromJson(json['details']) : null;

    if (json['get_product_attributes_list'] != null) {
      getProductAttributesList = <ProductAttributeItem>[];
      json['get_product_attributes_list'].forEach((v) {
        getProductAttributesList!.add(ProductAttributeItem.fromJson(v));
      });
    }

    if (json['getProductVariantsList'] != null) {
      getProductVariantsList = <ProductVariantItem>[];
      json['getProductVariantsList'].forEach((v) {
        getProductVariantsList!.add(ProductVariantItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['message'] = message;
    if (product != null) data['details'] = product!.toJson();
    if (getProductAttributesList != null) {
      data['get_product_attributes_list'] =
          getProductAttributesList!.map((v) => v.toJson()).toList();
    }
    if (getProductVariantsList != null) {
      data['getProductVariantsList'] =
          getProductVariantsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// ─── Product (details) ────────────────────────────────────────────────────────

class Product {
  String? id;
  String? slug;
  String? title;
  String? description;
  String? regularPrice;
  String? sellerSku;
  String? image;
  List<String>? addimg;
  String? vendorId;
  String? department;
  String? category;
  String? subCategory;
  String? quantityInStock;
  String? stockUnit;
  String? promoPrice;
  String? barCode;
  String? conditions;
  String? packageDimension;
  String? weight;
  String? fullfillmentType;
  String? orderPreparationTime;
  String? rating;
  String? isRecommended;
  String? additionalDetails;
  String? hasVariant;
  String? type;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<String>? addimgUrl;
  String? imageUrl;
  String? departmentName;
  String? categoryName;
  String? subCategoryName;
  String? cuisineName;
  String? brandName;
  String? packagingName;
  String? applicationName;
  String? productPercentDiscount;
  String? productRealPrice;
  List<Variant>? variants;
  DepartmentDetail? departmentDetail;
  CategoryDetail? categoryDetail;
  SubCategoryDetail? subCategoryDetail;

  // kept for controller compatibility & other screens
  String? categoryId;
  String? salePrice;
  List<String>? productAttributes;
  String? productAttributeName;
  String? menuSection;
  String? preparationTime;
  String? updatedDate;
  String? allOrdersCount;
  String? totaProductRevenues;
  String? avgReviews;
  PerformanceStats? performanceStats;

  Product({
    this.id,
    this.slug,
    this.title,
    this.description,
    this.regularPrice,
    this.sellerSku,
    this.image,
    this.addimg,
    this.vendorId,
    this.department,
    this.category,
    this.subCategory,
    this.quantityInStock,
    this.stockUnit,
    this.promoPrice,
    this.barCode,
    this.conditions,
    this.packageDimension,
    this.weight,
    this.fullfillmentType,
    this.orderPreparationTime,
    this.rating,
    this.isRecommended,
    this.additionalDetails,
    this.hasVariant,
    this.type,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.addimgUrl,
    this.imageUrl,
    this.departmentName,
    this.categoryName,
    this.subCategoryName,
    this.cuisineName,
    this.brandName,
    this.packagingName,
    this.applicationName,
    this.productPercentDiscount,
    this.productRealPrice,
    this.variants,
    this.departmentDetail,
    this.categoryDetail,
    this.subCategoryDetail,
    this.categoryId,
    this.salePrice,
    this.productAttributes,
    this.productAttributeName,
    this.totaProductRevenues,
    this.menuSection,
    this.preparationTime,
    this.performanceStats,
    this.updatedDate,
    this.allOrdersCount,
    this.avgReviews,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    slug = json['slug']?.toString();
    title = json['title']?.toString();
    description = json['description']?.toString();
    regularPrice = json['regular_price']?.toString();
    sellerSku = json['seller_sku']?.toString();
    image = json['image']?.toString();

    if (json['addimg'] != null && json['addimg'] is List) {
      addimg = List<String>.from(json['addimg']);
    }

    updatedDate = json['updated_date']?.toString();
    vendorId = json['vendor_id']?.toString();
    department = json['department']?.toString();
    category = json['category']?.toString();
    subCategory = json['sub_category']?.toString();
    quantityInStock = (json['quantity_in_stock'] ?? json['quan_in_stock'] ?? json['stock'])?.toString();
    stockUnit = (json['stock_unit'] ?? json['unit'] ?? json['stockUnit'])?.toString();
    promoPrice = (json['promo_price'] ?? json['sale_price'])?.toString();
    barCode = json['bar_code']?.toString();
    conditions = (json['conditions'] ?? json['condition'])?.toString();
    packageDimension = json['package_dimension']?.toString();
    weight = json['weight']?.toString();
    fullfillmentType = json['fullfillment_type']?.toString();
    orderPreparationTime = (json['order_preparation_time'] ?? json['preparation_time'])?.toString();
    rating = json['rating']?.toString();
    isRecommended = json['is_recommended']?.toString();
    additionalDetails = json['additional_details']?.toString();
    hasVariant = json['has_variant']?.toString();
    type = json['type']?.toString();
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    deletedAt = json['deleted_at']?.toString();
    allOrdersCount = json['all_orders_count']?.toString();
    totaProductRevenues = json['total_product_revenues']?.toString();

    if (json['addimg_url'] != null) {
      addimgUrl = List<String>.from(json['addimg_url']);
    } else {
      addimgUrl = [];
    }

    imageUrl = json['image_url']?.toString();
    departmentName = json['department_name']?.toString();
    categoryName = json['category_name']?.toString();
    subCategoryName = json['sub_category_name']?.toString();
    cuisineName = json['cuisine_name']?.toString();
    brandName = json['brand_name']?.toString();
    packagingName = json['packaging_name']?.toString();
    applicationName = json['application_name']?.toString();
    productPercentDiscount = json['product_precent_discount']?.toString();
    productRealPrice = json['product_real_price']?.toString();
    avgReviews = json['avg_reviews']?.toString();

    if (json['variants'] != null) {
      variants = <Variant>[];
      json['variants'].forEach((v) {
        variants!.add(Variant.fromJson(v));
      });
    }

    departmentDetail = json['department_detail'] != null
        ? DepartmentDetail.fromJson(json['department_detail'])
        : null;
    categoryDetail = json['category_detail'] != null
        ? CategoryDetail.fromJson(json['category_detail'])
        : null;
    subCategoryDetail = json['sub_category_detail'] != null
        ? SubCategoryDetail.fromJson(json['sub_category_detail'])
        : null;

    // controller compatibility aliases
    categoryId = category;
    salePrice = promoPrice;
    productAttributes = [];
    productAttributeName = null;
    menuSection = orderPreparationTime; // alias
    preparationTime = orderPreparationTime;
    performanceStats = null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['slug'] = slug;
    data['title'] = title;
    data['description'] = description;
    data['regular_price'] = regularPrice;
    data['seller_sku'] = sellerSku;
    data['image'] = image;
    data['addimg'] = addimg;
    data['vendor_id'] = vendorId;
    data['updated_date'] = updatedDate;
    data['department'] = department;
    data['category'] = category;
    data['sub_category'] = subCategory;
    data['quantity_in_stock'] = quantityInStock;
    data['stock_unit'] = stockUnit;
    data['promo_price'] = promoPrice;
    data['bar_code'] = barCode;
    data['conditions'] = conditions;
    data['package_dimension'] = packageDimension;
    data['weight'] = weight;
    data['fullfillment_type'] = fullfillmentType;
    data['order_preparation_time'] = orderPreparationTime;
    data['total_product_revenues'] = totaProductRevenues;
    data['avg_reviews'] = avgReviews;
    data['all_orders_count'] = allOrdersCount;
    data['rating'] = rating;
    data['is_recommended'] = isRecommended;
    data['additional_details'] = additionalDetails;
    data['has_variant'] = hasVariant;
    data['type'] = type;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['addimg_url'] = addimgUrl;
    data['image_url'] = imageUrl;
    data['department_name'] = departmentName;
    data['category_name'] = categoryName;
    data['sub_category_name'] = subCategoryName;
    data['cuisine_name'] = cuisineName;
    data['brand_name'] = brandName;
    data['packaging_name'] = packagingName;
    data['application_name'] = applicationName;
    data['product_precent_discount'] = productPercentDiscount;
    data['product_real_price'] = productRealPrice;
    if (variants != null) {
      data['variants'] = variants!.map((v) => v.toJson()).toList();
    }
    if (departmentDetail != null) data['department_detail'] = departmentDetail!.toJson();
    if (categoryDetail != null) data['category_detail'] = categoryDetail!.toJson();
    if (subCategoryDetail != null) data['sub_category_detail'] = subCategoryDetail!.toJson();
    return data;
  }
}

// ─── Variant (inside details.variants) ───────────────────────────────────────

class Variant {
  String? id;
  String? productId;
  String? sku;
  String? price;
  String? stock;
  bool? isEnabled;
  String? createdAt;
  String? updatedAt;
  List<VariantAttribute>? attributes;

  Variant({
    this.id,
    this.productId,
    this.sku,
    this.price,
    this.stock,
    this.isEnabled,
    this.createdAt,
    this.updatedAt,
    this.attributes,
  });

  Variant.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    productId = json['product_id']?.toString();
    sku = json['sku']?.toString();
    price = json['price']?.toString();
    stock = json['stock']?.toString();
    isEnabled = json['is_enabled'] == true || json['is_enabled']?.toString() == '1';
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    if (json['attributes'] != null) {
      attributes = <VariantAttribute>[];
      json['attributes'].forEach((v) {
        attributes!.add(VariantAttribute.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['product_id'] = productId;
    data['sku'] = sku;
    data['price'] = price;
    data['stock'] = stock;
    data['is_enabled'] = isEnabled;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (attributes != null) {
      data['attributes'] = attributes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// ─── VariantAttribute (inside details.variants[].attributes) ─────────────────

class VariantAttribute {
  String? id;
  String? variantId;
  String? attributeId;
  String? attributeValue;
  String? createdAt;
  String? updatedAt;
  AttributeDetail? attribute; // nullable — only some have it

  VariantAttribute({
    this.id,
    this.variantId,
    this.attributeId,
    this.attributeValue,
    this.createdAt,
    this.updatedAt,
    this.attribute,
  });

  VariantAttribute.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    variantId = json['variant_id']?.toString();
    attributeId = json['attribute_id']?.toString();
    attributeValue = json['attribute_value']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    attribute = json['attribute'] != null
        ? AttributeDetail.fromJson(json['attribute'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'variant_id': variantId,
      'attribute_id': attributeId,
      'attribute_value': attributeValue,
      'created_at': createdAt,
      'updated_at': updatedAt,
      if (attribute != null) 'attribute': attribute!.toJson(),
    };
  }
}

// ─── AttributeDetail (inside VariantAttribute.attribute) ─────────────────────

class AttributeDetail {
  String? id;
  String? name;
  String? attrValues;
  String? isCommon;
  String? department;
  String? category;
  String? subCategory;
  String? status;
  String? isDeleted;
  String? createdAt;
  String? updatedAt;
  List<String>? separateAttrValues;

  AttributeDetail({
    this.id,
    this.name,
    this.attrValues,
    this.isCommon,
    this.department,
    this.category,
    this.subCategory,
    this.status,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.separateAttrValues,
  });

  AttributeDetail.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    attrValues = json['attr_values']?.toString();
    isCommon = json['is_common']?.toString();
    department = json['department']?.toString();
    category = json['category']?.toString();
    subCategory = json['sub_category']?.toString();
    status = json['status']?.toString();
    isDeleted = json['is_deleted']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    if (json['separate_attr_values'] != null) {
      separateAttrValues = List<String>.from(json['separate_attr_values']);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'attr_values': attrValues,
      'is_common': isCommon,
      'department': department,
      'category': category,
      'sub_category': subCategory,
      'status': status,
      'is_deleted': isDeleted,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'separate_attr_values': separateAttrValues,
    };
  }
}

// ─── DepartmentDetail ─────────────────────────────────────────────────────────

class DepartmentDetail {
  String? id;
  String? slug;
  String? name;
  String? description;
  String? image;
  String? status;
  String? isDeleted;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;

  DepartmentDetail({this.id, this.slug, this.name, this.description, this.image,
    this.status, this.isDeleted, this.createdAt, this.updatedAt, this.imageUrl});

  DepartmentDetail.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    slug = json['slug']?.toString();
    name = json['name']?.toString();
    description = json['description']?.toString();
    image = json['image']?.toString();
    status = json['status']?.toString();
    isDeleted = json['is_deleted']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    imageUrl = json['image_url']?.toString();
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'slug': slug, 'name': name, 'description': description,
    'image': image, 'status': status, 'is_deleted': isDeleted,
    'created_at': createdAt, 'updated_at': updatedAt, 'image_url': imageUrl,
  };
}

// ─── CategoryDetail ───────────────────────────────────────────────────────────

class CategoryDetail {
  String? id;
  String? parentId;
  String? slug;
  String? name;
  String? description;
  String? image;
  String? status;
  String? isDeleted;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;

  CategoryDetail({this.id, this.parentId, this.slug, this.name, this.description,
    this.image, this.status, this.isDeleted, this.createdAt, this.updatedAt, this.imageUrl});

  CategoryDetail.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    parentId = json['parent_id']?.toString();
    slug = json['slug']?.toString();
    name = json['name']?.toString();
    description = json['description']?.toString();
    image = json['image']?.toString();
    status = json['status']?.toString();
    isDeleted = json['is_deleted']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    imageUrl = json['image_url']?.toString();
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'parent_id': parentId, 'slug': slug, 'name': name,
    'description': description, 'image': image, 'status': status,
    'is_deleted': isDeleted, 'created_at': createdAt, 'updated_at': updatedAt,
    'image_url': imageUrl,
  };
}

// ─── SubCategoryDetail ────────────────────────────────────────────────────────

class SubCategoryDetail {
  String? id;
  String? parentId;
  String? slug;
  String? name;
  String? description;
  String? image;
  String? status;
  String? isDeleted;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;

  SubCategoryDetail({this.id, this.parentId, this.slug, this.name, this.description,
    this.image, this.status, this.isDeleted, this.createdAt, this.updatedAt, this.imageUrl});

  SubCategoryDetail.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    parentId = json['parent_id']?.toString();
    slug = json['slug']?.toString();
    name = json['name']?.toString();
    description = json['description']?.toString();
    image = json['image']?.toString();
    status = json['status']?.toString();
    isDeleted = json['is_deleted']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    imageUrl = json['image_url']?.toString();
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'parent_id': parentId, 'slug': slug, 'name': name,
    'description': description, 'image': image, 'status': status,
    'is_deleted': isDeleted, 'created_at': createdAt, 'updated_at': updatedAt,
    'image_url': imageUrl,
  };
}

// ─── ProductAttributeItem (get_product_attributes_list) ──────────────────────

class ProductAttributeItem {
  String? attributeId;
  String? attributeValue;
  AttributeDetail? attributeData;

  ProductAttributeItem({this.attributeId, this.attributeValue, this.attributeData});

  ProductAttributeItem.fromJson(Map<String, dynamic> json) {
    attributeId = json['attribute_id']?.toString();
    attributeValue = json['attribute_value']?.toString();
    attributeData = json['attribute_data'] != null
        ? AttributeDetail.fromJson(json['attribute_data'])
        : null;
  }

  Map<String, dynamic> toJson() => {
    'attribute_id': attributeId,
    'attribute_value': attributeValue,
    if (attributeData != null) 'attribute_data': attributeData!.toJson(),
  };
}

// ─── ProductVariantItem (getProductVariantsList) ──────────────────────────────

class ProductVariantItem {
  String? id;
  String? variantName;
  String? sku;
  String? price;
  String? stock;
  bool? isEnabled;
  List<ProductVariantAttributeItem>? attributes;

  ProductVariantItem({this.id, this.variantName, this.sku, this.price,
    this.stock, this.isEnabled, this.attributes});

  ProductVariantItem.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    variantName = json['variant_name']?.toString();
    sku = json['sku']?.toString();
    price = json['price']?.toString();
    stock = json['stock']?.toString();
    isEnabled = json['is_enabled'] == true || json['is_enabled']?.toString() == '1';
    if (json['attributes'] != null) {
      attributes = <ProductVariantAttributeItem>[];
      json['attributes'].forEach((v) {
        attributes!.add(ProductVariantAttributeItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'variant_name': variantName,
    'sku': sku,
    'price': price,
    'stock': stock,
    'is_enabled': isEnabled,
    if (attributes != null)
      'attributes': attributes!.map((v) => v.toJson()).toList(),
  };
}

// ─── ProductVariantAttributeItem (getProductVariantsList[].attributes) ────────

class ProductVariantAttributeItem {
  String? attributeId;
  String? attributeName;
  String? attributeValue;

  ProductVariantAttributeItem({this.attributeId, this.attributeName, this.attributeValue});

  ProductVariantAttributeItem.fromJson(Map<String, dynamic> json) {
    attributeId = json['attribute_id']?.toString();
    attributeName = json['attribute_name']?.toString();
    attributeValue = json['attribute_value']?.toString();
  }

  Map<String, dynamic> toJson() => {
    'attribute_id': attributeId,
    'attribute_name': attributeName,
    'attribute_value': attributeValue,
  };
}

// ─── PerformanceStats (compatibility stub) ────────────────────────────────────

class PerformanceStats {
  String? totalOrders;
  String? averageRating;
  String? totalRevenue;

  PerformanceStats({this.totalOrders, this.averageRating, this.totalRevenue});

  PerformanceStats.fromJson(Map<String, dynamic> json) {
    totalOrders = json['total_orders']?.toString();
    averageRating = json['average_rating']?.toString();
    totalRevenue = json['total_revenue']?.toString();
  }

  Map<String, dynamic> toJson() => {
    'total_orders': totalOrders,
    'average_rating': averageRating,
    'total_revenue': totalRevenue,
  };
}
