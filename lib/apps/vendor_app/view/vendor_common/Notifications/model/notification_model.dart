class NotificationModel {
  bool? status;
  List<Notifications>? notifications;
  Counts? counts;

  NotificationModel({this.status, this.notifications, this.counts});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['notifications'] != null) {
      notifications = <Notifications>[];
      json['notifications'].forEach((v) {
        notifications!.add(Notifications.fromJson(v));
      });
    }
    counts =
    json['counts'] != null ? Counts.fromJson(json['counts']) : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (notifications != null) {
      data['notifications'] =
          notifications!.map((v) => v.toJson()).toList();
    }
    if (counts != null) {
      data['counts'] = counts!.toJson();
    }
    return data;
  }
}
class Template {
  final String name;
  final String subject;
  final String message;

  Template({required this.name, required this.subject, required this.message});

  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
      name: json['name'],
      subject: json['subject'],
      message: json['message'],
    );
  }
}


class Notifications {
  String? id;
  String? subject;
  String? message;
  String? category;
  String? priority;
  String? isRead;
  String? createdAt;

  Notifications(
      {this.id,
        this.subject,
        this.message,
        this.category,
        this.priority,
        this.isRead,
        this.createdAt});

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    subject = json['subject']?.toString();
    message = json['message']?.toString();
    category = json['category']?.toString();
    priority = json['priority']?.toString();
    isRead = json['is_read']?.toString();
    createdAt = json['created_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['subject'] = subject;
    data['message'] = message;
    data['category'] = category;
    data['priority'] = priority;
    data['is_read'] = isRead;
    data['created_at'] = createdAt;
    return data;
  }
}
//
// class Counts {
//   String? all;
//   String? unread;
//   String? orders;
//   String? reviews;
//   String? system;
//
//   Counts({this.all, this.unread, this.orders, this.reviews, this.system});
//
//   Counts.fromJson(Map<String, dynamic> json) {
//     all = json['all']?.toString();
//     unread = json['unread']?.toString();
//     orders = json['orders']?.toString();
//     reviews = json['reviews']?.toString();
//     system = json['system']?.toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['all'] = all;
//     data['unread'] = unread;
//     data['orders'] = orders;
//     data['reviews'] = reviews;
//     data['system'] = system;
//     return data;
//   }
class Counts {
  Map<String, String> data = {};

  Counts();

  Counts.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      data[key] = value?.toString() ?? "0";
    });
  }

  Map<String, dynamic> toJson() {
    return data;
  }
}
