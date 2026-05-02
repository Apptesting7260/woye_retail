class TwoFactorModel {
  bool? status;
  String? token;
  String? message;
  String? step;
  String? logo;

  TwoFactorModel({
    this.status,
    this.token,
    this.message,
    this.step,
    this.logo,
  });

  TwoFactorModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    message = json['message'];
    step = json['step'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "token": token,
      "message": message,
      "step": step,
      "logo": logo,
    };
  }
}
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>2FA Resend OTP Model<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
class TwoFactorResendModel {
  bool? status;
  String? message;
  String? email;

  TwoFactorResendModel({
    this.status,
    this.message,
    this.email,
  });

  TwoFactorResendModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "email": email,
    };
  }
}