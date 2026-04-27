class GetPayOutModel {
  bool? status;
  String? message;
  Data? data;

  GetPayOutModel({this.status, this.data,this.message});

  GetPayOutModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? availableBalance;
  String? minWithdrawAmount;
  List<PaymentMethods>? paymentMethods;

  Data({this.availableBalance, this.minWithdrawAmount, this.paymentMethods});

  Data.fromJson(Map<String, dynamic> json) {
    availableBalance = json['available_balance']?.toString();
    minWithdrawAmount = json['min_withdraw_amount']?.toString();
    if (json['payment_methods'] != null) {
      paymentMethods = <PaymentMethods>[];
      json['payment_methods'].forEach((v) {
        paymentMethods!.add(PaymentMethods.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['available_balance'] = availableBalance;
    data['min_withdraw_amount'] = minWithdrawAmount;
    if (paymentMethods != null) {
      data['payment_methods'] =
          paymentMethods!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaymentMethods {
  String? type;
  String? id;
  String? name;

  PaymentMethods({this.type, this.id, this.name});

  PaymentMethods.fromJson(Map<String, dynamic> json) {
    type = json['type']?.toString();
    id = json['id']?.toString();
    name = json['name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['type'] = type;
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
