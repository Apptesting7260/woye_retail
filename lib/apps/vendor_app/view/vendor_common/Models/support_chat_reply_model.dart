class SupportChatReplyModel {
  bool? status;
  String? message;

  SupportChatReplyModel({this.status, this.message});

  SupportChatReplyModel.fromJson(Map<String, dynamic> json) {
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
