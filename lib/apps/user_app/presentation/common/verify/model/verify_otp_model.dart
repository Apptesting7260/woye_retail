class VerifyOtpModel {
  bool? status;
  String? message;
  String? step;
  String? token;
  String? type;

  VerifyOtpModel({
    this.status,
    this.message,
    this.step,
    this.token,
    this.type,
  });

  VerifyOtpModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
    step = json['step']?.toString();
    token = json['token']?.toString();
    type = json['type']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['step'] = step;
    data['token'] = token;
    data['type'] = type;
    return data;
  }
}