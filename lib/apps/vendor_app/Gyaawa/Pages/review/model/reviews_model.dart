class ReviewsModel {
  bool? status;
  String? message;
  String? overallRating;
  String? totalReviews;
  String? reviewsThisWeek;
  String? responseRate;
  String? responseRateThisWeek;
  String? pendingResponses;
  RatingBreakdown? ratingBreakdown;
  RatingTrend? ratingTrend;
  List<Reviews>? reviews;

  ReviewsModel(
      {this.status,
        this.message,
        this.overallRating,
        this.totalReviews,
        this.reviewsThisWeek,
        this.responseRate,
        this.responseRateThisWeek,
        this.pendingResponses,
        this.ratingBreakdown,
        this.ratingTrend,
        this.reviews});

  ReviewsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
    overallRating = json['overall_rating']?.toString();
    totalReviews = json['total_reviews']?.toString();
    reviewsThisWeek = json['reviews_this_week']?.toString();
    responseRate = json['response_rate']?.toString();
    responseRateThisWeek = json['response_rate_this_week']?.toString();
    pendingResponses = json['pending_responses']?.toString();
    ratingBreakdown = json['rating_breakdown'] != null
        ? RatingBreakdown.fromJson(json['rating_breakdown'])
        : null;
    ratingTrend = json['rating_trend'] != null
        ? RatingTrend.fromJson(json['rating_trend'])
        : null;
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(Reviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['overall_rating'] = overallRating;
    data['total_reviews'] = totalReviews;
    data['reviews_this_week'] = reviewsThisWeek;
    data['response_rate'] = responseRate;
    data['response_rate_this_week'] = responseRateThisWeek;
    data['pending_responses'] = pendingResponses;
    if (ratingBreakdown != null) {
      data['rating_breakdown'] = ratingBreakdown!.toJson();
    }
    if (ratingTrend != null) {
      data['rating_trend'] = ratingTrend!.toJson();
    }
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RatingBreakdown {
  String? i1;
  String? i2;
  String? i3;
  String? i4;
  String? i5;

  RatingBreakdown({this.i1, this.i2, this.i3, this.i4, this.i5});

  RatingBreakdown.fromJson(Map<String, dynamic> json) {
    i1 = json['1']?.toString();
    i2 = json['2']?.toString();
    i3 = json['3']?.toString();
    i4 = json['4']?.toString();
    i5 = json['5']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['1'] = i1;
    data['2'] = i2;
    data['3'] = i3;
    data['4'] = i4;
    data['5'] = i5;
    return data;
  }
}

class RatingTrend {
  ThisWeek? thisWeek;
  LastWeek? lastWeek;
  ThisWeek? thisMonth;

  RatingTrend({this.thisWeek, this.lastWeek, this.thisMonth});

  RatingTrend.fromJson(Map<String, dynamic> json) {
    thisWeek = json['this_week'] != null
        ? ThisWeek.fromJson(json['this_week'])
        : null;
    lastWeek = json['last_week'] != null
        ? LastWeek.fromJson(json['last_week'])
        : null;
    thisMonth = json['this_month'] != null
        ? ThisWeek.fromJson(json['this_month'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (thisWeek != null) {
      data['this_week'] = thisWeek!.toJson();
    }
    if (lastWeek != null) {
      data['last_week'] = lastWeek!.toJson();
    }
    if (thisMonth != null) {
      data['this_month'] = thisMonth!.toJson();
    }
    return data;
  }
}

class ThisWeek {
  String? rating;
  String? count;

  ThisWeek({this.rating, this.count});

  ThisWeek.fromJson(Map<String, dynamic> json) {
    rating = json['rating']?.toString();
    count = json['count']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rating'] = rating;
    data['count'] = count;
    return data;
  }
}

class LastWeek {
  String? rating;
  String? count;

  LastWeek({this.rating, this.count});

  LastWeek.fromJson(Map<String, dynamic> json) {
    rating = json['rating']?.toString();
    count = json['count']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rating'] = rating;
    data['count'] = count;
    return data;
  }
}

class Reviews {
  String? id;
  String? orderId;
  String? customerName;
  String? customerImage;
  String? verified;
  String? rating;
  String? review;
  String? createdAt;
  String? response;
  String? responseAt;
  String? responderName;

  Reviews(
      {this.id,
        this.orderId,
        this.customerName,
        this.customerImage,
        this.verified,
        this.rating,
        this.review,
        this.createdAt,
        this.response,
        this.responseAt,
        this.responderName});

  Reviews.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    orderId = json['order_id']?.toString();
    customerName = json['customer_name']?.toString();
    customerImage = json['customer_image']?.toString();
    verified = json['verified']?.toString();
    rating = json['rating']?.toString();
    review = json['review']?.toString();
    createdAt = json['created_at']?.toString();
    response = json['response']?.toString();
    responseAt = json['response_at']?.toString();
    responderName = json['responder_name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['customer_name'] = customerName;
    data['customer_image'] = customerImage;
    data['verified'] = verified;
    data['rating'] = rating;
    data['review'] = review;
    data['created_at'] = createdAt;
    data['response'] = response;
    data['response_at'] = responseAt;
    data['responder_name'] = responderName;
    return data;
  }
}
