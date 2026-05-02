class ChangePasswordModel {
  bool? status;
  String? message;

  ChangePasswordModel({this.status, this.message});

  ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
class ForgotOtpVerifyModel {
  bool? status;
  String? message;

  ForgotOtpVerifyModel({this.status, this.message});

  ForgotOtpVerifyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}