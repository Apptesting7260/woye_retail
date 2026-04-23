class UpdatePasswordModel {
  bool? status;
  String? message;

  UpdatePasswordModel({this.status, this.message});

  factory UpdatePasswordModel.fromJson(Map<String, dynamic> json) {
    return UpdatePasswordModel(
      status: json["status"],
      message: json["message"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
    };
  }
}
