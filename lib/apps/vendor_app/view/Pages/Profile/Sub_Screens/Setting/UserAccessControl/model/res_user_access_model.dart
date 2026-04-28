class UserAccessModel {
  bool? status;
  String? message;
  UsersCount? usersCount;
  List<VendorList>? vendorList;

  UserAccessModel(
      {this.status, this.message, this.usersCount, this.vendorList});

  UserAccessModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
    usersCount = json['users_count'] != null
        ? UsersCount.fromJson(json['users_count'])
        : null;
    if (json['vendor_list'] != null) {
      vendorList = <VendorList>[];
      json['vendor_list'].forEach((v) {
        vendorList!.add(VendorList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (usersCount != null) {
      data['users_count'] = usersCount!.toJson();
    }
    if (vendorList != null) {
      data['vendor_list'] = vendorList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UsersCount {
  String? owner;
  String? manager;
  String? accountant;
  String? kitchenStaff;
  String? serviceStaff;

  UsersCount(
      {this.owner,
        this.manager,
        this.accountant,
        this.kitchenStaff,
        this.serviceStaff});

  UsersCount.fromJson(Map<String, dynamic> json) {
    owner = json['owner']?.toString();
    manager = json['manager']?.toString();
    accountant = json['accountant']?.toString();
    kitchenStaff = json['kitchen_staff']?.toString();
    serviceStaff = json['service_staff']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['owner'] = owner;
    data['manager'] = manager;
    data['accountant'] = accountant;
    data['kitchen_staff'] = kitchenStaff;
    data['service_staff'] = serviceStaff;
    return data;
  }
}

class VendorList {
  String? id;
  String? ownerName;
  String? email;
  String? status;
  String? roleId;
  String? logoUrl;
  String? coverPhotoUrl;
  String? roleName;

  VendorList(
      {this.id,
        this.ownerName,
        this.email,
        this.status,
        this.roleId,
        this.logoUrl,
        this.coverPhotoUrl,
        this.roleName});

  VendorList.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    ownerName = json['owner_name']?.toString();
    email = json['email']?.toString();
    status = json['status']?.toString();
    roleId = json['role_id']?.toString();
    logoUrl = json['logo_url']?.toString();
    coverPhotoUrl = json['cover_photo_url']?.toString();
    roleName = json['role_name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['owner_name'] = ownerName;
    data['email'] = email;
    data['status'] = status;
    data['role_id'] = roleId;
    data['logo_url'] = logoUrl;
    data['cover_photo_url'] = coverPhotoUrl;
    data['role_name'] = roleName;
    return data;
  }
}
