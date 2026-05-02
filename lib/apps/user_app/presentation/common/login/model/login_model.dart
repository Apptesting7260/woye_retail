class LoginModel {
  bool? status;
  String? token;
  String? message;
  String? step;
  String? type;
  String? logo;

  String? action;
  String? email;

  LoginModel({
    this.status,
    this.token,
    this.message,
    this.step,
    this.type,
    this.logo,
    this.action,
    this.email,
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    message = json['message'];
    step = json['step'];
    type = json['type'];
    logo = json['logo'];

    action = json['action'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['token'] = token;
    data['message'] = message;
    data['step'] = step;
    data['type'] = type;
    data['logo'] = logo;

    data['action'] = action;
    data['email'] = email;

    return data;
  }
}