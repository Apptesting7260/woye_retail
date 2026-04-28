class DocumentDetailsModel {
  bool? status;
  String? message;
  Document? document;

  DocumentDetailsModel({this.status, this.document, this.message});

  DocumentDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
    document = json['document'] != null
        ? Document.fromJson(json['document'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (document != null) {
      data['document'] = document!.toJson();
    }
    return data;
  }
}

class Document {
  String? documentNumber;
  String? issuingAuthority;
  String? issueDate;
  String? expiryDate;
  String? uploadDate;
  String? status;
  String? image;
  String? additionalNotes;
  String? approveDate;
  FileInfo? fileInfo;

  Document(
      {this.documentNumber,
        this.issuingAuthority,
        this.issueDate,
        this.expiryDate,
        this.uploadDate,
        this.status,
        this.image,
        this.additionalNotes,
        this.approveDate,
        this.fileInfo});

  Document.fromJson(Map<String, dynamic> json) {
    documentNumber = json['document_number']?.toString();
    issuingAuthority = json['issuing_authority']?.toString();
    issueDate = json['issue_date']?.toString();
    expiryDate = json['expiry_date']?.toString();
    uploadDate = json['upload_date']?.toString();
    status = json['status']?.toString();
    image = json['image']?.toString();
    additionalNotes = json['additional_notes']?.toString();
    approveDate = json['approve_date']?.toString();
    fileInfo = json['file_info'] != null
        ? FileInfo.fromJson(json['file_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['document_number'] = documentNumber;
    data['issuing_authority'] = issuingAuthority;
    data['issue_date'] = issueDate;
    data['expiry_date'] = expiryDate;
    data['upload_date'] = uploadDate;
    data['status'] = status;
    data['image'] = image;
    data['additional_notes'] = additionalNotes;
    data['approve_date'] = approveDate;
    if (fileInfo != null) {
      data['file_info'] = fileInfo!.toJson();
    }
    return data;
  }
}

class FileInfo {
  String? fileName;
  String? fileSize;
  String? downloadUrl;

  FileInfo({this.fileName, this.fileSize, this.downloadUrl});

  FileInfo.fromJson(Map<String, dynamic> json) {
    fileName = json['file_name']?.toString();
    fileSize = json['file_size']?.toString();
    downloadUrl = json['download_url']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['file_name'] = fileName;
    data['file_size'] = fileSize;
    data['download_url'] = downloadUrl;
    return data;
  }
}
