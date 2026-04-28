class BankListModel {
  bool? status;
  String? message;
  List<PayStackBank>? paystackBank;

  BankListModel({this.status, this.paystackBank});

  BankListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
    if (json['paystackBank'] != null) {
      paystackBank = <PayStackBank>[];
      json['paystackBank'].forEach((v) {
        paystackBank!.add(new PayStackBank.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (paystackBank != null) {
      data['paystackBank'] = paystackBank!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PayStackBank {
  String? id;
  String? name;
  String? slug;
  String? code;
  String? longcode;
  String? gateway;
  bool? payWithBank;
  bool? supportsTransfer;
  bool? availableForDirectDebit;
  bool? active;
  String? country;
  String? currency;
  String? type;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;

  PayStackBank(
      {this.id,
        this.name,
        this.slug,
        this.code,
        this.longcode,
        this.gateway,
        this.payWithBank,
        this.supportsTransfer,
        this.availableForDirectDebit,
        this.active,
        this.country,
        this.currency,
        this.type,
        this.isDeleted,
        this.createdAt,
        this.updatedAt});

  PayStackBank.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    slug = json['slug']?.toString();
    code = json['code']?.toString();
    longcode = json['longcode']?.toString();
    gateway = json['gateway']?.toString();
    payWithBank = json['pay_with_bank'];
    supportsTransfer = json['supports_transfer'];
    availableForDirectDebit = json['available_for_direct_debit'];
    active = json['active'];
    country = json['country']?.toString();
    currency = json['currency']?.toString();
    type = json['type']?.toString();
    isDeleted = json['is_deleted'];
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['code'] = code;
    data['longcode'] = longcode;
    data['gateway'] = gateway;
    data['pay_with_bank'] = payWithBank;
    data['supports_transfer'] = supportsTransfer;
    data['available_for_direct_debit'] = availableForDirectDebit;
    data['active'] = active;
    data['country'] = country;
    data['currency'] = currency;
    data['type'] = type;
    data['is_deleted'] = isDeleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
