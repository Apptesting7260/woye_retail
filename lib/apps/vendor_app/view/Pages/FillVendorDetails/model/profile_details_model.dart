class VendorProfileDetailsModel {
  bool? status;
  Vendor? vendor;
  // List<Null>? loginActivities;
  // List<String>? serviceTypeOptions;
  // List<CuisineOptions>? cuisineOptions;

  VendorProfileDetailsModel(
      {this.status,
        this.vendor,
        // this.loginActivities,
        // this.serviceTypeOptions,
        // this.cuisineOptions
      });

  VendorProfileDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    vendor =
    json['vendor'] != null ? Vendor.fromJson(json['vendor']) : null;
    // if (json['login_activities'] != null) {
    //   loginActivities = <Null>[];
    //   json['login_activities'].forEach((v) {
    //     loginActivities!.add(new Null.fromJson(v));
    //   });
    // }
    // serviceTypeOptions = json['service_type_options'].cast<String>();
    // if (json['cuisine_options'] != null) {
    //   cuisineOptions = <CuisineOptions>[];
    //   json['cuisine_options'].forEach((v) {
    //     cuisineOptions!.add(new CuisineOptions.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (vendor != null) {
      data['vendor'] = vendor!.toJson();
    }
    // if (loginActivities != null) {
    //   data['login_activities'] =
    //       loginActivities!.map((v) => v.toJson()).toList();
    // }
    // data['service_type_options'] = serviceTypeOptions;
    // if (cuisineOptions != null) {
    //   data['cuisine_options'] =
    //       cuisineOptions!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Vendor {
  String? id;
  String? shopName;
  String? ownerName;
  String? description;
  String? dob;
  String? phoneCode;
  String? phone;
  String? email;
  String? website;
  String? address;
  String? latitude;
  String? longitude;
  String? logo;
  String? coverPhoto;
  String? licenseNumber;
  String? taxNumber;
  String? deaRegistrationNumber;
  String? establishedDate;
  String? noOfEmployees;
  String? facebook;
  String? instagram;
  String? twitter;
  String? youtube;
  String? deliveryRadius;
  String? minOrderAmount;
  String? avgPreparationTime;
  String? serviceType;
  String? deliveryFee;
  // List<Null>? categoryIds;
  // Null? openingHours;
  // List<Null>? cuisineIds;
  String? commissionRate;
  String? commissionTier;
  // List<Null>? documentVerification;
  String? otherDetails;
  String? roleId;
  String? parentId;
  String? type;
  String? otp;
  String? rating;
  String? emailVerify;
  String? step;
  String? deviceToken;
  String? status;
  String? addedBy;
  String? notification;
  String? emailNotification;
  String? appVersion;
  String? twoFa;
  String? twoFaApp;
  String? twoFaCode;
  String? twoFaExpiresAt;
  String? lastLoginAt;
  String? isOnline;
  String? createdAt;
  String? updatedAt;
  String? logoUrl;
  String? coverPhotoUrl;
  String? roleName;
  Role? role;

  Vendor(
      {this.id,
        this.shopName,
        this.ownerName,
        this.description,
        this.dob,
        this.phoneCode,
        this.phone,
        this.email,
        this.website,
        this.address,
        this.latitude,
        this.longitude,
        this.logo,
        this.coverPhoto,
        this.licenseNumber,
        this.taxNumber,
        this.deaRegistrationNumber,
        this.establishedDate,
        this.noOfEmployees,
        this.facebook,
        this.instagram,
        this.twitter,
        this.youtube,
        this.deliveryRadius,
        this.minOrderAmount,
        this.avgPreparationTime,
        this.serviceType,
        this.deliveryFee,
        // this.categoryIds,
        // this.openingHours,
        // this.cuisineIds,
        this.commissionRate,
        this.commissionTier,
        // this.documentVerification,
        this.otherDetails,
        this.roleId,
        this.parentId,
        this.type,
        this.otp,
        this.rating,
        this.emailVerify,
        this.step,
        this.deviceToken,
        this.status,
        this.addedBy,
        this.notification,
        this.emailNotification,
        this.appVersion,
        this.twoFa,
        this.twoFaApp,
        this.twoFaCode,
        this.twoFaExpiresAt,
        this.lastLoginAt,
        this.isOnline,
        this.createdAt,
        this.updatedAt,
        this.logoUrl,
        this.coverPhotoUrl,
        this.roleName,
        this.role});

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    shopName = json['shop_name']?.toString();
    ownerName = json['owner_name']?.toString();
    description = json['description']?.toString();
    dob = json['dob']?.toString();
    phoneCode = json['phone_code']?.toString();
    phone = json['phone']?.toString();
    email = json['email']?.toString();
    website = json['website']?.toString();
    address = json['address']?.toString();
    latitude = json['latitude']?.toString();
    longitude = json['longitude']?.toString();
    logo = json['logo']?.toString();
    coverPhoto = json['cover_photo']?.toString();
    licenseNumber = json['license_number']?.toString();
    taxNumber = json['tax_number']?.toString();
    deaRegistrationNumber = json['dea_registration_number']?.toString();
    establishedDate = json['established_date']?.toString();
    noOfEmployees = json['no_of_employees']?.toString();
    facebook = json['facebook']?.toString();
    instagram = json['instagram']?.toString();
    twitter = json['twitter']?.toString();
    youtube = json['youtube']?.toString();
    deliveryRadius = json['delivery_radius']?.toString();
    minOrderAmount = json['min_order_amount']?.toString();
    avgPreparationTime = json['avg_preparation_time']?.toString();
    serviceType = json['service_type']?.toString();
    deliveryFee = json['delivery_fee']?.toString();
    // if (json['category_ids'] != null) {
    //   categoryIds = <Null>[];
    //   json['category_ids'].forEach((v) {
    //     categoryIds!.add(new Null.fromJson(v));
    //   });
    // }
    // openingHours = json['opening_hours'];
    // if (json['cuisine_ids'] != null) {
    //   cuisineIds = <Null>[];
    //   json['cuisine_ids'].forEach((v) {
    //     cuisineIds!.add(new Null.fromJson(v));
    //   });
    // }
    commissionRate = json['commission_rate']?.toString();
    commissionTier = json['commission_tier']?.toString();
    // if (json['document_verification'] != null) {
    //   documentVerification = <Null>[];
    //   json['document_verification'].forEach((v) {
    //     documentVerification!.add(new Null.fromJson(v));
    //   });
    // }
    otherDetails = json['other_details']?.toString();
    roleId = json['role_id']?.toString();
    parentId = json['parent_id']?.toString();
    type = json['type']?.toString();
    otp = json['otp']?.toString();
    rating = json['rating']?.toString();
    emailVerify = json['email_verify']?.toString();
    step = json['step']?.toString();
    deviceToken = json['device_token']?.toString();
    status = json['status']?.toString();
    addedBy = json['added_by']?.toString();
    notification = json['notification']?.toString();
    emailNotification = json['email_notification']?.toString();
    appVersion = json['app_version']?.toString();
    twoFa = json['two_fa']?.toString();
    twoFaApp = json['two_fa_app']?.toString();
    twoFaCode = json['two_fa_code']?.toString();
    twoFaExpiresAt = json['two_fa_expires_at']?.toString();
    lastLoginAt = json['last_login_at']?.toString();
    isOnline = json['is_online']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    logoUrl = json['logo_url']?.toString();
    coverPhotoUrl = json['cover_photo_url']?.toString();
    roleName = json['role_name']?.toString();
    role = json['role'] != null ? Role.fromJson(json['role']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shop_name'] = shopName;
    data['owner_name'] = ownerName;
    data['description'] = description;
    data['dob'] = dob;
    data['phone_code'] = phoneCode;
    data['phone'] = phone;
    data['email'] = email;
    data['website'] = website;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['logo'] = logo;
    data['cover_photo'] = coverPhoto;
    data['license_number'] = licenseNumber;
    data['tax_number'] = taxNumber;
    data['dea_registration_number'] = deaRegistrationNumber;
    data['established_date'] = establishedDate;
    data['no_of_employees'] = noOfEmployees;
    data['facebook'] = facebook;
    data['instagram'] = instagram;
    data['twitter'] = twitter;
    data['youtube'] = youtube;
    data['delivery_radius'] = deliveryRadius;
    data['min_order_amount'] = minOrderAmount;
    data['avg_preparation_time'] = avgPreparationTime;
    data['service_type'] = serviceType;
    data['delivery_fee'] = deliveryFee;
    // if (categoryIds != null) {
    //   data['category_ids'] = categoryIds!.map((v) => v.toJson()).toList();
    // }
    // data['opening_hours'] = openingHours;
    // if (cuisineIds != null) {
    //   data['cuisine_ids'] = cuisineIds!.map((v) => v.toJson()).toList();
    // }
    data['commission_rate'] = commissionRate;
    data['commission_tier'] = commissionTier;
    // if (documentVerification != null) {
    //   data['document_verification'] =
    //       documentVerification!.map((v) => v.toJson()).toList();
    // }
    data['other_details'] = otherDetails;
    data['role_id'] = roleId;
    data['parent_id'] = parentId;
    data['type'] = type;
    data['otp'] = otp;
    data['rating'] = rating;
    data['email_verify'] = emailVerify;
    data['step'] = step;
    data['device_token'] = deviceToken;
    data['status'] = status;
    data['added_by'] = addedBy;
    data['notification'] = notification;
    data['email_notification'] = emailNotification;
    data['app_version'] = appVersion;
    data['two_fa'] = twoFa;
    data['two_fa_app'] = twoFaApp;
    data['two_fa_code'] = twoFaCode;
    data['two_fa_expires_at'] = twoFaExpiresAt;
    data['last_login_at'] = lastLoginAt;
    data['is_online'] = isOnline;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['logo_url'] = logoUrl;
    data['cover_photo_url'] = coverPhotoUrl;
    data['role_name'] = roleName;
    if (role != null) {
      data['role'] = role!.toJson();
    }
    return data;
  }
}

class Role {
  String? id;
  String? name;
  String? guardName;
  String? createdAt;
  String? updatedAt;

  Role({this.id, this.name, this.guardName, this.createdAt, this.updatedAt});

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    guardName = json['guard_name']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['guard_name'] = guardName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class CuisineOptions {
  String? name;
  String? id;
  String? imageUrl;

  CuisineOptions({this.name, this.id, this.imageUrl});

  CuisineOptions.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
    id = json['id']?.toString();
    imageUrl = json['image_url']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['image_url'] = imageUrl;
    return data;
  }
}
