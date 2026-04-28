class GetUserDetailsModel {
  bool? status;
  String? message;
  User? user;

  GetUserDetailsModel({this.status, this.message, this.user});

  GetUserDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? ownerName;
  String? email;
  String? phoneCode;
  String? phone;
  String? roleId;
  String? logoUrl;
  String? coverPhotoUrl;
  String? roleName;
  String? status;

  User(
      {this.ownerName,
        this.email,
        this.phoneCode,
        this.phone,
        this.roleId,
        this.logoUrl,
        this.coverPhotoUrl,
        this.status,
        this.roleName});

  User.fromJson(Map<String, dynamic> json) {
    ownerName = json['owner_name']?.toString();
    email = json['email']?.toString();
    phoneCode = json['phone_code']?.toString();
    phone = json['phone']?.toString();
    roleId = json['role_id']?.toString();
    logoUrl = json['logo_url']?.toString();
    coverPhotoUrl = json['cover_photo_url']?.toString();
    status = json['status']?.toString();
    roleName = json['role_name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['owner_name'] = ownerName;
    data['email'] = email;
    data['phone_code'] = phoneCode;
    data['phone'] = phone;
    data['role_id'] = roleId;
    data['logo_url'] = logoUrl;
    data['cover_photo_url'] = coverPhotoUrl;
    data['role_name'] = roleName;
    data['status'] = status;
    return data;
  }
}
