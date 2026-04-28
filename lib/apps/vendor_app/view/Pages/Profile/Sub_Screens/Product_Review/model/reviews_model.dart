class OrderReviewsModel {
  bool? status;
  List<OrderReviews>? orderReviews;

  OrderReviewsModel({this.status, this.orderReviews});

  OrderReviewsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['orderReviews'] != null) {
      orderReviews = <OrderReviews>[];
      json['orderReviews'].forEach((v) {
        orderReviews!.add(OrderReviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (orderReviews != null) {
      data['orderReviews'] = orderReviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderReviews {
  String? id;
  String? orderId;
  String? userId;
  String? vendorId;
  String? type;
  String? rating;
  String? reply;
  String? review;
  String? createdAt;
  String? updatedAt;
  User? user;
  Order? order;

  OrderReviews(
      {this.id,
      this.orderId,
      this.userId,
      this.vendorId,
      this.type,
      this.rating,
      this.reply,
      this.review,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.order});

  OrderReviews.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    orderId = json['order_id']?.toString();
    userId = json['user_id']?.toString();
    vendorId = json['vendor_id']?.toString();
    type = json['type']?.toString();
    rating = json['rating']?.toString();
    reply = json['reply']?.toString();
    review = json['review']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['user_id'] = userId;
    data['vendor_id'] = vendorId;
    data['type'] = type;
    data['rating'] = rating;
    data['reply'] = reply;
    data['review'] = review;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (order != null) {
      data['order'] = order!.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? imageUrl;

  User({this.id, this.firstName, this.lastName, this.imageUrl});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    firstName = json['first_name']?.toString();
    lastName = json['last_name']?.toString();
    imageUrl = json['image_url']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['image_url'] = imageUrl;
    return data;
  }
}

class Order {
  String? id;
  String? orderId;
  String? createdAt;
  String? vendorName;

  Order({
    this.id,
    this.orderId,
    this.createdAt,
    this.vendorName,
  });

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    orderId = json['order_id']?.toString();
    createdAt = json['created_at']?.toString();
    vendorName = json['vendor_name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['created_at'] = createdAt;
    data['vendor_name'] = vendorName;
    return data;
  }
}
