class FaqPrivacyTcModel {
  bool? status;
  List<Faqs>? faqs;
  String? privacyPolicy;
  String? termsAndConditions;

  FaqPrivacyTcModel(
      {this.status, this.faqs, this.privacyPolicy, this.termsAndConditions});

  FaqPrivacyTcModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['faqs'] != null) {
      faqs = <Faqs>[];
      json['faqs'].forEach((v) {
        faqs!.add(Faqs.fromJson(v));
      });
    }
    privacyPolicy = json['privacyPolicy'];
    termsAndConditions = json['termsAndConditions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (faqs != null) {
      data['faqs'] = faqs!.map((v) => v.toJson()).toList();
    }
    data['privacyPolicy'] = privacyPolicy;
    data['termsAndConditions'] = termsAndConditions;
    return data;
  }
}

class Faqs {
  String? que;
  String? ans;

  Faqs({this.que, this.ans});

  Faqs.fromJson(Map<String, dynamic> json) {
    que = json['que'];
    ans = json['ans'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['que'] = que;
    data['ans'] = ans;
    return data;
  }
}
