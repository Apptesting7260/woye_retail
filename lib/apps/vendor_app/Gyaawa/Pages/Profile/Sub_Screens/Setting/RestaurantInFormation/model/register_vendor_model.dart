class RegisterVendorModel {
  bool? status;
  String? message;
  String? step;

  RegisterVendorModel({
    this.status,
    this.message,
    this.step,
  });

  factory RegisterVendorModel.fromJson(Map<String, dynamic> json) {
    return RegisterVendorModel(
      status: json['status'],
      message: json['message']?.toString(),
      step: json['step']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'step': step,
    };
  }
}
