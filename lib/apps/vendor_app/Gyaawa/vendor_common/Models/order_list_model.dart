
class OrderListModel {
  String? orderCount;
  String? orderDeliveredCount;
  String? orderPendingCount;
  String? orderCancelledCount;
  List<OrderAll>? orderAll;
  List<OrderAll>? orderPending;
  List<OrderAll>? orderInProcess;
  List<OrderAll>? orderDelivered;
  List<OrderAll>? orderCancelled;

  OrderListModel({
    this.orderCount,
    this.orderDeliveredCount,
    this.orderPendingCount,
    this.orderCancelledCount,
    this.orderAll,
    this.orderPending,
    this.orderInProcess,
    this.orderDelivered,
    this.orderCancelled,
  });

  OrderListModel.fromJson(Map<String, dynamic> json) {
    orderCount = json['orderCount']?.toString();
    orderDeliveredCount = json['orderDeliveredCount']?.toString();
    orderPendingCount = json['orderPendingCount']?.toString();
    orderCancelledCount = json['orderCancelledCount']?.toString();
    if (json['orderAll'] != null) {
      orderAll = <OrderAll>[];
      json['orderAll'].forEach((v) {
        orderAll!.add(OrderAll.fromJson(v));
      });
    } if (json['orderPending'] != null) {
      orderPending = <OrderAll>[];
      json['orderPending'].forEach((v) {
        orderPending!.add(OrderAll.fromJson(v));
      });
    }
    if (json['orderInProcess'] != null) {
      orderInProcess = <OrderAll>[];
      json['orderInProcess'].forEach((v) {
        orderInProcess!.add(OrderAll.fromJson(v));
      });
    }
    if (json['orderDelivered'] != null) {
      orderDelivered = <OrderAll>[];
      json['orderDelivered'].forEach((v) {
        orderDelivered!.add(OrderAll.fromJson(v));
      });
    }
    if (json['orderCancelled'] != null) {
      orderCancelled = <OrderAll>[];
      json['orderCancelled'].forEach((v) {
        orderCancelled!.add(OrderAll.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderCount'] = orderCount;
    data['orderDeliveredCount'] = orderDeliveredCount;
    data['orderPendingCount'] = orderPendingCount;
    data['orderCancelledCount'] = orderCancelledCount;
    if (orderAll != null) {
      data['orderAll'] = orderAll!.map((v) => v.toJson()).toList();
    }
    if (orderPending != null) {
      data['orderPending'] = orderPending!.map((v) => v.toJson()).toList();
    }
    if (orderInProcess != null) {
      data['orderInProcess'] = orderInProcess!.map((v) => v.toJson()).toList();
    }
    if (orderDelivered != null) {
      data['orderDelivered'] = orderDelivered!.map((v) => v.toJson()).toList();
    }
    if (orderCancelled != null) {
      data['orderCancelled'] = orderCancelled!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderCancelled {
  String? id;
  String? orderId;
  String? customerId;
  String? paymentMethod;
  String? addressId;
  String? couponId;
  String? restaurantId;
  String? total;
  String? status;
  String? createdAt;
  String? updatedAt;
  List<DecodedAttribute>? decodedAttribute;

  OrderCancelled({
    this.id,
    this.orderId,
    this.customerId,
    this.paymentMethod,
    this.addressId,
    this.couponId,
    this.restaurantId,
    this.total,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.decodedAttribute,
  });

  OrderCancelled.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    orderId = json['order_id']?.toString();
    customerId = json['customer_id']?.toString();
    paymentMethod = json['payment_method']?.toString();
    addressId = json['address_id']?.toString();
    couponId = json['coupon_id']?.toString();
    restaurantId = json['restaurant_id']?.toString();
    total = json['total']?.toString();
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    if (json['decoded_attribute'] != null) {
      decodedAttribute = <DecodedAttribute>[];
      json['decoded_attribute'].forEach((v) {
        decodedAttribute!.add(DecodedAttribute.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['customer_id'] = customerId;
    data['payment_method'] = paymentMethod;
    data['address_id'] = addressId;
    data['coupon_id'] = couponId;
    data['restaurant_id'] = restaurantId;
    data['total'] = total;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (decodedAttribute != null) {
      data['decoded_attribute'] =
          decodedAttribute!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DecodedAttribute {
  String? productId;
  String? quantity;
  String? price;
  List<Addons>? addons;
  List<Attribute>? attribute;
  String? checked;
  String? productName;
  String? productImage;

  DecodedAttribute({
    this.productId,
    this.quantity,
    this.price,
    this.addons,
    this.attribute,
    this.checked,
    this.productName,
    this.productImage,
  });

  DecodedAttribute.fromJson(Map<String, dynamic> json) {
    productId = json['product_id']?.toString();
    quantity = json['quantity']?.toString();
    price = json['price']?.toString();
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
    checked = json['checked']?.toString();
    productName = json['product_name']?.toString();
    productImage = json['product_image']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['quantity'] = quantity;
    data['price'] = price;
    if (addons != null) {
      data['addons'] = addons!.map((v) => v.toJson()).toList();
    }
    if (attribute != null) {
      data['attribute'] = attribute!.map((v) => v.toJson()).toList();
    }
    data['checked'] = checked;
    data['product_name'] = productName;
    data['product_image'] = productImage;
    return data;
  }
}

class Addons {
  String? id;
  String? price;
  String? name;

  Addons({this.id, this.price, this.name});

  Addons.fromJson(Map<String, dynamic> json) {
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

class Attribute {
  String? titleId;
  ItemDetails? itemDetails;

  Attribute({this.titleId, this.itemDetails});

  Attribute.fromJson(Map<String, dynamic> json) {
    titleId = json['title_id']?.toString();
    itemDetails = json['item_details'] != null
        ? ItemDetails.fromJson(json['item_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title_id'] = titleId;
    if (itemDetails != null) {
      data['item_details'] = itemDetails!.toJson();
    }
    return data;
  }
}

class ItemDetails {
  String? itemId;
  String? itemName;
  String? itemPrice;

  ItemDetails({this.itemId, this.itemName, this.itemPrice});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id']?.toString();
    itemName = json['item_name']?.toString();
    itemPrice = json['item_price']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_id'] = itemId;
    data['item_name'] = itemName;
    data['item_price'] = itemPrice;
    return data;
  }
}

class OrderInProcess {
  String? id;
  String? orderId;
  String? customerId;
  String? paymentMethod;
  String? addressId;
  dynamic couponId;
  String? restaurantId;
  String? total;
  String? status;
  String? createdAt;
  String? updatedAt;
  List<DecodedAttribute>? decodedAttribute;

  OrderInProcess({
    this.id,
    this.orderId,
    this.customerId,
    this.paymentMethod,
    this.addressId,
    this.couponId,
    this.restaurantId,
    this.total,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.decodedAttribute,
  });

  OrderInProcess.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    orderId = json['order_id']?.toString();
    customerId = json['customer_id']?.toString();
    paymentMethod = json['payment_method']?.toString();
    addressId = json['address_id']?.toString();
    couponId = json['coupon_id']?.toString();
    restaurantId = json['restaurant_id']?.toString();
    total = json['total']?.toString();
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    if (json['decoded_attribute'] != null) {
      decodedAttribute = <DecodedAttribute>[];
      json['decoded_attribute'].forEach((v) {
        decodedAttribute!.add(DecodedAttribute.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['customer_id'] = customerId;
    data['payment_method'] = paymentMethod;
    data['address_id'] = addressId;
    data['coupon_id'] = couponId;
    data['restaurant_id'] = restaurantId;
    data['total'] = total;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (decodedAttribute != null) {
      data['decoded_attribute'] =
          decodedAttribute!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderAll {
  String? id;
  String? orderId;
  String? customerId;
  String? paymentMethod;
  String? addressId;
  dynamic couponId;
  String? restaurantId;
  String? total;
  String? status;
  String? createdAt;
  String? updatedAt;
  List<DecodedAttribute>? decodedAttribute;

  OrderAll({
    this.id,
    this.orderId,
    this.customerId,
    this.paymentMethod,
    this.addressId,
    this.couponId,
    this.restaurantId,
    this.total,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.decodedAttribute,
  });

  OrderAll.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    orderId = json['order_id']?.toString();
    customerId = json['customer_id']?.toString();
    paymentMethod = json['payment_method']?.toString();
    addressId = json['address_id']?.toString();
    couponId = json['coupon_id']?.toString();
    restaurantId = json['restaurant_id']?.toString();
    total = json['total']?.toString();
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    if (json['decoded_attribute'] != null) {
      decodedAttribute = <DecodedAttribute>[];
      json['decoded_attribute'].forEach((v) {
        decodedAttribute!.add(DecodedAttribute.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['customer_id'] = customerId;
    data['payment_method'] = paymentMethod;
    data['address_id'] = addressId;
    data['coupon_id'] = couponId;
    data['restaurant_id'] = restaurantId;
    data['total'] = total;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (decodedAttribute != null) {
      data['decoded_attribute'] =
          decodedAttribute!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderDelivered {
  String? id;
  String? orderId;
  String? customerId;
  String? paymentMethod;
  String? addressId;
  dynamic couponId;
  String? restaurantId;
  String? total;
  String? status;
  String? createdAt;
  String? updatedAt;
  List<DecodedAttribute>? decodedAttribute;

  OrderDelivered({
    this.id,
    this.orderId,
    this.customerId,
    this.paymentMethod,
    this.addressId,
    this.couponId,
    this.restaurantId,
    this.total,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.decodedAttribute,
  });

  OrderDelivered.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    orderId = json['order_id']?.toString();
    customerId = json['customer_id']?.toString();
    paymentMethod = json['payment_method']?.toString();
    addressId = json['address_id']?.toString();
    couponId = json['coupon_id']?.toString();
    restaurantId = json['restaurant_id']?.toString();
    total = json['total']?.toString();
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    if (json['decoded_attribute'] != null) {
      decodedAttribute = <DecodedAttribute>[];
      json['decoded_attribute'].forEach((v) {
        decodedAttribute!.add(DecodedAttribute.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['customer_id'] = customerId;
    data['payment_method'] = paymentMethod;
    data['address_id'] = addressId;
    data['coupon_id'] = couponId;
    data['restaurant_id'] = restaurantId;
    data['total'] = total;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (decodedAttribute != null) {
      data['decoded_attribute'] =
          decodedAttribute!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderPending {
  String? id;
  String? orderId;
  String? customerId;
  String? paymentMethod;
  String? addressId;
  dynamic couponId;
  String? restaurantId;
  String? total;
  String? status;
  String? createdAt;
  String? updatedAt;
  List<DecodedAttribute>? decodedAttribute;

  OrderPending({
    this.id,
    this.orderId,
    this.customerId,
    this.paymentMethod,
    this.addressId,
    this.couponId,
    this.restaurantId,
    this.total,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.decodedAttribute,
  });

  OrderPending.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    orderId = json['order_id']?.toString();
    customerId = json['customer_id']?.toString();
    paymentMethod = json['payment_method']?.toString();
    addressId = json['address_id']?.toString();
    couponId = json['coupon_id']?.toString();
    restaurantId = json['restaurant_id']?.toString();
    total = json['total']?.toString();
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    if (json['decoded_attribute'] != null) {
      decodedAttribute = <DecodedAttribute>[];
      json['decoded_attribute'].forEach((v) {
        decodedAttribute!.add(DecodedAttribute.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['customer_id'] = customerId;
    data['payment_method'] = paymentMethod;
    data['address_id'] = addressId;
    data['coupon_id'] = couponId;
    data['restaurant_id'] = restaurantId;
    data['total'] = total;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (decodedAttribute != null) {
      data['decoded_attribute'] =
          decodedAttribute!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
