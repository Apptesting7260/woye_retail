class RestaurantGetSupportModel {
  bool? status;
  Vendor? vendor;
  List<AllTickets>? allTickets;
  List<AllTickets>? openTickets;
  List<AllTickets>? closeTickets;

  RestaurantGetSupportModel(
      {this.status,
        this.vendor,
        this.allTickets,
        this.openTickets,
        this.closeTickets});

  RestaurantGetSupportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    vendor =
    json['vendor'] != null ? Vendor.fromJson(json['vendor']) : null;
    if (json['allTickets'] != null) {
      allTickets = <AllTickets>[];
      json['allTickets'].forEach((v) {
        allTickets!.add(AllTickets.fromJson(v));
      });
    }
    if (json['openTickets'] != null) {
      openTickets = <AllTickets>[];
      json['openTickets'].forEach((v) {
        openTickets!.add(AllTickets.fromJson(v));
      });
    }
    if (json['closeTickets'] != null) {
      closeTickets = <AllTickets>[];
      json['closeTickets'].forEach((v) {
        closeTickets!.add(AllTickets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (vendor != null) {
      data['vendor'] = vendor!.toJson();
    }
    if (allTickets != null) {
      data['allTickets'] = allTickets!.map((v) => v.toJson()).toList();
    }
    if (openTickets != null) {
      data['openTickets'] = openTickets!.map((v) => v.toJson()).toList();
    }
    if (closeTickets != null) {
      data['closeTickets'] = closeTickets!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vendor {
  int? id;
  String? firstName;
  String? lastName;
  String? name;
  String? email;
  String? imageUrl;
  String? phoneCode;
  String? phone;
  String? shopName;
  String? shopEmail;
  String? shopimage;
  String? shopAddress;

  Vendor(
      {this.id,
        this.firstName,
        this.lastName,
        this.name,
        this.email,
        this.imageUrl,
        this.phoneCode,
        this.phone,
        this.shopName,
        this.shopEmail,
        this.shopimage,
        this.shopAddress});

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    name = json['name'];
    email = json['email'];
    imageUrl = json['image_url'];
    phoneCode = json['phone_code'];
    phone = json['phone'];
    shopName = json['shop_name'];
    shopEmail = json['shop_email'];
    shopimage = json['shopimage'];
    shopAddress = json['shop_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['name'] = name;
    data['email'] = email;
    data['image_url'] = imageUrl;
    data['phone_code'] = phoneCode;
    data['phone'] = phone;
    data['shop_name'] = shopName;
    data['shop_email'] = shopEmail;
    data['shopimage'] = shopimage;
    data['shop_address'] = shopAddress;
    return data;
  }
}

class AllTickets {
  String? id;
  String? title;
  String? subject;
  String? status;
  String? type;
  String? vendorId;
  String? adminId;
  String? createdAt;
  String? updatedAt;

  AllTickets(
      {this.id,
        this.title,
        this.subject,
        this.status,
        this.type,
        this.vendorId,
        this.adminId,
        this.createdAt,
        this.updatedAt});

  AllTickets.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    title = json['title']?.toString();
    subject = json['subject']?.toString();
    status = json['status']?.toString();
    type = json['type']?.toString();
    vendorId = json['vendor_id']?.toString();
    adminId = json['admin_id']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['subject'] = subject;
    data['status'] = status;
    data['type'] = type;
    data['vendor_id'] = vendorId;
    data['admin_id'] = adminId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

// class OpenTickets {
//   int? id;
//   String? title;
//   String? subject;
//   String? status;
//   String? type;
//   int? vendorId;
//   int? adminId;
//   String? createdAt;
//   String? updatedAt;
//
//   OpenTickets(
//       {this.id,
//         this.title,
//         this.subject,
//         this.status,
//         this.type,
//         this.vendorId,
//         this.adminId,
//         this.createdAt,
//         this.updatedAt});
//
//   OpenTickets.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     subject = json['subject'];
//     status = json['status'];
//     type = json['type'];
//     vendorId = json['vendor_id'];
//     adminId = json['admin_id'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['title'] = title;
//     data['subject'] = subject;
//     data['status'] = status;
//     data['type'] = type;
//     data['vendor_id'] = vendorId;
//     data['admin_id'] = adminId;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     return data;
//   }
// }
//
// class CloseTickets {
//   int? id;
//   String? title;
//   String? subject;
//   String? status;
//   String? type;
//   int? vendorId;
//   int? adminId;
//   String? createdAt;
//   String? updatedAt;
//
//   CloseTickets(
//       {this.id,
//         this.title,
//         this.subject,
//         this.status,
//         this.type,
//         this.vendorId,
//         this.adminId,
//         this.createdAt,
//         this.updatedAt});
//
//   CloseTickets.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     subject = json['subject'];
//     status = json['status'];
//     type = json['type'];
//     vendorId = json['vendor_id'];
//     adminId = json['admin_id'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['title'] = title;
//     data['subject'] = subject;
//     data['status'] = status;
//     data['type'] = type;
//     data['vendor_id'] = vendorId;
//     data['admin_id'] = adminId;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     return data;
//   }
// }
