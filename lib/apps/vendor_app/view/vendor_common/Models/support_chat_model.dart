class SupportChatModel {
  bool? status;
  List<Chat>? chat;
  List<Admin>? admin;
  Vendor? vendor;
  String? ticketStatus;

  SupportChatModel({this.status, this.chat, this.admin, this.vendor});

  SupportChatModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    ticketStatus = json['ticketStatus']?.toString();
    if (json['chat'] != null) {
      chat = <Chat>[];
      json['chat'].forEach((v) {
        chat!.add(Chat.fromJson(v));
      });
    }
    if (json['admin'] != null) {
      admin = <Admin>[];
      json['admin'].forEach((v) {
        admin!.add(Admin.fromJson(v));
      });
    }
    vendor =
    json['vendor'] != null ? Vendor.fromJson(json['vendor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['ticketStatus'] = ticketStatus;
    if (chat != null) {
      data['chat'] = chat!.map((v) => v.toJson()).toList();
    }
    if (admin != null) {
      data['admin'] = admin!.map((v) => v.toJson()).toList();
    }
    if (vendor != null) {
      data['vendor'] = vendor!.toJson();
    }
    return data;
  }
}

class Chat {
  String? id;
  String? ticketId;
  String? senderId;
  String? senderType;
  String? message;
  List<String>? images;
  String? createdAt;
  String? updatedAt;

  Chat(
      {this.id,
        this.ticketId,
        this.senderId,
        this.senderType,
        this.message,
        this.images,
        this.createdAt,
        this.updatedAt
      });

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    ticketId = json['ticket_id']?.toString();
    senderId = json['sender_id']?.toString();
    senderType = json['sender_type']?.toString();
    message = json['message']?.toString();

    if(json['images'] != null){
      images = json['images'].cast<String>();
    } else {
      images = [];
    }

    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ticket_id'] = ticketId;
    data['sender_id'] = senderId;
    data['sender_type'] = senderType;
    data['message'] = message;
    data['images'] = images;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Admin {
  String? id;
  String? name;
  String? image;

  Admin({this.id, this.name, this.image});

  Admin.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    image = json['image']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}

class Vendor {
  String? id;
  String? firstName;
  String? lastName;
  String? shopImage;

  Vendor({this.id, this.firstName, this.lastName, this.shopImage});

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    firstName = json['first_name']?.toString();
    lastName = json['last_name']?.toString();
    shopImage = json['shopimage']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['shopimage'] = shopImage;
    return data;
  }
}
