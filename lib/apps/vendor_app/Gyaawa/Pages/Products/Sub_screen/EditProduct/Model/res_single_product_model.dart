  import 'dart:convert';

class ResSingleProductModel {
    bool? status;
    String? message;
    Product? product;

    ResSingleProductModel({this.status, this.product,this.message});

    ResSingleProductModel.fromJson(Map<String, dynamic> json) {
      status = json['status'];
      message = json['message']?.toString();
      product =
      json['product'] != null ? Product.fromJson(json['product']) : null;
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['status'] = status;
      data['message'] = message;
      if (product != null) {
        data['product'] = product!.toJson();
      }
      return data;
    }
  }

    class Product {
      String? id;
      String? title;
      String? slug;
      String? sku;
      String? description;
      String? image;
      String? addimg;
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
      String? preparationTime;
      String? rating;
      List<AddOns>? addOns;
      List<Options>? options;
      List<String>? productAttributes;
      List<Variant>? variant;
      String? type;
      String? status;
      String? createdAt;
      String? updatedAt;
      String? deletedAt;
      List<String>? addimgUrl;
      String? imageUrl;
      String? categoryName;
      String? cuisineName;
      String? productAttributeName;
      String? brandName;
      String? packagingName;
      String? packageSize;
      String? genericName;
      String? manufacturer;
      String? deaSchedule;
      String? currentStock;
      String? reorderLevel;
     String? cost;
     String? therapeuticClass;
     String? storageRequirements;
     String? lotNumber;
     String? expirationDate;
     String? prescription;
     String? controlledSubstance;
     String? applicationName;

      Brand? brand;

      PerformanceStats? performanceStats;
      String? howToUse;
      String? usageDirectionDosage;
      String? interactions;
      String? sideEffect;
      String? expertAdviceConcern;
      String? whenNotToUse;
      String? generalInstructionsWarnings;
      String? otherDetails;


      Product(
          {this.id,
            this.title,
            this.slug,
            this.sku,
            this.description,
            this.image,
            this.addimg,
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
            this.preparationTime,
            this.rating,
            this.addOns,
            this.options,
            this.productAttributes,
            this.variant,
            this.type,
            this.status,
            this.createdAt,
            this.updatedAt,
            this.deletedAt,
            this.addimgUrl,
            this.imageUrl,
            this.categoryName,
            this.cuisineName,
            this.productAttributeName,
            this.brandName,
            this.packagingName,
            this.performanceStats,
            this.manufacturer,
            this.deaSchedule,
            this.brand,
            this.genericName,
            this.currentStock,
            this.reorderLevel,
            this.cost,
            this.therapeuticClass,
            this.storageRequirements,
            this.lotNumber,
            this.expirationDate,
            this.prescription,
            this.controlledSubstance,
            this.packageSize,
            this.applicationName,
            this.howToUse,
            this.usageDirectionDosage,
            this.interactions,
            this.sideEffect,
            this.expertAdviceConcern,
            this.whenNotToUse,
            this.generalInstructionsWarnings,
            this.otherDetails,
          });

      Product.fromJson(Map<String, dynamic> json) {
        id = json['id']?.toString();
        title = json['title']?.toString();
        genericName = json['generic_name']?.toString();
        currentStock = json['current_stock']?.toString();
        reorderLevel = json['reorder_level']?.toString();
        storageRequirements = json['storage_requirements'].toString();
        cost = json['cost'].toString();
        therapeuticClass = json['therapeutic_class'].toString();
        applicationName = json['application_name'].toString();

        slug = json['slug']?.toString();
        sku = json['sku']?.toString();
        description = json['description']?.toString();
        image = json['image']?.toString();
        addimg = json['addimg']?.toString();
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
        preparationTime = json['preparation_time']?.toString();
        rating = json['rating']?.toString();
        prescription = json['prescription']?.toString();
        deaSchedule = json['dea_schedule']?.toString();
        applicationName = json['application_name']?.toString();
        if (json['add_ons'] != null) {
          addOns = <AddOns>[];
          json['add_ons'].forEach((v) {
            addOns!.add(AddOns.fromJson(v));
          });
        }
        if (json['options'] != null) {
          options = <Options>[];
          json['options'].forEach((v) {
            options!.add(Options.fromJson(v));
          });
        }
        if (json['product_attributes'] != null) {
          productAttributes = List<String>.from(json['product_attributes']);
        } else {
          productAttributes = [];
        }
        if (json['variant'] != null) {
          variant = <Variant>[];
          json['variant'].forEach((v) {
            variant!.add(Variant.fromJson(v));
          });
        }

        type = json['type'];
        updatedAt = json['updated_at']?.toString();
        status = json['status'];
         createdAt = json['created_at']?.toString();
         deletedAt = json['deleted_at']?.toString();
        // if(addimgUrl != null){
        addimgUrl = json['addimg_url'].cast<String>();
        // }else{
        //   addimgUrl = [];
        // }
        imageUrl = json['image_url']?.toString();
        categoryName = json['category_name']?.toString();
        cuisineName = json['cuisine_name']?.toString();
        productAttributeName = json['product_attribute_name']?.toString();
        brandName = json['brand_name']?.toString();
        packagingName = json['packaging_name']?.toString();
        lotNumber = json['lot_number']?.toString();
        expirationDate = json['expiration_date']?.toString();
        controlledSubstance = json['controlled_substance']?.toString();
        packageSize = json['package_size']?.toString();

        brand = json['brand'] != null
            ? Brand.fromJson(json['brand'])
            : null;

        performanceStats = json['performance_stats'] != null
            ? PerformanceStats.fromJson(json['performance_stats'])
            : null;
        howToUse = json['how_to_use']?.toString();
        usageDirectionDosage = json['usage_direction_dosage']?.toString();
        interactions = json['interactions']?.toString();
        sideEffect = json['side_effect']?.toString();
        expertAdviceConcern = json['expert_advice_concern']?.toString();
        whenNotToUse = json['when_not_to_use']?.toString();
        generalInstructionsWarnings = json['general_instructions_warnings']?.toString();
        otherDetails = json['other_details']?.toString();
      }


      Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['id'] = id;
        data['title'] = title;
        data['manufacturer'] = manufacturer;
        data['slug'] = slug;
        data['sku'] = sku;
        data['description'] = description;
        data['image'] = image;
        data['addimg'] = addimg;
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
        data['preparation_time'] = preparationTime;
        data['rating'] = rating;
        data['controlled_substance'] = controlledSubstance;
        if (addOns != null) {
          data['add_ons'] = addOns!.map((v) => v.toJson()).toList();
        }
        if (options != null) {
          data['options'] = options!.map((v) => v.toJson()).toList();
        }
        data['product_attributes'] = productAttributes;
        if (variant != null) {
          data['variant'] = variant!.map((v) => v.toJson()).toList();
        }
        data['type'] = type;
        data['status'] = status;
        data['created_at'] = createdAt;
        data['updated_at'] = updatedAt;
        data['deleted_at'] = deletedAt;
        data['addimg_url'] = addimgUrl;
        data['image_url'] = imageUrl;
        data['category_name'] = categoryName;
        data['brand_name'] = brandName;
        data['packaging_name'] = packagingName;
        data['generic_name'] = genericName;
        data['dea_schedule'] = deaSchedule;
        data['current_stock'] = currentStock;
        data['reorder_level'] = reorderLevel;
        data['cost'] = cost;
        data['therapeutic_class'] = therapeuticClass;
        data['storage_requirements'] = storageRequirements;
        data['lot_number'] = lotNumber;
        data['expiration_date'] = expirationDate;
        data['prescription'] = prescription;
        data['package_size'] = packageSize;


        if (performanceStats != null) {
          data['performance_stats'] = performanceStats!.toJson();
        }
        data['how_to_use'] = howToUse;
        data['usage_direction_dosage'] = usageDirectionDosage;
        data['interactions'] = interactions;
        data['side_effect'] = sideEffect;
        data['expert_advice_concern'] = expertAdviceConcern;
        data['when_not_to_use'] = whenNotToUse;
        data['general_instructions_warnings'] = generalInstructionsWarnings;
        data['other_details'] = otherDetails;
        return data;
      }
    }

  class Variant {
    String? id;
    String? name;

    Variant({this.id, this.name});

    Variant.fromJson(Map<String, dynamic> json) {
      id = json['id']?.toString();
      name = json['name']?.toString();
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = Map<String, dynamic>();
      data['id'] = id;
      data['name'] = name;
      return data;
    }
  }

  class Brand {
    int? id;
    String? name;
    String? manufacturer;
    String? country;
    int? established;
    String? category;
    String? description;
    String? type;
    String? status;
    String? createdAt;
    String? updatedAt;

    Brand({
      this.id,
      this.name,
      this.manufacturer,
      this.country,
      this.established,
      this.category,
      this.description,
      this.type,
      this.status,
      this.createdAt,
      this.updatedAt,
    });

    factory Brand.fromJson(Map<String, dynamic> json) {
      return Brand(
        id: json['id'],
        name: json['name'],
        manufacturer: json['manufacturer'],
        country: json['country'],
        established: json['established'],
        category: json['category'],
        description: json['description'],
        type: json['type'],
        status: json['status'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );
    }

    Map<String, dynamic> toJson() {
      return {
        'id': id,
        'name': name,
        'manufacturer': manufacturer,
        'country': country,
        'established': established,
        'category': category,
        'description': description,
        'type': type,
        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
    }
  }

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

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['total_orders'] = totalOrders;
      data['average_rating'] = averageRating;
      data['total_revenue'] = totalRevenue;
      return data;
    }
  }


  class AddOns {
    String? id;
    String? price;

    AddOns({this.id, this.price});

    AddOns.fromJson(Map<String, dynamic> json) {
      id = json['id']?.toString();
      price = json['price']?.toString();
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = id;
      data['price'] = price;
      return data;
    }
  }

  class Options {
    String? optionId;
    List<Choices>? choices;

    Options({this.optionId, this.choices});

    Options.fromJson(Map<String, dynamic> json) {
      optionId = json['option_id']?.toString();
      if (json['choices'] != null) {
        choices = <Choices>[];
        json['choices'].forEach((v) {
          choices!.add(Choices.fromJson(v));
        });
      }
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['option_id'] = optionId;
      if (choices != null) {
        data['choices'] = choices!.map((v) => v.toJson()).toList();
      }
      return data;
    }
  }

  class Choices {
    String? name;
    String? price;

    Choices({this.name, this.price});

    Choices.fromJson(Map<String, dynamic> json) {
      name = json['name']?.toString();
      price = json['price']?.toString();
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['name'] = name;
      data['price'] = price;
      return data;
    }
  }


// import 'package:get/get.dart';
//
// class ResSingleProductModel {
//   bool? status;
//   Product? product;
//
//   ResSingleProductModel({this.status, this.product});
//
//   ResSingleProductModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     product =
//         json['product'] != null ? Product.fromJson(json['product']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     if (product != null) {
//       data['product'] = product!.toJson();
//     }
//     return data;
//   }
// }
//
// class Product {
//   String? id;
//   String? title;
//   String? sku;
//   String? slug;
//   String? userId;
//   String? categoryId;
//   String? regularPrice;
//   String? salePrice;
//   String? quanInStock;
//   String? description;
//   String? discount;
//   String? cuisineType;
//   String? rating;
//   String? image;
//   RxList<Extra>? extra;
//   String? status;
//   String? createdAt;
//   String? updatedAt;
//   String? deletedAt;
//   List<String>? urlAddimg;
//   String? urlImage;
//   RxList<AddOnWithNames>? addOnWithNames;
//   Category? category;
//
//   Product(
//       {this.id,
//       this.title,
//       this.sku,
//       this.slug,
//       this.userId,
//       this.categoryId,
//       this.regularPrice,
//       this.salePrice,
//       this.quanInStock,
//       this.description,
//       this.discount,
//       this.cuisineType,
//       this.rating,
//       this.image,
//       this.extra,
//       this.status,
//       this.createdAt,
//       this.updatedAt,
//       this.deletedAt,
//       this.urlAddimg,
//       this.urlImage,
//       this.addOnWithNames,
//       this.category});
//
//   Product.fromJson(Map<String, dynamic> json) {
//     id = json['id']?.toString();
//     title = json['title']?.toString();
//     sku = json['sku']?.toString();
//     slug = json['slug']?.toString();
//     userId = json['user_id']?.toString();
//     categoryId = json['category_id']?.toString();
//     regularPrice = json['regular_price']?.toString();
//     salePrice = json['sale_price']?.toString();
//     quanInStock = json['quan_in_stock']?.toString();
//     description = json['description']?.toString();
//     discount = json['discount']?.toString();
//     cuisineType = json['cuisine_type']?.toString();
//     rating = json['rating']?.toString();
//     image = json['image']?.toString();
//     if (json['extra'] != null) {
//       extra = <Extra>[].obs;
//       json['extra'].forEach((v) {
//         extra!.add(Extra.fromJson(v));
//       });
//     }
//     status = json['status']?.toString();
//     createdAt = json['created_at']?.toString();
//     updatedAt = json['updated_at']?.toString();
//     deletedAt = json['deleted_at']?.toString();
//     urlAddimg = json['url_addimg'].cast<String>();
//     urlImage = json['url_image']?.toString();
//     if (json['add_on_with_names'] != null) {
//       addOnWithNames = <AddOnWithNames>[].obs;
//       json['add_on_with_names'].forEach((v) {
//         addOnWithNames!.add(AddOnWithNames.fromJson(v));
//       });
//     }else{
//       addOnWithNames = <AddOnWithNames>[].obs;
//     }
//     category = json['category'] != null
//         ? Category.fromJson(json['category'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['title'] = title;
//     data['slug'] = slug;
//     data['user_id'] = userId;
//     data['category_id'] = categoryId;
//     data['regular_price'] = regularPrice;
//     data['sale_price'] = salePrice;
//     data['quan_in_stock'] = quanInStock;
//     data['description'] = description;
//     data['discount'] = discount;
//     data['cuisine_type'] = cuisineType;
//     data['rating'] = rating;
//     data['image'] = image;
//     if (extra != null) {
//       data['extra'] = extra!.map((v) => v.toJson()).toList();
//     }
//     data['status'] = status;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['deleted_at'] = deletedAt;
//     data['url_addimg'] = urlAddimg;
//     data['url_image'] = urlImage;
//     if (addOnWithNames != null) {
//       data['add_on_with_names'] =
//           addOnWithNames!.map((v) => v.toJson()).toList();
//     }
//     if (category != null) {
//       data['category'] = category!.toJson();
//     }
//     return data;
//   }
//
//   Map<String, dynamic> forApiSubmit() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['product_id'] = id;
//     data['title'] = title;
//     data['sku'] = sku;
//     data['category_id'] = categoryId;
//     data['status'] = status;
//     data['regular_price'] = regularPrice;
//     data['sale_price'] = salePrice;
//     data['quan_in_stock'] = quanInStock;
//     data['description'] = description;
//     data['discount'] = discount;
//     data['cuisine_type'] = cuisineType;
//     // data['image'] = image;
//     if (extra != null) {
//       data['extra'] = extra!.map((v) => v.toJson()).toList();
//     }
//     if (addOnWithNames != null) {
//       data['add_on'] =
//           addOnWithNames!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Extra {
//   String? titleid;
//   RxList<Item>? item;
//   String? title;
//
//   Extra({this.titleid, this.item, this.title});
//
//   Extra.fromJson(Map<String, dynamic> json) {
//     titleid = json['titleid']?.toString();
//     if (json['item'] != null) {
//       item = <Item>[].obs;
//       json['item'].forEach((v) {
//         item!.add(Item.fromJson(v));
//       });
//     }
//     title = json['title']?.toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['titleid'] = titleid;
//     if (item != null) {
//       data['item'] = item!.map((v) => v.toJson()).toList();
//     }
//     data['title'] = title;
//     return data;
//   }
// }
//
// class Item {
//   String? name;
//   String? id;
//   String? price;
//
//   Item({this.name, this.id, this.price});
//
//   Item.fromJson(Map<String, dynamic> json) {
//     name = json['name']?.toString();
//     id = json['id']?.toString();
//     price = json['price']?.toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['name'] = name;
//     data['id'] = id;
//     data['price'] = price;
//     return data;
//   }
// }
//
// class AddOnWithNames {
//   AddOnWithNames({
//     this.id,
//     this.price,
//     this.name,
//   });
//
//    RxString? id;
//    String? price;
//    String? name;
//
//   AddOnWithNames.fromJson(Map<String, dynamic> json)
//       : id = json['id']?.toString().obs,
//         price = json['price']?.toString(),
//         name = json['name']?.toString();
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id?.value,
//       'price': price,
//       'name': name,
//     };
//   }
// }
//
// class Category {
//   String? id;
//   String? name;
//   String? imageUrl;
//
//   Category({this.id, this.name, this.imageUrl});
//
//   Category.fromJson(Map<String, dynamic> json) {
//     id = json['id']?.toString();
//     name = json['name']?.toString();
//     imageUrl = json['image_url']?.toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['image_url'] = imageUrl;
//     return data;
//   }
// }
