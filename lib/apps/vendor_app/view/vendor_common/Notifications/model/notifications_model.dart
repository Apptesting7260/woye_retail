class NotificationsModel {
  bool? status;
  List<Notification>? notification;
  String? notificationCount;

  NotificationsModel({this.status, this.notification});

  NotificationsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['notification'] != null) {
      notification = <Notification>[];
      json['notification'].forEach((v) {
        notification!.add(Notification.fromJson(v));
      });
    }
    notificationCount = json['notificationCount']?.toString();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (notification != null) {
      data['notification'] = notification!.map((v) => v.toJson()).toList();
    }
    data['notificationCount'] = notificationCount;
    return data;
  }
}

class Notification {
  String? id;
  String? vendorId;
  String? type;
  String? title;
  String? message;
  String? seen;
  String? createdAt;
  String? updatedAt;

  Notification(
      {this.id,
        this.vendorId,
        this.type,
        this.title,
        this.message,
        this.seen,
        this.createdAt,
        this.updatedAt});

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    vendorId = json['vendor_id']?.toString();
    type = json['type']?.toString();
    title = json['title']?.toString();
    message = json['message']?.toString();
    seen = json['seen']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vendor_id'] = vendorId;
    data['type'] = type;
    data['title'] = title;
    data['message'] = message;
    data['seen'] = seen;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
