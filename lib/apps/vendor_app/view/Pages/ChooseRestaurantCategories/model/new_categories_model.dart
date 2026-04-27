class NewCategoriesModel {
  bool? status;
  String? message;

  NewCategoriesModel({
    this.status,
    this.message,
  });

  factory NewCategoriesModel.fromJson(Map<String, dynamic> json) {
    return NewCategoriesModel(
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
