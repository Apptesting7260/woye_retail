class ExportTransModel {
  bool? status;
  String? message;
  String? downloadUrl;

  ExportTransModel({this.status, this.message, this.downloadUrl});

  ExportTransModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    downloadUrl = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['url'] = downloadUrl;
    return data;
  }
}
