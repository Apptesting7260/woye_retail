class GetPagesModel {
  bool? status;
  String? message;
  List<Faqs>? faqs;
  String? privacyPolicy;
  String? termsAndConditions;
  String? vendorAgreement;

  GetPagesModel(
      {this.status, this.faqs, this.privacyPolicy, this.termsAndConditions, this.vendorAgreement,});

  GetPagesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
    vendorAgreement = json['vendorAgreement']?.toString();

    if (json['faqs'] != null) {
      faqs = <Faqs>[];
      json['faqs'].forEach((v) {
        faqs!.add(Faqs.fromJson(v));
      });
    }
    privacyPolicy = json['privacyPolicy']?.toString();
    termsAndConditions = json['termsAndConditions']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (faqs != null) {
      data['faqs'] = faqs!.map((v) => v.toJson()).toList();
    }
    data['privacyPolicy'] = privacyPolicy;
    data['termsAndConditions'] = termsAndConditions;
    data['vendorAgreement'] = vendorAgreement;

    return data;
  }
}

class Faqs {
  String? category;
  List<Content>? content;

  Faqs({this.category, this.content});

  Faqs.fromJson(Map<String, dynamic> json) {
    category = json['category']?.toString();
    if (json['content'] != null) {
      content = <Content>[];
      json['content'].forEach((v) {
        content!.add(Content.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    if (content != null) {
      data['content'] = content!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Content {
  String? que;
  String? ans;
  String? status;
  String? updatedAt;

  Content({this.que, this.ans, this.status, this.updatedAt});

  Content.fromJson(Map<String, dynamic> json) {
    que = json['que']?.toString();
    ans = json['ans']?.toString();
    status = json['status']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['que'] = que;
    data['ans'] = ans;
    data['status'] = status;
    data['updated_at'] = updatedAt;
    return data;
  }
}
