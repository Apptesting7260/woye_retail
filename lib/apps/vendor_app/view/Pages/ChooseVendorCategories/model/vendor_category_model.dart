// class CategoryAndCuisinesModel {
//   bool? status;
//   Data? data;
//
//   CategoryAndCuisinesModel({this.status, this.data});
//
//   CategoryAndCuisinesModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     data = json['data'] != null ? Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class Data {
//   List<Categories>? categories;
//   // List<Cuisines>? cuisines;
//
//   Data({this.categories,
//     // this.cuisines
//   });
//
//   Data.fromJson(Map<String, dynamic> json) {
//     if (json['categories'] != null) {
//       categories = <Categories>[];
//       json['categories'].forEach((v) {
//         categories!.add(Categories.fromJson(v));
//       });
//     }
//     // if (json['cuisines'] != null) {
//     //   cuisines = <Cuisines>[];
//     //   json['cuisines'].forEach((v) {
//     //     cuisines!.add(Cuisines.fromJson(v));
//     //   });
//     // }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (categories != null) {
//       data['categories'] = categories!.map((v) => v.toJson()).toList();
//     }
//     // if (cuisines != null) {
//     //   data['cuisines'] = cuisines!.map((v) => v.toJson()).toList();
//     // }
//     return data;
//   }
// }
//
// class Categories {
//   String? id;
//   String? name;
//   String? parentCategory;
//   String? image;
//   String? imageUrl;
//   String? productsCount;
//
//   Categories(
//       {this.id,
//         this.name,
//         this.parentCategory,
//         this.image,
//         this.imageUrl,
//         this.productsCount});
//
//   Categories.fromJson(Map<String, dynamic> json) {
//     id = json['id']?.toString();
//     name = json['name']?.toString();
//     parentCategory = json['parent_category']?.toString();
//     image = json['image']?.toString();
//     imageUrl = json['image_url']?.toString();
//     productsCount = json['products_count']?.toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['parent_category'] = parentCategory;
//     data['image'] = image;
//     data['image_url'] = imageUrl;
//     data['products_count'] = productsCount;
//     return data;
//   }
// }
//
// class Cuisines {
//   String? id;
//   String? name;
//   String? image;
//   String? imageUrl;
//
//   Cuisines({this.id, this.name, this.image, this.imageUrl});
//
//   Cuisines.fromJson(Map<String, dynamic> json) {
//     id = json['id']?.toString();
//     name = json['name']?.toString();
//     image = json['image']?.toString();
//     imageUrl = json['image_url']?.toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['image'] = image;
//     data['image_url'] = imageUrl;
//     return data;
//   }
// }

class   GetDepartmentModel {
  bool? status;
  Data? data;

  GetDepartmentModel({this.status, this.data});

  GetDepartmentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Categories>? categories;

  Data({this.categories});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  String? id;
  String? name;
  String? image;
  String? imageUrl;

  Categories({this.id, this.name, this.image, this.imageUrl});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    image = json['image'].toString();
    imageUrl = json['image_url'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['image_url'] = imageUrl;
    return data;
  }
}

