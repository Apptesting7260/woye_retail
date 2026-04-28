class CommonExportModel {
  bool? status;
  String? message;
  String? downloadUrl;
  String? fileName;
  String? format;

  CommonExportModel(
      {this.status,
        this.message,
        this.downloadUrl,
        this.fileName,
        this.format});

  CommonExportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
    downloadUrl = json['download_url']?.toString();
    fileName = json['file_name']?.toString();
    format = json['format']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['download_url'] = downloadUrl;
    data['file_name'] = fileName;
    data['format'] = format;
    return data;
  }
}
