class CreateSupportModel {
  bool? status;
  String? message;

  CreateSupportModel({this.status, this.message});

  CreateSupportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
