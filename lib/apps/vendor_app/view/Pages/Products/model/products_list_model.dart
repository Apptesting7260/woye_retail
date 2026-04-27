// class ProductsListModel {
//   ProductsListModel({
//     required this.status,
//     required this.productCount,
//     required this.productStockLowCount,
//     required this.productActiveCount,
//     required this.productInactiveCount,
//     required this.productActiveList,
//     required this.productInactiveList,
//   });
//
//   final bool status;
//   final int productCount;
//   final int productStockLowCount;
//   final int productActiveCount;
//   final int productInactiveCount;
//   final List<ProductActiveList> productActiveList;
//   final List<ProductInactiveList> productInactiveList;
//
//   ProductsListModel.fromJson(Map<String, dynamic> json)
//       : status = json['status'],
//         productCount = json['product_count'],
//         productStockLowCount = json['product_stock_low_count'],
//         productActiveCount = json['product_active_count'],
//         productInactiveCount = json['product_inactive_count'],
//         productActiveList = List.from(json['product_active_list'])
//             .map((e) => ProductActiveList.fromJson(e))
//             .toList(),
//         productInactiveList = List.from(json['product_inactive_list'])
//             .map((e) => ProductInactiveList.fromJson(e))
//             .toList();
//
//   Map<String, dynamic> toJson() {
//     return {
//       'status': status,
//       'product_count': productCount,
//       'product_stock_low_count': productStockLowCount,
//       'product_active_count': productActiveCount,
//       'product_inactive_count': productInactiveCount,
//       'product_active_list': productActiveList.map((e) => e.toJson()).toList(),
//       'product_inactive_list':
//           productInactiveList.map((e) => e.toJson()).toList(),
//     };
//   }
// }
//
// class ProductActiveList {
//   ProductActiveList({
//     required this.id,
//     required this.title,
//     required this.userId,
//     required this.categoryId,
//     required this.regularPrice,
//     required this.salePrice,
//     required this.quanInStock,
//     required this.description,
//     required this.discount,
//     required this.cuisineType,
//     required this.rating,
//     required this.image,
//     required this.extra,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.urlAddimg,
//     required this.urlImage,
//     required this.addOnWithNames,
//   });
//
//   final int id;
//   final String title;
//   final int userId;
//   final int categoryId;
//   final String regularPrice;
//   final int salePrice;
//   final String quanInStock;
//   final String description;
//   final String discount;
//   final int cuisineType;
//   final int rating;
//   final String image;
//   final List<Extra> extra;
//   final int status;
//   final String createdAt;
//   final String updatedAt;
//   final List<String> urlAddimg;
//   final String urlImage;
//   final List<AddOnWithNames> addOnWithNames;
//
//   ProductActiveList.fromJson(Map<String, dynamic> json)
//       : id = json['id'],
//         title = json['title'],
//         userId = json['user_id'],
//         categoryId = json['category_id'],
//         regularPrice = json['regular_price'],
//         salePrice = json['sale_price'],
//         quanInStock = json['quan_in_stock'],
//         description = json['description'],
//         discount = json['discount'],
//         cuisineType = json['cuisine_type'],
//         rating = json['rating'],
//         image = json['image'],
//         extra = List.from(json['extra']).map((e) => Extra.fromJson(e)).toList(),
//         status = json['status'],
//         createdAt = json['created_at'],
//         updatedAt = json['updated_at'],
//         urlAddimg = List.castFrom<dynamic, String>(json['url_addimg']),
//         urlImage = json['url_image'],
//         addOnWithNames = List.from(json['add_on_with_names'])
//             .map((e) => AddOnWithNames.fromJson(e))
//             .toList();
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'user_id': userId,
//       'category_id': categoryId,
//       'regular_price': regularPrice,
//       'sale_price': salePrice,
//       'quan_in_stock': quanInStock,
//       'description': description,
//       'discount': discount,
//       'cuisine_type': cuisineType,
//       'rating': rating,
//       'image': image,
//       'extra': extra.map((e) => e.toJson()).toList(),
//       'status': status,
//       'created_at': createdAt,
//       'updated_at': updatedAt,
//       'url_addimg': urlAddimg,
//       'url_image': urlImage,
//       'add_on_with_names': addOnWithNames.map((e) => e.toJson()).toList(),
//     };
//   }
// }
//
// class Extra {
//   Extra({
//     required this.titleid,
//     required this.item,
//     required this.title,
//   });
//
//   final String titleid;
//   final List<Item> item;
//   final String title;
//
//   Extra.fromJson(Map<String, dynamic> json)
//       : titleid = json['titleid'],
//         item = List.from(json['item']).map((e) => Item.fromJson(e)).toList(),
//         title = json['title'];
//
//   Map<String, dynamic> toJson() {
//     return {
//       'titleid': titleid,
//       'item': item.map((e) => e.toJson()).toList(),
//       'title': title,
//     };
//   }
// }
//
// class Item {
//   Item({
//     required this.id,
//     required this.name,
//     required this.price,
//   });
//
//   final String id;
//   final String name;
//   final String price;
//
//   Item.fromJson(Map<String, dynamic> json)
//       : id = json['id'],
//         name = json['name'],
//         price = json['price'];
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'price': price,
//     };
//   }
// }
//
// class AddOnWithNames {
//   AddOnWithNames({
//     required this.id,
//     required this.price,
//     required this.name,
//   });
//
//   final String id;
//   final String price;
//   final String name;
//
//   AddOnWithNames.fromJson(Map<String, dynamic> json)
//       : id = json['id'],
//         price = json['price'],
//         name = json['name'];
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'price': price,
//       'name': name,
//     };
//   }
// }
//
// class ProductInactiveList {
//   ProductInactiveList({
//     required this.id,
//     required this.title,
//     required this.userId,
//     required this.categoryId,
//     required this.regularPrice,
//     required this.salePrice,
//     required this.quanInStock,
//     required this.description,
//     required this.discount,
//     required this.cuisineType,
//     required this.rating,
//     required this.image,
//     required this.extra,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.urlAddimg,
//     required this.urlImage,
//     required this.addOnWithNames,
//   });
//
//   final int id;
//   final String title;
//   final int userId;
//   final int categoryId;
//   final String regularPrice;
//   final int salePrice;
//   final String quanInStock;
//   final String description;
//   final String discount;
//   final int cuisineType;
//   final int rating;
//   final String image;
//   final List<Extra> extra;
//   final int status;
//   final String createdAt;
//   final String updatedAt;
//   final List<String> urlAddimg;
//   final String urlImage;
//   final List<AddOnWithNames> addOnWithNames;
//
//   ProductInactiveList.fromJson(Map<String, dynamic> json)
//       : id = json['id'],
//         title = json['title'],
//         userId = json['user_id'],
//         categoryId = json['category_id'],
//         regularPrice = json['regular_price'],
//         salePrice = json['sale_price'],
//         quanInStock = json['quan_in_stock'],
//         description = json['description'],
//         discount = json['discount'],
//         cuisineType = json['cuisine_type'],
//         rating = json['rating'],
//         image = json['image'],
//         extra = List.from(json['extra']).map((e) => Extra.fromJson(e)).toList(),
//         status = json['status'],
//         createdAt = json['created_at'],
//         updatedAt = json['updated_at'],
//         urlAddimg = List.castFrom<dynamic, String>(json['url_addimg']),
//         urlImage = json['url_image'],
//         addOnWithNames = List.from(json['add_on_with_names'])
//             .map((e) => AddOnWithNames.fromJson(e))
//             .toList();
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'user_id': userId,
//       'category_id': categoryId,
//       'regular_price': regularPrice,
//       'sale_price': salePrice,
//       'quan_in_stock': quanInStock,
//       'description': description,
//       'discount': discount,
//       'cuisine_type': cuisineType,
//       'rating': rating,
//       'image': image,
//       'extra': extra.map((e) => e.toJson()).toList(),
//       'status': status,
//       'created_at': createdAt,
//       'updated_at': updatedAt,
//       'url_addimg': urlAddimg,
//       'url_image': urlImage,
//       'add_on_with_names': addOnWithNames.map((e) => e.toJson()).toList(),
//     };
//   }
// }
