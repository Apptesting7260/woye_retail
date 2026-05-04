class InformationUpdateModel {
  bool? status;
  String? message;
  String? errorMessage;
  Data? data;

  InformationUpdateModel({this.status, this.message, this.data});

  InformationUpdateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
    errorMessage = json['error message']?.toString();
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['error message'] = errorMessage;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
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
  List<String>? serviceType;
  String? deliveryFee;
  List<CategoryIds>? categoryIds;
  OpeningHours? openingHours;
  List<int>? cuisineIds;
  String? commissionRate;
  String? commissionTier;
  DocumentVerification? documentVerification;
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
  String? twoFaSms;
  String? twoFaApp;
  String? twoFaCode;
  String? twoFaExpiresAt;
  String? lastLoginAt;
  String? isOnline;
  String? createdAt;
  String? updatedAt;
  String? logoUrl;
  String? coverPhotoUrl;

  Data(
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
        this.categoryIds,
        this.openingHours,
        this.cuisineIds,
        this.commissionRate,
        this.commissionTier,
        this.documentVerification,
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
        this.twoFaSms,
        this.twoFaApp,
        this.twoFaCode,
        this.twoFaExpiresAt,
        this.lastLoginAt,
        this.isOnline,
        this.createdAt,
        this.updatedAt,
        this.logoUrl,
        this.coverPhotoUrl});

  Data.fromJson(Map<String, dynamic> json) {
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
    if(json['service_type'] != null) {
      serviceType = json['service_type'].cast<String>();
    }else {
      serviceType = [];
    }
    deliveryFee = json['delivery_fee']?.toString();
    if (json['category_ids'] != null) {
      categoryIds = <CategoryIds>[];
      json['category_ids'].forEach((v) {
        categoryIds!.add(CategoryIds.fromJson(v));
      });
    }
    openingHours = json['opening_hours'] != null
        ? OpeningHours.fromJson(json['opening_hours'])
        : null;
    // cuisineIds = json['cuisine_ids'].cast<int>();
    commissionRate = json['commission_rate']?.toString();
    commissionTier = json['commission_tier'];
    documentVerification = json['document_verification'] != null
        ? DocumentVerification.fromJson(json['document_verification'])
        : null;
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
    twoFaSms = json['two_fa_sms']?.toString();
    twoFaApp = json['two_fa_app']?.toString();
    twoFaCode = json['two_fa_code']?.toString();
    twoFaExpiresAt = json['two_fa_expires_at']?.toString();
    lastLoginAt = json['last_login_at']?.toString();
    isOnline = json['is_online']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    logoUrl = json['logo_url']?.toString();
    coverPhotoUrl = json['cover_photo_url']?.toString();
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
    if (categoryIds != null) {
      data['category_ids'] = categoryIds!.map((v) => v.toJson()).toList();
    }
    if (openingHours != null) {
      data['opening_hours'] = openingHours!.toJson();
    }
    data['cuisine_ids'] = cuisineIds;
    data['commission_rate'] = commissionRate;
    data['commission_tier'] = commissionTier;
    if (documentVerification != null) {
      data['document_verification'] = documentVerification!.toJson();
    }
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
    data['two_fa_sms'] = twoFaSms;
    data['two_fa_app'] = twoFaApp;
    data['two_fa_code'] = twoFaCode;
    data['two_fa_expires_at'] = twoFaExpiresAt;
    data['last_login_at'] = lastLoginAt;
    data['is_online'] = isOnline;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['logo_url'] = logoUrl;
    data['cover_photo_url'] = coverPhotoUrl;
    return data;
  }
}

class CategoryIds {
  String? id;
  String? status;
  String? added;

  CategoryIds({this.id, this.status, this.added});

  CategoryIds.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    status = json['status']?.toString();
    added = json['added']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['added'] = added;
    return data;
  }
}

class OpeningHours {
  Sunday? sunday;
  Sunday? monday;
  Tuesday? tuesday;
  Tuesday? wednesday;
  Tuesday? thursday;
  Tuesday? friday;
  Tuesday? saturday;

  OpeningHours(
      {this.sunday,
        this.monday,
        this.tuesday,
        this.wednesday,
        this.thursday,
        this.friday,
        this.saturday});

  OpeningHours.fromJson(Map<String, dynamic> json) {
    sunday =
    json['Sunday'] != null ? Sunday.fromJson(json['Sunday']) : null;
    monday =
    json['Monday'] != null ? Sunday.fromJson(json['Monday']) : null;
    tuesday =
    json['Tuesday'] != null ? Tuesday.fromJson(json['Tuesday']) : null;
    wednesday = json['Wednesday'] != null
        ? Tuesday.fromJson(json['Wednesday'])
        : null;
    thursday = json['Thursday'] != null
        ? Tuesday.fromJson(json['Thursday'])
        : null;
    friday =
    json['Friday'] != null ? Tuesday.fromJson(json['Friday']) : null;
    saturday = json['Saturday'] != null
        ? Tuesday.fromJson(json['Saturday'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sunday != null) {
      data['Sunday'] = sunday!.toJson();
    }
    if (monday != null) {
      data['Monday'] = monday!.toJson();
    }
    if (tuesday != null) {
      data['Tuesday'] = tuesday!.toJson();
    }
    if (wednesday != null) {
      data['Wednesday'] = wednesday!.toJson();
    }
    if (thursday != null) {
      data['Thursday'] = thursday!.toJson();
    }
    if (friday != null) {
      data['Friday'] = friday!.toJson();
    }
    if (saturday != null) {
      data['Saturday'] = saturday!.toJson();
    }
    return data;
  }
}

class Sunday {
  String? status;
  String? open;
  String? close;

  Sunday({this.status, this.open, this.close});

  Sunday.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toString();
    open = json['open']?.toString();
    close = json['close']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['open'] = open;
    data['close'] = close;
    return data;
  }
}

class Tuesday {
  String? open;
  String? close;

  Tuesday({this.open, this.close});

  Tuesday.fromJson(Map<String, dynamic> json) {
    open = json['open']?.toString();
    close = json['close']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['open'] = open;
    data['close'] = close;
    return data;
  }
}

class DocumentVerification {
  BusinessLicense? businessLicense;
  TaxId? taxId;
  TaxId? insurance;
  TaxId? foodSafety;

  DocumentVerification(
      {this.businessLicense, this.taxId, this.insurance, this.foodSafety});

  DocumentVerification.fromJson(Map<String, dynamic> json) {
    businessLicense = json['business_license'] != null
        ? BusinessLicense.fromJson(json['business_license'])
        : null;
    taxId = json['tax_id'] != null ? TaxId.fromJson(json['tax_id']) : null;
    insurance = json['insurance'] != null
        ? TaxId.fromJson(json['insurance'])
        : null;
    foodSafety = json['food_safety'] != null
        ? TaxId.fromJson(json['food_safety'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (businessLicense != null) {
      data['business_license'] = businessLicense!.toJson();
    }
    if (taxId != null) {
      data['tax_id'] = taxId!.toJson();
    }
    if (insurance != null) {
      data['insurance'] = insurance!.toJson();
    }
    if (foodSafety != null) {
      data['food_safety'] = foodSafety!.toJson();
    }
    return data;
  }
}

class BusinessLicense {
  String? status;
  String? image;
  String? approveDate;

  BusinessLicense({this.status, this.image, this.approveDate});

  BusinessLicense.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toString();
    image = json['image']?.toString();
    approveDate = json['approve_date']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['image'] = image;
    data['approve_date'] = approveDate;
    return data;
  }
}

class TaxId {
  String? status;
  String? image;

  TaxId({this.status, this.image});

  TaxId.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toString();
    image = json['image']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['image'] = image;
    return data;
  }
}
