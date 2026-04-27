class BankDetailsModel {
  bool? status;
  String? message;
  List<Data>? data;

  BankDetailsModel({this.status, this.message, this.data});

  BankDetailsModel.fromJson(Map<String, dynamic> json) {
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
  String? provider;
  String? phoneCode;
  String? phone;
  String? acName;
  String? merchantId;
  String? bankname;
  String? acHolder;
  String? acNo;
  String? acType;
  String? bankCode;

  Data(
      {this.id,
        this.provider,
        this.phoneCode,
        this.phone,
        this.acName,
        this.merchantId,
        this.bankname,
        this.acHolder,
        this.acNo,
        this.acType,
        this.bankCode,
      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    provider = json['provider']?.toString();
    phoneCode = json['phone_code']?.toString();
    phone = json['phone']?.toString();
    acName = json['ac_name']?.toString();
    merchantId = json['merchant_id']?.toString();
    bankname = json['bankname']?.toString();
    acHolder = json['ac_holder']?.toString();
    acNo = json['ac_no']?.toString();
    acType = json['ac_type']?.toString();
    bankCode = json['bank_code']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['provider'] = provider;
    data['phone_code'] = phoneCode;
    data['phone'] = phone;
    data['ac_name'] = acName;
    data['merchant_id'] = merchantId;
    data['bankname'] = bankname;
    data['ac_holder'] = acHolder;
    data['ac_no'] = acNo;
    data['ac_type'] = acType;
    data['bank_code'] = bankCode;
    return data;
  }
}
