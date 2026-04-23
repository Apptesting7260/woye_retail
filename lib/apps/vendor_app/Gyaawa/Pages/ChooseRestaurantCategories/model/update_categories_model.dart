class UpdateCategoriesModel {
  bool? status;
  String? message;
  String? step;
  String? role;

  UpdateCategoriesModel({
    this.status,
    this.message,
    this.step,
    this.role,
  });

  factory UpdateCategoriesModel.fromJson(Map<String, dynamic> json) {
    return UpdateCategoriesModel(
      status: json['status'],
      message: json['message']?.toString(),
      step: json['step']?.toString(),
      role: json['role']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'step': step,
      'role': role,
    };
  }
}
