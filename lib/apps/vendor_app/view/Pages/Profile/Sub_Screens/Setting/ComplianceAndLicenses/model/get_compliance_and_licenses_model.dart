class GetComplianceAndLicensesModel {
  bool? status;
  String? message;
  Summary? summary;
  List<DocumentsList>? documentsList;
  List<DocumentsCheck>? documentsCheck;

  GetComplianceAndLicensesModel(
      {this.status,
        this.message,
        this.summary,
        this.documentsList,
        this.documentsCheck});

  GetComplianceAndLicensesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
    summary =
    json['summary'] != null ? Summary.fromJson(json['summary']) : null;
    if (json['documents_list'] != null) {
      documentsList = <DocumentsList>[];
      json['documents_list'].forEach((v) {
        documentsList!.add(DocumentsList.fromJson(v));
      });
    }
    if (json['documents_check'] != null) {
      documentsCheck = <DocumentsCheck>[];
      json['documents_check'].forEach((v) {
        documentsCheck!.add(DocumentsCheck.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (summary != null) {
      data['summary'] = summary!.toJson();
    }
    if (documentsList != null) {
      data['documents_list'] =
          documentsList!.map((v) => v.toJson()).toList();
    }
    if (documentsCheck != null) {
      data['documents_check'] =
          documentsCheck!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Summary {
  String? approved;
  String? pending;
  String? expired;
  String? total;

  Summary({this.approved, this.pending, this.expired, this.total});

  Summary.fromJson(Map<String, dynamic> json) {
    approved = json['approved']?.toString();
    pending = json['pending']?.toString();
    expired = json['expiresoon']?.toString();
    total = json['total']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['approved'] = approved;
    data['pending'] = pending;
    data['expiresoon'] = expired;
    data['total'] = total;
    return data;
  }
}

class DocumentsList {
  String? name;
  String? documentNumber;
  String? issuingAuthority;
  String? issueDate;
  String? expiryDate;
  String? uploadDate;
  String? status;
  String? image;
  String? additionalNotes;

  DocumentsList(
      {this.name,
        this.documentNumber,
        this.issuingAuthority,
        this.issueDate,
        this.expiryDate,
        this.uploadDate,
        this.status,
        this.image,
        this.additionalNotes});

  DocumentsList.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
    documentNumber = json['document_number']?.toString();
    issuingAuthority = json['issuing_authority']?.toString();
    issueDate = json['issue_date']?.toString();
    expiryDate = json['expiry_date']?.toString();
    uploadDate = json['upload_date']?.toString();
    status = json['status']?.toString();
    image = json['image']?.toString();
    additionalNotes = json['additional_notes']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['document_number'] = documentNumber;
    data['issuing_authority'] = issuingAuthority;
    data['issue_date'] = issueDate;
    data['expiry_date'] = expiryDate;
    data['upload_date'] = uploadDate;
    data['status'] = status;
    data['image'] = image;
    data['additional_notes'] = additionalNotes;
    return data;
  }
}

class DocumentsCheck {
  String? name;
  String? status;

  DocumentsCheck({this.name, this.status});

  DocumentsCheck.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['status'] = status;
    return data;
  }
}
