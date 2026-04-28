class SignUpResponseModel {
  bool? status;
  String? message;
  SignUpData? data;

  SignUpResponseModel({this.status, this.message, this.data});

  SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
    data = json['data'] != null ? SignUpData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class SignUpData {
  String? userId;
  String? email;
  String? token;
  String? vendorId;

  SignUpData({
    this.userId,
    this.email,
    this.token,
    this.vendorId,
  });

  SignUpData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id']?.toString();
    email = json['email']?.toString();
    token = json['token']?.toString();
    vendorId = json['vendor_id']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['email'] = email;
    data['token'] = token;
    data['vendor_id'] = vendorId;
    return data;
  }
}