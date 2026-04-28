class CommonResponseModel {
  bool? status;
  String? message;
  String? error;
  List<String>? errors;
  List<Map<String, dynamic>>? templates; // Must match API key

  CommonResponseModel({this.status, this.message, this.error, this.errors, this.templates});

  CommonResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
    error = json['error']?.toString();

    // Initialize errors
    if (json['errors'] != null && json['errors'] is List) {
      errors = List<String>.from(json['errors']);
    } else {
      errors = [];
    }

    // Initialize templates
    if (json['templates'] != null && json['templates'] is List) {
      templates = List<Map<String, dynamic>>.from(json['templates']);
    } else {
      templates = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['errors'] = errors;
    data['templates'] = templates;
    return data;
  }
}
