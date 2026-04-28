import 'package:get/get.dart';
class DashboardModel {
  bool? status;
  Dashboard? dashboard;

  DashboardModel({this.status, this.dashboard});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    dashboard = json['dashboard'] != null
        ? Dashboard.fromJson(json['dashboard'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (dashboard != null) {
      data['dashboard'] = dashboard!.toJson();
    }
    return data;
  }
}

class Dashboard {
  Cards? cards;
  RevenueTrend? revenueTrend;
  OrderStatusChart? orderStatusChart;
  List<RecentOrders>? recentOrders;
  List<TopSellingProducts>? topSellingProducts;
  List<Reviews>? reviews;
  String? shopStatus;

  Dashboard(
      {this.cards,
        this.revenueTrend,
        this.orderStatusChart,
        this.recentOrders,
        this.topSellingProducts,
        this.reviews,
        this.shopStatus,
      });

  Dashboard.fromJson(Map<String, dynamic> json) {
    cards = json['cards'] != null ? Cards.fromJson(json['cards']) : null;
    revenueTrend = json['revenue_trend'] != null
        ? RevenueTrend.fromJson(json['revenue_trend'])
        : null;
    orderStatusChart = json['order_status_chart'] != null
        ? OrderStatusChart.fromJson(json['order_status_chart'])
        : null;
    if (json['recent_orders'] != null) {
      recentOrders = <RecentOrders>[];
      json['recent_orders'].forEach((v) {
        recentOrders!.add(RecentOrders.fromJson(v));
      });
    }
    if (json['top_selling_products'] != null) {
      topSellingProducts = <TopSellingProducts>[];
      json['top_selling_products'].forEach((v) {
        topSellingProducts!.add(TopSellingProducts.fromJson(v));
      });
    }
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(Reviews.fromJson(v));
      });
    }
    shopStatus = json['shop_status']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cards != null) {
      data['cards'] = cards!.toJson();
    }
    if (revenueTrend != null) {
      data['revenue_trend'] = revenueTrend!.toJson();
    }
    if (orderStatusChart != null) {
      data['order_status_chart'] = orderStatusChart!.toJson();
    }
    if (recentOrders != null) {
      data['recent_orders'] =
          recentOrders!.map((v) => v.toJson()).toList();
    }
    if (topSellingProducts != null) {
      data['top_selling_products'] =
          topSellingProducts!.map((v) => v.toJson()).toList();
    }
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    data['shop_status'] = shopStatus;
    return data;
  }
}

class Cards {
  String? todayRevenue;
  String? totalOrders;
  String? totalProducts;
  String? customerRating;
  String? todayRevenuePercentage;
  String? totalOrdersPercentage;
  String? totalProductsPercentage;
  String? customerRatingPercentage;

  Cards(
      {this.todayRevenue,
        this.totalOrders,
        this.totalProducts,
        this.customerRating,
        this.todayRevenuePercentage,
        this.totalOrdersPercentage,
        this.totalProductsPercentage,
        this.customerRatingPercentage,
      });

  Cards.fromJson(Map<String, dynamic> json) {
    todayRevenue = json['today_revenue']?.toString();
    totalOrders = json['total_orders']?.toString();
    totalProducts = json['total_products']?.toString();
    customerRating = json['customer_rating']?.toString();
    todayRevenuePercentage = json['today_revenue_percentage']?.toString();
    totalOrdersPercentage = json['total_orders_percentage']?.toString();
    totalProductsPercentage = json['total_products_percentage']?.toString();
    customerRatingPercentage = json['customer_rating_percentage']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['today_revenue'] = todayRevenue;
    data['total_orders'] = totalOrders;
    data['total_products'] = totalProducts;
    data['customer_rating'] = customerRating;
    data['customer_rating_percentage'] = customerRatingPercentage;
    data['total_products_percentage'] = totalProductsPercentage;
    data['total_orders_percentage'] = totalOrdersPercentage;
    data['today_revenue_percentage'] = todayRevenuePercentage;
    return data;
  }
}

class RevenueTrend {
  String? totalRevenue;
  String? percentageChange;
  String? average;
  String? peak;
  String? low;

  List<String>? labels;
  List<String>? revenue;
  List<int>? orderCount;

  RevenueTrend(
      {this.totalRevenue,
        this.percentageChange,
        this.average,
        this.peak,
        this.low,
        this.labels,
        this.revenue,
        this.orderCount,
      });

  RevenueTrend.fromJson(Map<String, dynamic> json) {
    totalRevenue = json['total_revenue']?.toString();
    percentageChange = json['percentage_change']?.toString();
    average = json['average']?.toString();
    peak = json['peak']?.toString();
    low = json['low']?.toString();
    if(json['labels'] != null) {
      labels = json['labels'].cast<String>();
    }else{
      labels = [];
    }
    if(json['revenue'] != null) {
      revenue = json['revenue'].cast<String>();
    }else{
      revenue = [];
    }
    if(json['order_count'] != null) {
      orderCount = json['order_count'].cast<int>();
    }else{
      orderCount = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_revenue'] = totalRevenue;
    data['percentage_change'] = percentageChange;
    data['average'] = average;
    data['peak'] = peak;
    data['low'] = low;
    data['labels'] = labels;
    data['revenue'] = revenue;
    data['order_count'] = orderCount;

    return data;
  }
}

class OrderStatusChart {
  String? totalOrders;
  OrderStatus? orderStatus;
  String? successRate;
  String? activeOrders;
  String? cancelRate;

  OrderStatusChart(
      {this.totalOrders,
        this.orderStatus,
        this.successRate,
        this.activeOrders,
        this.cancelRate});

  OrderStatusChart.fromJson(Map<String, dynamic> json) {
    totalOrders = json['total_orders']?.toString();
    orderStatus = json['order_status'] != null
        ? OrderStatus.fromJson(json['order_status'])
        : null;
    successRate = json['success_rate']?.toString();
    activeOrders = json['active_orders']?.toString();
    cancelRate = json['cancel_rate']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_orders'] = totalOrders;
    if (orderStatus != null) {
      data['order_status'] = orderStatus!.toJson();
    }
    data['success_rate'] = successRate;
    data['active_orders'] = activeOrders;
    data['cancel_rate'] = cancelRate;
    return data;
  }
}

class OrderStatus {
  Delivered? delivered;
  Delivered? preparing;
  Delivered? pending;
  Delivered? cancelled;

  OrderStatus({this.delivered, this.preparing, this.pending, this.cancelled});

  OrderStatus.fromJson(Map<String, dynamic> json) {
    delivered = json['Delivered'] != null
        ? Delivered.fromJson(json['Delivered'])
        : null;
    preparing = json['Preparing'] != null
        ? Delivered.fromJson(json['Preparing'])
        : null;
    pending = json['Pending'] != null
        ? Delivered.fromJson(json['Pending'])
        : null;
    cancelled = json['Cancelled'] != null
        ? Delivered.fromJson(json['Cancelled'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (delivered != null) {
      data['Delivered'] = delivered!.toJson();
    }
    if (preparing != null) {
      data['Preparing'] = preparing!.toJson();
    }
    if (pending != null) {
      data['Pending'] = pending!.toJson();
    }
    if (cancelled != null) {
      data['Cancelled'] = cancelled!.toJson();
    }
    return data;
  }
}

class Delivered {
  String? count;
  String? percent;

  Delivered({this.count, this.percent});

  Delivered.fromJson(Map<String, dynamic> json) {
    count = json['count']?.toString();
    percent = json['percent']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['percent'] = percent;
    return data;
  }
}

class RecentOrders {
  String? orderId;
  String? items;
  String? amount;
  String? status;

  RecentOrders({this.orderId, this.items, this.amount, this.status});

  RecentOrders.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id']?.toString();
    items = json['items']?.toString();
    amount = json['amount']?.toString();
    status = json['status']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['items'] = items;
    data['amount'] = amount;
    data['status'] = status;
    return data;
  }
}

class TopSellingProducts {
  String? productId;
  String? name;
  String? image;
  String? price;
  String? items;

  TopSellingProducts(
      {this.productId, this.name, this.image, this.price, this.items});

  TopSellingProducts.fromJson(Map<String, dynamic> json) {
    productId = json['product_id']?.toString();
    name = json['name']?.toString();
    image = json['image']?.toString();
    price = json['price']?.toString();
    items = json['items']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['name'] = name;
    data['image'] = image;
    data['price'] = price;
    data['items'] = items;
    return data;
  }
}

class Reviews {
  String? name;
  String? image;
  String? rating;
  String? review;

  Reviews({this.name, this.image, this.rating, this.review});

  Reviews.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
    image = json['image']?.toString();
    rating = json['rating']?.toString();
    review = json['review']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    data['rating'] = rating;
    data['review'] = review;
    return data;
  }
}

//
// class DashboardModel {
//   String? orderCount;
//   String?  productCount;
//   String?  reviewCount;
//   String?  customerCount;
//   List<TopProducts>? topProducts;
//   RxList<LatestOrders>? latestOrders;
//
//   DashboardModel(
//       {this.orderCount,
//         this.productCount,
//         this.reviewCount,
//         this.customerCount,
//         this.topProducts,
//         this.latestOrders});
//
//   DashboardModel.fromJson(Map<String, dynamic> json) {
//     orderCount = json['orderCount']?.toString();
//     productCount = json['productCount']?.toString();
//     reviewCount = json['reviewCount']?.toString();
//     customerCount = json['customerCount']?.toString();
//     if (json['topProducts'] != null) {
//       topProducts = <TopProducts>[];
//       json['topProducts'].forEach((v) {
//         topProducts!.add(TopProducts.fromJson(v));
//       });
//     }
//     if (json['latestOrders'] != null) {
//       latestOrders = <LatestOrders>[].obs;
//       json['latestOrders'].forEach((v) {
//         latestOrders!.add(LatestOrders.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['orderCount'] = orderCount;
//     data['productCount'] = productCount;
//     data['reviewCount'] = reviewCount;
//     data['customerCount'] = customerCount;
//     if (topProducts != null) {
//       data['topProducts'] = topProducts!.map((v) => v.toJson()).toList();
//     }
//     if (latestOrders != null) {
//       data['latestOrders'] = latestOrders!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class TopProducts {
//   String?  id;
//   String? title;
//   String?  userId;
//   String?  categoryId;
//   String? regularPrice;
//   String?  salePrice;
//   String? quanInStock;
//   String? description;
//   String? discount;
//   String?  cuisineType;
//   String?  rating;
//   String? image;
//   String? addimg;
//   List<AddOn>? addOn;
//   List<Extra>? extra;
//   String?  status;
//   String? createdAt;
//   String? updatedAt;
//   List<String>? urlAddimg;
//   String? urlImage;
//   List<AddOnWithNames>? addOnWithNames;
//
//   TopProducts(
//       {this.id,
//         this.title,
//         this.userId,
//         this.categoryId,
//         this.regularPrice,
//         this.salePrice,
//         this.quanInStock,
//         this.description,
//         this.discount,
//         this.cuisineType,
//         this.rating,
//         this.image,
//         this.addimg,
//         this.addOn,
//         this.extra,
//         this.status,
//         this.createdAt,
//         this.updatedAt,
//         this.urlAddimg,
//         this.urlImage,
//         this.addOnWithNames});
//
//   TopProducts.fromJson(Map<String, dynamic> json) {
//     id = json['id']?.toString();
//     title = json['title']?.toString();
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
//     addimg = json['addimg']?.toString();
//     if (json['add_on'] != null) {
//       addOn = <AddOn>[];
//       json['add_on'].forEach((v) {
//         addOn!.add(AddOn.fromJson(v));
//       });
//     }
//     if (json['extra'] != null) {
//       extra = <Extra>[];
//       json['extra'].forEach((v) {
//         extra!.add(Extra.fromJson(v));
//       });
//     }
//     status = json['status']?.toString();
//     createdAt = json['created_at']?.toString();
//     updatedAt = json['updated_at']?.toString();
//     urlAddimg = json['url_addimg'].cast<String>();
//     urlImage = json['url_image']?.toString();
//     if (json['add_on_with_names'] != null) {
//       addOnWithNames = <AddOnWithNames>[];
//       json['add_on_with_names'].forEach((v) {
//         addOnWithNames!.add(AddOnWithNames.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['title'] = title;
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
//     data['addimg'] = addimg;
//     if (addOn != null) {
//       data['add_on'] = addOn!.map((v) => v.toJson()).toList();
//     }
//     if (extra != null) {
//       data['extra'] = extra!.map((v) => v.toJson()).toList();
//     }
//     data['status'] = status;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['url_addimg'] = urlAddimg;
//     data['url_image'] = urlImage;
//     if (addOnWithNames != null) {
//       data['add_on_with_names'] =
//           addOnWithNames!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class AddOnWithNames {
//   String? id;
//   String? price;
//   String? name;
//
//   AddOnWithNames({this.id, this.price, this.name});
//
//   AddOnWithNames.fromJson(Map<String, dynamic> json) {
//     id = json['id']?.toString();
//     price = json['price']?.toString();
//     name = json['name']?.toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['price'] = price;
//     data['name'] = name;
//     return data;
//   }
// }
//
//
// class AddOn {
//   String? id;
//   String? price;
//
//   AddOn({this.id, this.price});
//
//   AddOn.fromJson(Map<String, dynamic> json) {
//     id = json['id']?.toString();
//     price = json['price']?.toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['price'] = price;
//     return data;
//   }
// }
//
// class Extra {
//   String? titleid;
//   List<Item>? item;
//   String? title;
//
//   Extra({this.titleid, this.item, this.title});
//
//   Extra.fromJson(Map<String, dynamic> json) {
//     titleid = json['titleid'];
//     if (json['item'] != null) {
//       item = <Item>[];
//       json['item'].forEach((v) {
//         item!.add(Item.fromJson(v));
//       });
//     }
//     title = json['title'];
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
// class LatestOrders {
//   String?  id;
//   String? orderId;
//   String?  customerId;
//   String? paymentMethod;
//   String?  addressId;
//   String? couponId;
//   String?  restaurantId;
//   String?  total;
//   String? status;
//   String? createdAt;
//   String? updatedAt;
//   List<DecodedAttribute>? decodedAttribute;
//
//   LatestOrders(
//       {this.id,
//         this.orderId,
//         this.customerId,
//         this.paymentMethod,
//         this.addressId,
//         this.couponId,
//         this.restaurantId,
//         this.total,
//         this.status,
//         this.createdAt,
//         this.updatedAt,
//         this.decodedAttribute});
//
//   LatestOrders.fromJson(Map<String, dynamic> json) {
//     id = json['id']?.toString();
//     orderId = json['order_id']?.toString();
//     customerId = json['customer_id']?.toString();
//     paymentMethod = json['payment_method']?.toString();
//     addressId = json['address_id']?.toString();
//     couponId = json['coupon_id']?.toString();
//     restaurantId = json['restaurant_id']?.toString();
//     total = json['total']?.toString();
//     status = json['status']?.toString();
//     createdAt = json['created_at']?.toString();
//     updatedAt = json['updated_at']?.toString();
//     if (json['decoded_attribute'] != null) {
//       decodedAttribute = <DecodedAttribute>[];
//       json['decoded_attribute'].forEach((v) {
//         decodedAttribute!.add(DecodedAttribute.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['order_id'] = orderId;
//     data['customer_id'] = customerId;
//     data['payment_method'] = paymentMethod;
//     data['address_id'] = addressId;
//     data['coupon_id'] = couponId;
//     data['restaurant_id'] = restaurantId;
//     data['total'] = total;
//     data['status'] = status;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     if (decodedAttribute != null) {
//       data['decoded_attribute'] =
//           decodedAttribute!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class DecodedAttribute {
//   String? productId;
//   String?  quantity;
//   String? price;
//   List<Addons>? addons;
//   List<Attribute>? attribute;
//   String? checked;
//   List<String>? addonName;
//   String? productName;
//   String? productImage;
//
//   DecodedAttribute(
//       {this.productId,
//         this.quantity,
//         this.price,
//         this.addons,
//         this.attribute,
//         this.checked,
//         this.addonName,
//         this.productName,
//         this.productImage});
//
//   DecodedAttribute.fromJson(Map<String, dynamic> json) {
//     productId = json['product_id']?.toString();
//     quantity = json['quantity']?.toString();
//     price = json['price']?.toString();
//     if (json['addons'] != null) {
//       addons = <Addons>[];
//       json['addons'].forEach((v) {
//         addons!.add(Addons.fromJson(v));
//       });
//     }
//     if (json['attribute'] != null) {
//       attribute = <Attribute>[];
//       json['attribute'].forEach((v) {
//         attribute!.add(Attribute.fromJson(v));
//       });
//     }
//     checked = json['checked']?.toString();
//     if (json['addon_name'] != null) {
//       addonName = json['addon_name'].cast<String>();
//     }
//     productName = json['product_name']?.toString();
//     productImage = json['product_image']?.toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['product_id'] = productId;
//     data['quantity'] = quantity;
//     data['price'] = price;
//     if (addons != null) {
//       data['addons'] = addons!.map((v) => v.toJson()).toList();
//     }
//     if (attribute != null) {
//       data['attribute'] = attribute!.map((v) => v.toJson()).toList();
//     }
//     data['checked'] = checked;
//     data['addon_name'] = addonName;
//     data['product_name'] = productName;
//     data['product_image'] = productImage;
//     return data;
//   }
// }
//
// class Addons {
//   String? id;
//   String? price;
//   String? name;
//
//   Addons({this.id, this.price, this.name});
//
//   Addons.fromJson(Map<String, dynamic> json) {
//     id = json['id']?.toString();
//     price = json['price']?.toString();
//     name = json['name']?.toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['price'] = price;
//     data['name'] = name;
//     return data;
//   }
// }
//
//
// class Attribute {
//   String? titleId;
//   ItemDetails? itemDetails;
//
//   Attribute({this.titleId, this.itemDetails});
//
//   Attribute.fromJson(Map<String, dynamic> json) {
//     titleId = json['title_id']?.toString();
//     itemDetails = json['item_details'] != null
//         ? ItemDetails.fromJson(json['item_details'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['title_id'] = titleId;
//     if (itemDetails != null) {
//       data['item_details'] = itemDetails!.toJson();
//     }
//     return data;
//   }
// }
//
// class ItemDetails {
//   String? itemId;
//   String? itemName;
//   String? itemPrice;
//
//   ItemDetails({this.itemId, this.itemName, this.itemPrice});
//
//   ItemDetails.fromJson(Map<String, dynamic> json) {
//     itemId = json['item_id']?.toString();
//     itemName = json['item_name'];
//     itemPrice = json['item_price']?.toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['item_id'] = itemId;
//     data['item_name'] = itemName;
//     data['item_price'] = itemPrice;
//     return data;
//   }
// }
