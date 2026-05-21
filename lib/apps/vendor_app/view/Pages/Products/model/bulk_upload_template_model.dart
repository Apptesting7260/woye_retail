class BulkUploadTemplateModel {
  bool? status;
  String? message;
  String? url;

  BulkUploadTemplateModel({this.status, this.message, this.url});

  BulkUploadTemplateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
    url = json['url']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['url'] = url;
    return data;
  }
}
