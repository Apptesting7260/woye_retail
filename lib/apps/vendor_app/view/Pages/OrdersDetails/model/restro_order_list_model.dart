// class OrderListModel {
//   int? orderCount;
//   int? orderDeliveredCount;
//   int? orderPendingCount;
//   int? orderCancelledCount;
//   List<OrderAll>? orderAll;
//   List<OrderPending>? orderPending;
//   List<Null>? orderInProcess;
//   List<OrderDelivered>? orderDelivered;
//   List<Null>? orderCancelled;
//
//   OrderListModel(
//       {this.orderCount,
//         this.orderDeliveredCount,
//         this.orderPendingCount,
//         this.orderCancelledCount,
//         this.orderAll,
//         this.orderPending,
//         this.orderInProcess,
//         this.orderDelivered,
//         this.orderCancelled});
//
//   OrderListModel.fromJson(Map<String, dynamic> json) {
//     orderCount = json['orderCount'];
//     orderDeliveredCount = json['orderDeliveredCount'];
//     orderPendingCount = json['orderPendingCount'];
//     orderCancelledCount = json['orderCancelledCount'];
//     if (json['orderAll'] != null) {
//       orderAll = <OrderAll>[];
//       json['orderAll'].forEach((v) {
//         orderAll!.add(new OrderAll.fromJson(v));
//       });
//     }
//     if (json['orderPending'] != null) {
//       orderPending = <OrderPending>[];
//       json['orderPending'].forEach((v) {
//         orderPending!.add(new OrderPending.fromJson(v));
//       });
//     }
//     if (json['orderInProcess'] != null) {
//       orderInProcess = <Null>[];
//       json['orderInProcess'].forEach((v) {
//         orderInProcess!.add(new Null.fromJson(v));
//       });
//     }
//     if (json['orderDelivered'] != null) {
//       orderDelivered = <OrderDelivered>[];
//       json['orderDelivered'].forEach((v) {
//         orderDelivered!.add(new OrderDelivered.fromJson(v));
//       });
//     }
//     if (json['orderCancelled'] != null) {
//       orderCancelled = <Null>[];
//       json['orderCancelled'].forEach((v) {
//         orderCancelled!.add(new Null.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['orderCount'] = this.orderCount;
//     data['orderDeliveredCount'] = this.orderDeliveredCount;
//     data['orderPendingCount'] = this.orderPendingCount;
//     data['orderCancelledCount'] = this.orderCancelledCount;
//     if (this.orderAll != null) {
//       data['orderAll'] = this.orderAll!.map((v) => v.toJson()).toList();
//     }
//     if (this.orderPending != null) {
//       data['orderPending'] = this.orderPending!.map((v) => v.toJson()).toList();
//     }
//     if (this.orderInProcess != null) {
//       data['orderInProcess'] =
//           this.orderInProcess!.map((v) => v.toJson()).toList();
//     }
//     if (this.orderDelivered != null) {
//       data['orderDelivered'] =
//           this.orderDelivered!.map((v) => v.toJson()).toList();
//     }
//     if (this.orderCancelled != null) {
//       data['orderCancelled'] =
//           this.orderCancelled!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class OrderAll {
//   int? id;
//   String? orderId;
//   int? customerId;
//   String? paymentMethod;
//   int? addressId;
//   Null? couponId;
//   int? restaurantId;
//   int? total;
//   String? status;
//   String? createdAt;
//   String? updatedAt;
//   List<DecodedAttribute>? decodedAttribute;
//
//   OrderAll(
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
//   OrderAll.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     orderId = json['order_id'];
//     customerId = json['customer_id'];
//     paymentMethod = json['payment_method'];
//     addressId = json['address_id'];
//     couponId = json['coupon_id'];
//     restaurantId = json['restaurant_id'];
//     total = json['total'];
//     status = json['status'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     if (json['decoded_attribute'] != null) {
//       decodedAttribute = <DecodedAttribute>[];
//       json['decoded_attribute'].forEach((v) {
//         decodedAttribute!.add(new DecodedAttribute.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['order_id'] = this.orderId;
//     data['customer_id'] = this.customerId;
//     data['payment_method'] = this.paymentMethod;
//     data['address_id'] = this.addressId;
//     data['coupon_id'] = this.couponId;
//     data['restaurant_id'] = this.restaurantId;
//     data['total'] = this.total;
//     data['status'] = this.status;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     if (this.decodedAttribute != null) {
//       data['decoded_attribute'] =
//           this.decodedAttribute!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class DecodedAttribute {
//   String? productId;
//   int? quantity;
//   String? price;
//   List<Addons>? addons;
//   List<Attribute>? attribute;
//   String? checked;
//   List<Null>? addonName;
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
//     productId = json['product_id'];
//     quantity = json['quantity'];
//     price = json['price'];
//     if (json['addons'] != null) {
//       addons = <Addons>[];
//       json['addons'].forEach((v) {
//         addons!.add(new Addons.fromJson(v));
//       });
//     }
//     if (json['attribute'] != null) {
//       attribute = <Attribute>[];
//       json['attribute'].forEach((v) {
//         attribute!.add(new Attribute.fromJson(v));
//       });
//     }
//     checked = json['checked'];
//     if (json['addon_name'] != null) {
//       addonName = <Null>[];
//       json['addon_name'].forEach((v) {
//         addonName!.add(new Null.fromJson(v));
//       });
//     }
//     productName = json['product_name'];
//     productImage = json['product_image'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['product_id'] = this.productId;
//     data['quantity'] = this.quantity;
//     data['price'] = this.price;
//     if (this.addons != null) {
//       data['addons'] = this.addons!.map((v) => v.toJson()).toList();
//     }
//     if (this.attribute != null) {
//       data['attribute'] = this.attribute!.map((v) => v.toJson()).toList();
//     }
//     data['checked'] = this.checked;
//     if (this.addonName != null) {
//       data['addon_name'] = this.addonName!.map((v) => v.toJson()).toList();
//     }
//     data['product_name'] = this.productName;
//     data['product_image'] = this.productImage;
//     return data;
//   }
// }
//
// class Addons {
//   String? id;
//   String? price;
//
//   Addons({this.id, this.price});
//
//   Addons.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     price = json['price'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['price'] = this.price;
//     return data;
//   }
// }
//
// class Attribute {
//   int? titleId;
//   ItemDetails? itemDetails;
//
//   Attribute({this.titleId, this.itemDetails});
//
//   Attribute.fromJson(Map<String, dynamic> json) {
//     titleId = json['title_id'];
//     itemDetails = json['item_details'] != null
//         ? new ItemDetails.fromJson(json['item_details'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['title_id'] = this.titleId;
//     if (this.itemDetails != null) {
//       data['item_details'] = this.itemDetails!.toJson();
//     }
//     return data;
//   }
// }
//
// class ItemDetails {
//   int? itemId;
//   String? itemName;
//   int? itemPrice;
//
//   ItemDetails({this.itemId, this.itemName, this.itemPrice});
//
//   ItemDetails.fromJson(Map<String, dynamic> json) {
//     itemId = json['item_id'];
//     itemName = json['item_name'];
//     itemPrice = json['item_price'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['item_id'] = this.itemId;
//     data['item_name'] = this.itemName;
//     data['item_price'] = this.itemPrice;
//     return data;
//   }
// }
//
// class DecodedAttribute {
//   String? productId;
//   int? quantity;
//   String? price;
//   List<Addons>? addons;
//   List<Attribute>? attribute;
//   String? checked;
//   List<Null>? addonName;
//   String? productName;
//   Null? productImage;
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
//     productId = json['product_id'];
//     quantity = json['quantity'];
//     price = json['price'];
//     if (json['addons'] != null) {
//       addons = <Addons>[];
//       json['addons'].forEach((v) {
//         addons!.add(new Addons.fromJson(v));
//       });
//     }
//     if (json['attribute'] != null) {
//       attribute = <Attribute>[];
//       json['attribute'].forEach((v) {
//         attribute!.add(new Attribute.fromJson(v));
//       });
//     }
//     checked = json['checked'];
//     if (json['addon_name'] != null) {
//       addonName = <Null>[];
//       json['addon_name'].forEach((v) {
//         addonName!.add(new Null.fromJson(v));
//       });
//     }
//     productName = json['product_name'];
//     productImage = json['product_image'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['product_id'] = this.productId;
//     data['quantity'] = this.quantity;
//     data['price'] = this.price;
//     if (this.addons != null) {
//       data['addons'] = this.addons!.map((v) => v.toJson()).toList();
//     }
//     if (this.attribute != null) {
//       data['attribute'] = this.attribute!.map((v) => v.toJson()).toList();
//     }
//     data['checked'] = this.checked;
//     if (this.addonName != null) {
//       data['addon_name'] = this.addonName!.map((v) => v.toJson()).toList();
//     }
//     data['product_name'] = this.productName;
//     data['product_image'] = this.productImage;
//     return data;
//   }
// }


class OrdersModel {
  bool? status;
  Orders? orders;

  OrdersModel({this.status, this.orders});

  OrdersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    orders =
    json['orders'] != null ? Orders.fromJson(json['orders']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (orders != null) {
      data['orders'] = orders!.toJson();
    }
    return data;
  }
}

class Orders {
  Cards? cards;
  List<RecentOrders>? recentOrders;

  Orders({this.cards, this.recentOrders});

  Orders.fromJson(Map<String, dynamic> json) {
    cards = json['cards'] != null ? Cards.fromJson(json['cards']) : null;
    if (json['recent_orders'] != null) {
      recentOrders = <RecentOrders>[];
      json['recent_orders'].forEach((v) {
        recentOrders!.add(RecentOrders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cards != null) {
      data['cards'] = cards!.toJson();
    }
    if (recentOrders != null) {
      data['recent_orders'] =
          recentOrders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cards {
  TodayOrders? todayOrders;
  PendingOrders? pendingOrders;
  PendingOrders? completedOrders;
  AvgPrepTime? avgPrepTime;

  Cards(
      {this.todayOrders,
        this.pendingOrders,
        this.completedOrders,
        this.avgPrepTime});

  Cards.fromJson(Map<String, dynamic> json) {
    todayOrders = json['today_orders'] != null
        ? TodayOrders.fromJson(json['today_orders'])
        : null;
    pendingOrders = json['pending_orders'] != null
        ? PendingOrders.fromJson(json['pending_orders'])
        : null;
    completedOrders = json['completed_orders'] != null
        ? PendingOrders.fromJson(json['completed_orders'])
        : null;
    avgPrepTime = json['avg_prep_time'] != null
        ? AvgPrepTime.fromJson(json['avg_prep_time'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (todayOrders != null) {
      data['today_orders'] = todayOrders!.toJson();
    }
    if (pendingOrders != null) {
      data['pending_orders'] = pendingOrders!.toJson();
    }
    if (completedOrders != null) {
      data['completed_orders'] = completedOrders!.toJson();
    }
    if (avgPrepTime != null) {
      data['avg_prep_time'] = avgPrepTime!.toJson();
    }
    return data;
  }
}

class TodayOrders {
  String? count;
  String? percentage;

  TodayOrders({this.count, this.percentage});

  TodayOrders.fromJson(Map<String, dynamic> json) {
    count = json['count']?.toString();
    percentage = json['percentage']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['percentage'] = percentage;
    return data;
  }
}

class PendingOrders {
  String? count;
  String? message;

  PendingOrders({this.count, this.message});

  PendingOrders.fromJson(Map<String, dynamic> json) {
    count = json['count']?.toString();
    message = json['message']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['message'] = message;
    return data;
  }
}

class AvgPrepTime {
  String? time;
  String? change;

  AvgPrepTime({this.time, this.change});

  AvgPrepTime.fromJson(Map<String, dynamic> json) {
    time = json['time']?.toString();
    change = json['change']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['change'] = change;
    return data;
  }
}

class RecentOrders {
  String? id;
  String? orderId;
  String? mainOrderId;
  String? deliverySoon;
  String? customerName;
  String? status;
  String? total;
  String? createdAt;
  String? orderType;
  List<OrderItems>? orderItems;

  RecentOrders(
      {this.id,
        this.orderId,
        this.deliverySoon,
        this.mainOrderId,
        this.customerName,
        this.status,
        this.total,
        this.createdAt,
        this.orderType,
        this.orderItems});

  RecentOrders.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    orderId = json['order_id']?.toString();
    deliverySoon = json['delivery_soon']?.toString();
    mainOrderId = json['main_order_id']?.toString();
    customerName = json['customer_name']?.toString();
    status = json['status']?.toString();
    orderType = json['order_type']?.toString();
    total = json['total']?.toString();
    createdAt = json['created_at']?.toString();
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['delivery_soon'] = deliverySoon;
    data['order_type'] = orderType;
    data['main_order_id'] = mainOrderId;
    data['customer_name'] = customerName;
    data['status'] = status;
    data['total'] = total;
    data['created_at'] = createdAt;
    if (orderItems != null) {
      data['order_items'] = orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PrescriptionBy {
  String? name;
  String? license;
  String? deaNumber;
  String? phone;

  PrescriptionBy({this.name, this.license, this.deaNumber, this.phone});

  factory PrescriptionBy.fromJson(Map<String, dynamic> json) {
    return PrescriptionBy(
      name: json['name']?.toString(),
      license: json['license']?.toString(),
      deaNumber: json['dea_number']?.toString(),
      phone: json['phone']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'license': license,
    'dea_number': deaNumber,
    'phone': phone,
  };
}

class OrderItems {
  String? productId;
  String? productName;
  String? quantity;
  String? price;
  String? totalPrice;
  String? deliveryCharge;
  String? prescription;
  String? ndcNumber;
  String? category;
  String? prescriptionStatus;
  // PrescriptionBy? prescriptionBy;
  List<PrescriptionBy>? prescriptionBy;
  String? insuranceCopay;
  String? tip;
  String? dob;
  String? insurance;
  String? policy;
  String? presubscriptionVerification;
  String? insuranceVerification;
  List<Addons>? addons;
  List<Attribute>? attribute;
  String? productTotalprice;

  OrderItems(
      {this.productId,
        this.productName,
        this.quantity,
        this.price,
        this.totalPrice,
        this.prescription,
        this.ndcNumber,
        this.category,
        this.prescriptionStatus,
        this.prescriptionBy,
        this.insuranceCopay,
        this.tip,
        this.dob,
        this.insurance,
        this.policy,
        this.presubscriptionVerification,
        this.insuranceVerification,
        this.deliveryCharge,
        this.addons,
        this.attribute,
        this.productTotalprice,
      });

  OrderItems.fromJson(Map<String, dynamic> json) {
    productId = json['product_id']?.toString();
    productName = json['product_name']?.toString();
    quantity = json['quantity']?.toString();
    price = json['price']?.toString();
    totalPrice = json['total_price']?.toString();
    deliveryCharge = json['delivery_charge']?.toString();
    prescription = json['prescription']?.toString();
    ndcNumber = json['ndc_number']?.toString();
    category = json['category']?.toString();
    insuranceCopay = json['insurance_copay'].toString();
    tip = json['tip'].toString();
    dob = json['dob'].toString();
    insurance = json['insurance'].toString();
    policy = json['policy'].toString();
    presubscriptionVerification = json['presubscription_verification'].toString();
    insuranceVerification = json['insurance_verification'].toString();
    prescriptionStatus = json['prescription_status']?.toString();
    if (json['addons'] != null) {
      addons = <Addons>[];
      json['addons'].forEach((v) {
        addons!.add(Addons.fromJson(v));
      });
    }
    if (json['attribute'] != null) {
      attribute = <Attribute>[];
      json['attribute'].forEach((v) {
        attribute!.add(Attribute.fromJson(v));
      });
    }
    // prescriptionBy = json['prescription_by'] != null
    //     ? PrescriptionBy.fromJson(json['prescription_by'])
    //     : null;
    if (json['prescription_by'] != null) {
      prescriptionBy = <PrescriptionBy>[];
      json['prescription_by'].forEach((v) {
        prescriptionBy!.add(PrescriptionBy.fromJson(v));
      });
    }
    productTotalprice = json['product_totalprice']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['quantity'] = quantity;
    data['price'] = price;
    data['total_price'] = totalPrice;
    data['delivery_charge'] = deliveryCharge;
    data['prescription'] = prescription;
    data['ndcnumber'] = ndcNumber;
    data['category'] = category;
    data['insurance_copay'] = insuranceCopay;
    data['tip'] = tip;
    data['dob'] = dob;
    data['policy'] = policy;

    data['insurance'] = insurance;
    data['prescription_status'] = prescriptionStatus;
    data['presubscription_verification'] = presubscriptionVerification;
    data['insurance_verification'] = insuranceVerification;
    // if (prescriptionBy != null) {
    //   data['prescription_by'] = prescriptionBy!.toJson();
    if (prescriptionBy != null) {
      data['prescription_by'] =
          prescriptionBy!.map((v) => v.toJson()).toList();
    }
    if (addons != null) {
      data['addons'] = addons!.map((v) => v.toJson()).toList();
    }
    if (attribute != null) {
      data['attribute'] = attribute!.map((v) => v.toJson()).toList();
    }
    data['product_totalprice'] = productTotalprice;
    return data;
  }
}


class Attribute {
  String? titleId;
  Choices? choices;

  Attribute({this.titleId, this.choices});

  Attribute.fromJson(Map<String, dynamic> json) {
    titleId = json['title_id']?.toString();
    choices =
    json['choices'] != null ? Choices.fromJson(json['choices']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['title_id'] = titleId;
    if (choices != null) {
      data['choices'] = choices!.toJson();
    }
    return data;
  }
}

class Choices {
  String? optionId;
  String? name;
  String? price;
  String? quantity;
  String? totalPrice;

  Choices({this.optionId, this.name, this.price,this.totalPrice,this.quantity});

  Choices.fromJson(Map<String, dynamic> json) {
    optionId = json['option_id']?.toString();
    name = json['name']?.toString();
    price = json['price']?.toString();
    totalPrice  = json['total_price']?.toString();
    quantity = json['quantity']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['option_id'] = optionId;
    data['name'] = name;
    data['price'] = price;
    data['total_price'] =  totalPrice;
    data['quantity'] = quantity;
    return data;
  }
}

class Addons {
  String? id;
  String? name;
  String? price;
  String? quantity;
  String? totalPrice;

  Addons({this.id, this.name, this.price,this.totalPrice,this.quantity});

  Addons.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    price = json['price']?.toString();
    totalPrice  = json['total_price']?.toString();
    quantity = json['quantity']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['total_price'] =  totalPrice;
    data['quantity'] = quantity;
    return data;
  }
}