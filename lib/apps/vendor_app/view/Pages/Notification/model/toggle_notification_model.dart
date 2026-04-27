class ToggleNotificationModel {
  bool? status;
  String? message;
  int? notificationStatus;
  int? emailNotificationStatus;

  ToggleNotificationModel(
      {this.status,
        this.message,
        this.notificationStatus,
        this.emailNotificationStatus});

  ToggleNotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    notificationStatus = json['notification_status'];
    emailNotificationStatus = json['email_notification_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['notification_status'] = notificationStatus;
    data['email_notification_status'] = emailNotificationStatus;
    return data;
  }
}
