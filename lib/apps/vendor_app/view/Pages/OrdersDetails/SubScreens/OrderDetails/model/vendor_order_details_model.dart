class SingleOrderDetailsModel {
  bool? status;
  Order? order;

  SingleOrderDetailsModel({this.status, this.order});

  SingleOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (order != null) {
      data['order'] = order!.toJson();
    }
    return data;
  }
}

class Order {
  String? id;
  String? orderId;
  String? customerId;
  String? paymentMethod;
  String? addressId;
  String? couponId;
  String? restaurantId;
  String? total;
  String? status;
  String? courierTip;
  String? deliverySoon;
  String? deliveryNotes;
  String? createdAt;
  String? updatedAt;
  List<DecodedAttribute>? decodedAttribute;
  Address? address;
  Review? reviews;
  Customer? customer;

  Order({
    this.id,
    this.orderId,
    this.customerId,
    this.paymentMethod,
    this.addressId,
    this.couponId,
    this.restaurantId,
    this.total,
    this.status,
    this.courierTip,
    this.deliverySoon,
    this.deliveryNotes,
    this.createdAt,
    this.updatedAt,
    this.decodedAttribute,
    this.address,
    this.reviews,
    this.customer,
  });

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    orderId = json['order_id']?.toString();
    customerId = json['customer_id']?.toString();
    paymentMethod = json['payment_method']?.toString();
    addressId = json['address_id']?.toString();
    couponId = json['coupon_id']?.toString();
    restaurantId = json['restaurant_id']?.toString();
    total = json['total']?.toString();
    status = json['status']?.toString();
    courierTip = json['courier_tip']?.toString();
    deliverySoon = json['delivery_soon']?.toString();
    deliveryNotes = json['delivery_notes']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    if (json['decoded_attribute'] != null) {
      decodedAttribute = <DecodedAttribute>[];
      json['decoded_attribute'].forEach((v) {
        decodedAttribute!.add(DecodedAttribute.fromJson(v));
      });
    }
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
    reviews = json['reviews'] != null ? Review.fromJson(json['reviews']) : null;
    customer = json['customer'] != null ? Customer.fromJson(json['customer']) : null;
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
    data['courier_tip'] = courierTip;
    data['delivery_soon'] = deliverySoon;
    data['delivery_notes'] = deliveryNotes;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (decodedAttribute != null) {
      data['decoded_attribute'] =
          decodedAttribute!.map((v) => v.toJson()).toList();
    }
    if (address != null) {
      data['address'] = address!.toJson();
    }
    if (reviews != null) {
      data['review'] = reviews!.toJson();
    }
    if (customer != null) {
      data['customer'] = customer!.toJson();
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
  List<String>? addonName;
  String? productName;
  String? productImage;

  DecodedAttribute(
      {this.productId,
      this.quantity,
      this.price,
      this.addons,
      this.attribute,
      this.checked,
      this.addonName,
      this.productName,
      this.productImage});

  DecodedAttribute.fromJson(Map<String, dynamic> json) {
    productId = json['product_id']?.toString();
    quantity = json['quantity']?.toString();
    price = json['price'];
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
    if(json['addon_name'] != null){
      addonName = json['addon_name'].cast<String>();
    }
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
    data['addon_name'] = addonName;
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

class Address {
  String? id;
  String? userId;
  String? fullName;
  String? phoneNumber;
  String? countryCode;
  String? houseDetails;
  String? address;
  String? addressType;
  String? isDefault;
  String? latitude;
  String? longitude;
  String? deliveryInstruction;
  String? createdAt;
  String? updatedAt;

  Address(
      {this.id,
      this.userId,
      this.fullName,
      this.phoneNumber,
      this.countryCode,
      this.houseDetails,
      this.address,
      this.addressType,
      this.isDefault,
      this.latitude,
      this.longitude,
      this.deliveryInstruction,
      this.createdAt,
      this.updatedAt});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    userId = json['user_id']?.toString();
    fullName = json['full_name']?.toString();
    phoneNumber = json['phone_number']?.toString();
    countryCode = json['country_code']?.toString();
    houseDetails = json['house_details']?.toString();
    address = json['address']?.toString();
    addressType = json['address_type']?.toString();
    isDefault = json['is_default']?.toString();
    latitude = json['latitude']?.toString();
    longitude = json['longitude']?.toString();
    deliveryInstruction = json['delivery_instruction']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['full_name'] = fullName;
    data['phone_number'] = phoneNumber;
    data['country_code'] = countryCode;
    data['house_details'] = houseDetails;
    data['address'] = address;
    data['address_type'] = addressType;
    data['is_default'] = isDefault;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['delivery_instruction'] = deliveryInstruction;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Customer {
  String? id;
  String? firstName;
  String? lastName;
  String? imageUrl;

  Customer({
    this.id,
    this.firstName,
    this.lastName,
    this.imageUrl,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id']?.toString(),
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      imageUrl: json['image_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'image_url': imageUrl,
    };
  }
}

class Review {
  String? id;
  String? orderId;
  String? userId;
  String? vendorId;
  String? type;
  String? rating;
  String? review;
  String? reply;
  String? createdAt;
  String? updatedAt;

  Review(
      {this.id,
        this.orderId,
        this.userId,
        this.vendorId,
        this.type,
        this.rating,
        this.review,
        this.reply,
        this.createdAt,
        this.updatedAt});

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    orderId = json['order_id']?.toString();
    userId = json['user_id']?.toString();
    vendorId = json['vendor_id']?.toString();
    type = json['type']?.toString();
    rating = json['rating']?.toString();
    review = json['review']?.toString();
    reply = json['reply']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['user_id'] = userId;
    data['vendor_id'] = vendorId;
    data['type'] = type;
    data['rating'] = rating;
    data['review'] = review;
    data['reply'] = reply;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
