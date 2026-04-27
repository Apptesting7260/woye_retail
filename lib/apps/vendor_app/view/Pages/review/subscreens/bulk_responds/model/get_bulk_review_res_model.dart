class GetBulkReviewResModel {
  bool? status;
  String? message;
  List<PendingReviews>? pendingReviews;

  GetBulkReviewResModel({this.status, this.message, this.pendingReviews});

  GetBulkReviewResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
    if (json['pending_reviews'] != null) {
      pendingReviews = <PendingReviews>[];
      json['pending_reviews'].forEach((v) {
        pendingReviews!.add(PendingReviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (pendingReviews != null) {
      data['pending_reviews'] =
          pendingReviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PendingReviews {
  String? id;
  String? orderId;
  String? customerName;
  String? review;
  String? rating;
  String? createdAt;

  PendingReviews(
      {this.id,
        this.orderId,
        this.customerName,
        this.review,
        this.rating,
        this.createdAt});

  PendingReviews.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    orderId = json['order_id']?.toString();
    customerName = json['customer_name']?.toString();
    review = json['review']?.toString();
    rating = json['rating']?.toString();
    createdAt = json['created_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['customer_name'] = customerName;
    data['review'] = review;
    data['rating'] = rating;
    data['created_at'] = createdAt;
    return data;
  }
}
