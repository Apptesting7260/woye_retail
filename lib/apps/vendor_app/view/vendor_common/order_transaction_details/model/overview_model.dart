class OverviewModel {
  bool? status;
  String? message;
  List<Data>? data;

  OverviewModel({this.status, this.message, this.data});

  OverviewModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? mainOrderId;
  String? orderId;
  String? method;
  String? total;
  String? paymentStatus;
  String? paymentType;
  String? formattedCreatedAt;
  String? decodedAttribute;
  String? vendorName;
  String? addressDetails;
  String? discountedTotal;
  String? vendor;

  Data(
      {this.id,
        this.mainOrderId,
        this.orderId,
        this.method,
        this.total,
        this.paymentStatus,
        this.paymentType,
        this.formattedCreatedAt,
        this.decodedAttribute,
        this.vendorName,
        this.addressDetails,
        this.discountedTotal,
        this.vendor});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    mainOrderId = json['main_order_id']?.toString();
    method = json['method']?.toString();
    orderId = json['order_id']?.toString();
    total = json['total']?.toString();
    paymentStatus = json['payment_status']?.toString();
    paymentType = json['payment_type']?.toString();
    formattedCreatedAt = json['formatted_created_at']?.toString();
    decodedAttribute = json['decoded_attribute']?.toString();
    vendorName = json['vendor_name']?.toString();
    addressDetails = json['address_details']?.toString();
    discountedTotal = json['discounted_total']?.toString();
    vendor = json['vendor']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['main_order_id'] = mainOrderId;
    data['order_id'] = orderId;
    data['method'] = method;
    data['total'] = total;
    data['payment_status'] = paymentStatus;
    data['payment_type'] = paymentType;
    data['formatted_created_at'] = formattedCreatedAt;
    data['decoded_attribute'] = decodedAttribute;
    data['vendor_name'] = vendorName;
    data['address_details'] = addressDetails;
    data['discounted_total'] = discountedTotal;
    data['vendor'] = vendor;
    return data;
  }
}
