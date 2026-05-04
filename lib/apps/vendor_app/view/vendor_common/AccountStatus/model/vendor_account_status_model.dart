class VendorAccountStatusModel {
  bool? status;
  String? vendorStatus;
  String? roleName;
  String? vendorType;
  String? step;
  bool? isProfileComplete;

  VendorAccountStatusModel({this.status, this.vendorStatus,this.isProfileComplete,this.roleName,this.vendorType,this.step});

  VendorAccountStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    vendorStatus = json['vendorStatus']?.toString();
    roleName = json['role_name']?.toString();
    vendorType = json['vendor_type']?.toString();
    isProfileComplete = json['is_profilecomplete'];
    step = json['step']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['vendorStatus'] = vendorStatus;
    data['role_name'] = roleName;
    data['vendor_type'] = vendorType;
    data['is_profilecomplete'] = isProfileComplete;
    data['step'] = step;
    return data;
  }
}
