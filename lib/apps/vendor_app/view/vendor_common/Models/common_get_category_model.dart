import 'package:get/get.dart';

class CommonGetCategoryModel {
  bool? status;
  List<Categories>? categories;

  CommonGetCategoryModel({this.status, this.categories});

  CommonGetCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  String? id;
  String? name;
  String? parentCategory;
  String? status;
  String? imageUrl;
  RxList<Attributes>? attributes;
  List<Options>? options;
  List<Addons>? addons;
  List<Variants>? variants;

  Categories(
      {this.id,
        this.name,
        this.parentCategory,
        this.status,
        this.imageUrl,
        this.attributes,
        this.options,
        this.addons,
        this.variants,
      });

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    parentCategory = json['parent_category']?.toString();
    status = json['status']?.toString();
    imageUrl = json['image_url']?.toString();
    if (json['attributes'] != null) {
      attributes = <Attributes>[].obs;
      json['attributes'].forEach((v) {
        attributes!.add(Attributes.fromJson(v));
      });
    }
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
    if (json['addons'] != null) {
      addons = <Addons>[];
      json['addons'].forEach((v) {
        addons!.add(Addons.fromJson(v));
      });
    }
    if (json['variants'] != null) {
      variants = <Variants>[];
      json['variants'].forEach((v) {
        variants!.add(Variants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['parent_category'] = parentCategory;
    data['status'] = status;
    data['image_url'] = imageUrl;
    if (attributes != null) {
      data['attributes'] = attributes!.map((v) => v.toJson()).toList();
    }
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    if (addons != null) {
      data['addons'] = addons!.map((v) => v?.toJson()).toList();
    }
    if (variants != null) {
      data['variants'] = variants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attributes {
  String? id;
  String? name;
  String? categoryId;
  String? groupName;
  List<Items>? items;


  Attributes({this.id, this.name, this.categoryId});

  Attributes.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    categoryId = json['category_id']?.toString();
    groupName = json['group_name']?.toString();
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['category_id'] = categoryId;
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

class Options {
  String? id;
  String? name;
  String? categoryId;

  Options({this.id, this.name, this.categoryId});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    categoryId = json['category_id']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['category_id'] = categoryId;
    return data;
  }
}

class Addons {
  String? id;
  String? name;
  String? categoryId;

  Addons({this.id, this.name, this.categoryId});

  factory Addons.fromJson(Map<String, dynamic> json) {
    return Addons(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      categoryId: json['category_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category_id': categoryId,
    };
  }
}

class Variants {
  String? id;
  String? name;
  String? imageUrl;
  String? categoryName;
  String? cuisineName;
  String? brandName;
  String? packagingName;
  String? applicationName;
  String? productAttributeName;
  String? category;
  String? cuisine;
  String? brand;
  String? packaging;
  String? application;

  Variants(
      {this.id,
        this.name,
        this.imageUrl,
        this.categoryName,
        this.cuisineName,
        this.brandName,
        this.packagingName,
        this.applicationName,
        this.productAttributeName,
        this.category,
        this.cuisine,
        this.brand,
        this.packaging,
        this.application});

  Variants.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['title']?.toString();
    imageUrl = json['image_url']?.toString();
    categoryName = json['category_name']?.toString();
    cuisineName = json['cuisine_name']?.toString();
    brandName = json['brand_name']?.toString();
    packagingName = json['packaging_name']?.toString();
    applicationName = json['application_name']?.toString();
    productAttributeName = json['product_attribute_name']?.toString();
    category = json['category']?.toString();
    cuisine = json['cuisine']?.toString();
    brand = json['brand']?.toString();
    packaging = json['packaging']?.toString();
    application = json['application']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['title'] = name;
    data['image_url'] = imageUrl;
    data['category_name'] = categoryName;
    data['cuisine_name'] = cuisineName;
    data['brand_name'] = brandName;
    data['packaging_name'] = packagingName;
    data['application_name'] = applicationName;
    data['product_attribute_name'] = productAttributeName;
    data['category'] = category;
    data['cuisine'] = cuisine;
    data['brand'] = brand;
    data['packaging'] = packaging;
    data['application'] = application;
    return data;
  }
}