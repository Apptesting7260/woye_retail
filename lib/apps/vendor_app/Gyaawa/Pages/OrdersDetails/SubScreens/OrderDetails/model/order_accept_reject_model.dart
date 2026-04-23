class OrderAcceptAndRejectModel {
  bool? status;
  String? message;
  Map<String, List<String>>? errors;

  OrderAcceptAndRejectModel({
    this.status,
    this.message,
    this.errors,
  });

  OrderAcceptAndRejectModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();

    if (json['errors'] != null) {
      errors = Map<String, List<String>>.from(
        json['errors'].map(
              (key, value) => MapEntry(
            key,
            List<String>.from(value),
          ),
        ),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['errors'] = errors;
    return data;
  }
}
