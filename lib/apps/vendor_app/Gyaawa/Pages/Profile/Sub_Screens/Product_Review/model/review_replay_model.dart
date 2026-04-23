class ReviewReplyModel {
  bool? status;
  String? message;

  ReviewReplyModel({this.status, this.message});

  ReviewReplyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
