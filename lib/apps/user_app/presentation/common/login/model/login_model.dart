class LoginModel {
  bool? status;
  String? token;
  String? message;
  String? step;
  String? type;
  String? logo;

  LoginModel(
      {this.status, this.token, this.message, this.step, this.type, this.logo});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    message = json['message'];
    step = json['step'];
    type = json['type'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['token'] = this.token;
    data['message'] = this.message;
    data['step'] = this.step;
    data['type'] = this.type;
    data['logo'] = this.logo;
    return data;
  }
}
