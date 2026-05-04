// class ProfileDetailsModel {
//   bool? status;
//   Vendor? vendor;
//   List<String>? serviceTypeOptions;
//   List<CuisineOptions>? cuisineOptions;
//   List<LoginActivities>? loginActivities;
//   List<InsuranceOptions>? insuranceOptions;
//
//
//   ProfileDetailsModel({this.status, this.vendor, this.serviceTypeOptions,this.cuisineOptions,this.loginActivities,this.insuranceOptions});
//
//   ProfileDetailsModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     vendor =
//     json['vendor'] != null ? Vendor.fromJson(json['vendor']) : null;
//     serviceTypeOptions = json['service_type_options'].cast<String>();
//     if (json['cuisine_options'] != null) {
//       cuisineOptions = <CuisineOptions>[];
//       json['cuisine_options'].forEach((v) {
//         cuisineOptions!.add(CuisineOptions.fromJson(v));
//       });
//     }
//     if (json['login_activities'] != null) {
//       loginActivities = <LoginActivities>[];
//       json['login_activities'].forEach((v) {
//         loginActivities!.add(new LoginActivities.fromJson(v));
//       });
//     }
//     if (json['insurance_options'] != null) {
//       insuranceOptions = <InsuranceOptions>[];
//       json['insurance_options'].forEach((v) {
//         insuranceOptions!.add(new InsuranceOptions.fromJson(v));
//       });
//     }
//
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     if (vendor != null) {
//       data['vendor'] = vendor!.toJson();
//     }
//     data['service_type_options'] = serviceTypeOptions;
//     if (cuisineOptions != null) {
//       data['cuisine_options'] =
//           cuisineOptions!.map((v) => v.toJson()).toList();
//     }
//     if (loginActivities != null) {
//       data['login_activities'] =
//           loginActivities!.map((v) => v.toJson()).toList();
//     }
//     if (this.insuranceOptions != null) {
//       data['insurance_options'] =
//           this.insuranceOptions!.map((v) => v.toJson()).toList();
//     }
//
//     return data;
//   }
// }

import 'dart:convert';

class ProfileDetailsModel {
  bool? status;
  bool? isProfileComplete;
  bool? isRequiredUploaded;
  bool? isRequiredVerified;
  Vendor? vendor;
  List<String>? serviceTypeOptions;
  List<CuisineOptions>? cuisineOptions;
  List<LoginActivities>? loginActivities;
  List<InsuranceOptions>? insuranceOptions;
  List<String>? permissions;

  ProfileDetailsModel({
    this.status,
    this.vendor,
    this.serviceTypeOptions,
    this.cuisineOptions,
    this.loginActivities,
    this.insuranceOptions,
    this.permissions,
    this.isProfileComplete,
    this.isRequiredUploaded,
    this.isRequiredVerified,
  });

  factory ProfileDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProfileDetailsModel(
      status: json['status'] ?? false,
      isProfileComplete: json['is_profilecomplete'],
      isRequiredVerified: json['is_required_verified'],
      isRequiredUploaded: json['is_required_uploaded'],
      vendor: json['vendor'] != null ? Vendor.fromJson(json['vendor']) : null,
      serviceTypeOptions: json['service_type_options'] != null
          ? List<String>.from(
          json['service_type_options'].map((x) => x.toString()))
          : [],
      permissions: json['permissions'] != null
          ? List<String>.from(
          json['permissions'].map((x) => x.toString()))
          : [],
      cuisineOptions: json['cuisine_options'] != null
          ? List<CuisineOptions>.from(
          json['cuisine_options'].map((x) => CuisineOptions.fromJson(x)))
          : [],
      loginActivities: json['login_activities'] != null
          ? List<LoginActivities>.from(
          json['login_activities'].map((x) => LoginActivities.fromJson(x)))
          : [],
      insuranceOptions: json['insurance_options'] != null
          ? List<InsuranceOptions>.from(
          json['insurance_options']
              .map((x) => InsuranceOptions.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'is_profilecomplete' : isProfileComplete,
      'is_required_uploaded' : isRequiredUploaded,
      'is_required_verified' : isRequiredVerified,
      'vendor': vendor?.toJson(),
      'service_type_options': serviceTypeOptions,
      'permissions': permissions,
      'cuisine_options': cuisineOptions?.map((v) => v.toJson()).toList() ?? [],
      'login_activities': loginActivities?.map((v) => v.toJson()).toList() ?? [],
      'insurance_options': insuranceOptions?.map((v) => v.toJson()).toList() ?? [],
    };
  }
}


class InsuranceOptions {
  String? companyName;
  int? id;

  InsuranceOptions({this.companyName, this.id});

  InsuranceOptions.fromJson(Map<String, dynamic> json) {
    companyName = json['company_name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_name'] = companyName;
    data['id'] = id;
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
  String? avgFulfillmentTime;
  List<String>? serviceType;
  List<String>? insuranceNetworks;
  List<String>? storeSpecializations;
  String? deliveryFee;
  List<CategoryIds>? categoryIds;
  OpeningHours? openingHours;
  List<CuisineIds>? cuisineIds;
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
  String? doNotDisturb;
  String? quietHours;
  String? startTime;
  String? endTime;
  String? notificationSounds;
  String? notificationBadges;
  String? notifyNewOrders;
  String? notifyOrderUpdates;
  String? notifyPaymentIssues;
  String? notifyLowStock;
  String? notifyOutOfStock;
  String? notifyTableReservations;
  String? notifyMenuItemRequests;
  String? pushNotifications;
  String? emailNotifications;
  String? smsNotifications;
  String? orderSummaryFrequency;
  String? reviewNotificationFrequency;
  String? inventoryAlertFrequency;
  String? delivery;
  String? pciCompliance;
  String? cashDrawerSecurity;
  String? storeType;
  String? storeSize;
  String? ncProviderId;
  String? auditFrequency;
  String? securityLevel;
  String? scheduleDispensingAuthorized;
  String? electronicPrescribing;
  List<InsuranceOptions>? insuranceOptions; // add this
  String? isPreOrder;
  String? freeDelAmount;
  String? orderCutoffMinutesBeforeClosing;


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
        this.avgFulfillmentTime,
        this.serviceType,
        this.insuranceNetworks,
        this.storeSpecializations,
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
        this.coverPhotoUrl,
        this.doNotDisturb,
        this.quietHours,
        this.startTime,
        this.endTime,
        this.notificationSounds,
        this.notificationBadges,
        this.notifyNewOrders,
        this.notifyOrderUpdates,
        this.notifyPaymentIssues,
        this.notifyLowStock,
        this.notifyOutOfStock,
        this.notifyTableReservations,
        this.notifyMenuItemRequests,
        this.pushNotifications,
        this.emailNotifications,
        this.smsNotifications,
        this.orderSummaryFrequency,
        this.reviewNotificationFrequency,
        this.inventoryAlertFrequency,
        this.delivery,
        this.pciCompliance,
        this.cashDrawerSecurity,
        this.storeType,
        this.storeSize,
        this.ncProviderId,
        this.auditFrequency,
        this.securityLevel,
        this.scheduleDispensingAuthorized,
        this.electronicPrescribing,
        this.isPreOrder,
        this.freeDelAmount,
        this.orderCutoffMinutesBeforeClosing,
      });

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
    avgFulfillmentTime = json['avg_fulfillment_time']?.toString();
    if (json['insurance_options'] != null) {
      insuranceOptions = <InsuranceOptions>[];
      json['insurance_options'].forEach((v) {
        insuranceOptions!.add(InsuranceOptions.fromJson(v));
      });
    }
    if (json['insurance_networks'] != null) {
      insuranceNetworks = List<String>.from(json['insurance_networks'].map((e) => e.toString()));
    } else {
      insuranceNetworks = [];
    }

    serviceType = json['service_type'] != null
        ? List<String>.from(json['service_type'].map((e) => e.toString()))
        : [];

    insuranceNetworks = json['insurance_networks'] != null
        ? List<String>.from(json['insurance_networks'].map((e) => e.toString()))
        : [];

    storeSpecializations = json['store_specializations'] != null
        ? List<String>.from(json['store_specializations'].map((e) => e.toString()))
        : [];

    // if(json['service_type']!= null) {
    //   serviceType = json['service_type'].cast<String>();
    // }else{
    //   serviceType = [];
    // }
    // if(json['insurance_networks']!= null) {
    //   insuranceNetworks = json['insurance_networks'].cast<String>();
    // }else{
    //   insuranceNetworks = [];
    // }
    // if(json['store_specializations']!= null) {
    //   storeSpecializations = json['store_specializations'].cast<String>();
    // }else{
    //   storeSpecializations = [];
    // }
    deliveryFee = json['delivery_fee']?.toString();
    if (json['category_ids'] != null) {
      categoryIds = <CategoryIds>[];
      json['category_ids'].forEach((v) {
        categoryIds!.add(CategoryIds.fromJson(v));
      });
    }
    // openingHours = json['opening_hours'] != null
    //     ? OpeningHours.fromJson(json['opening_hours'])
    //     : null;
    //
    openingHours = json['opening_hours'] != null
        ? (json['opening_hours'] is String
        ? OpeningHours.fromJson(jsonDecode(json['opening_hours']))
        : OpeningHours.fromJson(json['opening_hours']))
        : null;
    if (json['cuisine_ids'] != null) {
      cuisineIds = <CuisineIds>[];
      json['cuisine_ids'].forEach((v) {
        cuisineIds!.add(CuisineIds.fromJson(v));
      });
    }
    commissionRate = json['commission_rate']?.toString();
    commissionTier = json['commission_tier']?.toString();
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
    twoFaSms = json['two_fa']?.toString();
    twoFaApp = json['two_fa_app']?.toString();
    twoFaCode = json['two_fa_code']?.toString();
    twoFaExpiresAt = json['two_fa_expires_at']?.toString();
    lastLoginAt = json['last_login_at']?.toString();
    isOnline = json['is_online']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    logoUrl = json['logo_url']?.toString();
    coverPhotoUrl = json['cover_photo_url']?.toString();
    notificationSounds = json['notification_sounds']?.toString();
    notificationBadges = json['notification_badges']?.toString();
    notifyNewOrders = json['notify_new_orders']?.toString();
    notifyOrderUpdates = json['notify_order_updates']?.toString();
    notifyPaymentIssues = json['notify_payment_issues']?.toString();
    notifyLowStock = json['notify_low_stock']?.toString();
    notifyOutOfStock = json['notify_out_of_stock']?.toString();
    notifyTableReservations = json['notify_table_reservations']?.toString();
    notifyMenuItemRequests = json['notify_menu_item_requests']?.toString();
    pushNotifications = json['push_notifications']?.toString();
    emailNotifications = json['email_notifications']?.toString();
    smsNotifications = json['sms_notifications']?.toString();
    orderSummaryFrequency = json['order_summary_frequency']?.toString();
    reviewNotificationFrequency = json['review_notification_frequency']?.toString();
    inventoryAlertFrequency = json['inventory_alert_frequency']?.toString();
    doNotDisturb = json['do_not_disturb']?.toString();
    quietHours = json['quiet_hours']?.toString();
    startTime = json['start_time']?.toString();
    endTime = json['end_time']?.toString();
    delivery = json['delivery']?.toString();
    pciCompliance = json['pci_compliance']?.toString();
    cashDrawerSecurity = json['cash_drawer_security']?.toString();
    storeType = json['store_type']?.toString();
    storeSize = json['store_size']?.toString();
    ncProviderId = json['nc_provider_id']?.toString();
    securityLevel = json['security_level']?.toString();
    auditFrequency = json['audit_frequency']?.toString();
    scheduleDispensingAuthorized = json['schedule_dispensing_authorized']?.toString();
    electronicPrescribing = json['electronic_prescribing']?.toString();
    isPreOrder = json['is_pre_order']?.toString();
    freeDelAmount = json['free_del_amount']?.toString();
    orderCutoffMinutesBeforeClosing = json['order_cutoff_minutes_before_closing']?.toString();
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
    data['avg_fulfillment_time'] = avgFulfillmentTime;
    data['service_type'] = serviceType;
    data['insurance_networks'] = insuranceNetworks;
    data['store_specializations'] = storeSpecializations;
    data['delivery_fee'] = deliveryFee;
    if (categoryIds != null) {
      data['category_ids'] = categoryIds!.map((v) => v.toJson()).toList();
    }
    if (openingHours != null) {
      data['opening_hours'] = openingHours!.toJson();
    }
    if (cuisineIds != null) {
      data['cuisine_ids'] = cuisineIds!.map((v) => v.toJson()).toList();
    }
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
    data['notification_sounds'] = notificationSounds;
    data['notification_badges'] = notificationBadges;
    data['notify_new_orders'] = notifyNewOrders;
    data['notify_order_updates'] = notifyOrderUpdates;
    data['notify_payment_issues'] = notifyPaymentIssues;
    data['notify_low_stock'] = notifyLowStock;
    data['notify_out_of_stock'] = notifyOutOfStock;
    data['notify_table_reservations'] = notifyTableReservations;
    data['notify_menu_item_requests'] = notifyMenuItemRequests;
    data['push_notifications'] = pushNotifications;
    data['email_notifications'] = emailNotifications;
    data['sms_notifications'] = smsNotifications;
    data['order_summary_frequency'] = orderSummaryFrequency;
    data['review_notification_frequency'] = reviewNotificationFrequency;
    data['inventory_alert_frequency'] = inventoryAlertFrequency;
    data['do_not_disturb'] = doNotDisturb;
    data['quiet_hours'] = quietHours;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['delivery'] = delivery;
    data['pci_compliance'] = pciCompliance;
    data['cash_drawer_security'] = cashDrawerSecurity;
    data['store_type'] = storeType;
    data['store_size'] = storeSize;
    data['nc_provider_id'] = ncProviderId;
    data['security_level'] = securityLevel;
    data['audit_frequency'] = auditFrequency;
    data['schedule_dispensing_authorized'] = scheduleDispensingAuthorized;
    data['electronic_prescribing'] = electronicPrescribing;
    if (insuranceOptions != null) {
      data['insurance_options'] =
          insuranceOptions!.map((v) => v.toJson()).toList();
    }
    data['is_pre_order'] = isPreOrder;
    data['free_del_amount'] = freeDelAmount;
    data['order_cutoff_minutes_before_closing'] = orderCutoffMinutesBeforeClosing;
    return data;
  }
}

class CategoryIds {
  String? id;
  String? name;
  String? status;
  String? added;

  CategoryIds({this.id, this.status,this.name, this.added});

  CategoryIds.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    status = json['status']?.toString();
    added = json['added']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['added'] = added;
    return data;
  }
}

class OpeningHours {
  Sunday? sunday;
  Sunday? monday;
  Sunday? tuesday;
  Wednesday? wednesday;
  Wednesday? thursday;
  Wednesday? friday;
  Wednesday? saturday;

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
    json['Tuesday'] != null ? Sunday.fromJson(json['Tuesday']) : null;
    wednesday = json['Wednesday'] != null
        ? Wednesday.fromJson(json['Wednesday'])
        : null;
    thursday = json['Thursday'] != null
        ? Wednesday.fromJson(json['Thursday'])
        : null;
    friday =
    json['Friday'] != null ? Wednesday.fromJson(json['Friday']) : null;
    saturday = json['Saturday'] != null
        ? Wednesday.fromJson(json['Saturday'])
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

class Wednesday {
  String? status;
  String? open;
  String? close;

  Wednesday({this.status, this.open, this.close});

  Wednesday.fromJson(Map<String, dynamic> json) {
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

class DocumentVerification {
  FoodSafetyCertificate? foodSafetyCertificate;
  FoodSafetyCertificate? liquorLicense;
  FoodSafetyCertificate? fireSafetyCertificate;
  FoodHandlerCertificate? foodHandlerCertificate;
  FoodSafetyCertificate? businessLicense;
  FoodSafetyCertificate? buildingPermit;
  FoodSafetyCertificate? occupancyCertificate;
  FoodSafetyCertificate? musicEntertainmentLicense;
  FoodSafetyCertificate? other;
  FoodHandlerCertificate? healthPermit;

  DocumentVerification(
      {this.foodSafetyCertificate,
        this.liquorLicense,
        this.fireSafetyCertificate,
        this.foodHandlerCertificate,
        this.businessLicense,
        this.buildingPermit,
        this.occupancyCertificate,
        this.musicEntertainmentLicense,
        this.other,
        this.healthPermit});

  DocumentVerification.fromJson(Map<String, dynamic> json) {
    foodSafetyCertificate = json['food_safety_certificate'] != null
        ? FoodSafetyCertificate.fromJson(json['food_safety_certificate'])
        : null;
    liquorLicense = json['liquor_license'] != null
        ? FoodSafetyCertificate.fromJson(json['liquor_license'])
        : null;
    fireSafetyCertificate = json['fire_safety_certificate'] != null
        ? FoodSafetyCertificate.fromJson(json['fire_safety_certificate'])
        : null;
    foodHandlerCertificate = json['food_handler_certificate'] != null
        ? FoodHandlerCertificate.fromJson(json['food_handler_certificate'])
        : null;
    businessLicense = json['business_license'] != null
        ? FoodSafetyCertificate.fromJson(json['business_license'])
        : null;
    buildingPermit = json['building_permit'] != null
        ? FoodSafetyCertificate.fromJson(json['building_permit'])
        : null;
    occupancyCertificate = json['occupancy_certificate'] != null
        ? FoodSafetyCertificate.fromJson(json['occupancy_certificate'])
        : null;
    musicEntertainmentLicense = json['music_entertainment_license'] != null
        ? FoodSafetyCertificate.fromJson(
        json['music_entertainment_license'])
        : null;
    other = json['other'] != null
        ? FoodSafetyCertificate.fromJson(json['other'])
        : null;
    healthPermit = json['health_permit'] != null
        ? FoodHandlerCertificate.fromJson(json['health_permit'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (foodSafetyCertificate != null) {
      data['food_safety_certificate'] = foodSafetyCertificate!.toJson();
    }
    if (liquorLicense != null) {
      data['liquor_license'] = liquorLicense!.toJson();
    }
    if (fireSafetyCertificate != null) {
      data['fire_safety_certificate'] = fireSafetyCertificate!.toJson();
    }
    if (foodHandlerCertificate != null) {
      data['food_handler_certificate'] = foodHandlerCertificate!.toJson();
    }
    if (businessLicense != null) {
      data['business_license'] = businessLicense!.toJson();
    }
    if (buildingPermit != null) {
      data['building_permit'] = buildingPermit!.toJson();
    }
    if (occupancyCertificate != null) {
      data['occupancy_certificate'] = occupancyCertificate!.toJson();
    }
    if (musicEntertainmentLicense != null) {
      data['music_entertainment_license'] =
          musicEntertainmentLicense!.toJson();
    }
    if (other != null) {
      data['other'] = other!.toJson();
    }
    if (healthPermit != null) {
      data['health_permit'] = healthPermit!.toJson();
    }
    return data;
  }
}

class FoodSafetyCertificate {
  String? documentNumber;
  String? issuingAuthority;
  String? issueDate;
  String? expiryDate;
  String? status;
  String? image;
  String? additionalNotes;

  FoodSafetyCertificate(
      {this.documentNumber,
        this.issuingAuthority,
        this.issueDate,
        this.expiryDate,
        this.status,
        this.image,
        this.additionalNotes});

  FoodSafetyCertificate.fromJson(Map<String, dynamic> json) {
    documentNumber = json['document_number']?.toString();
    issuingAuthority = json['issuing_authority']?.toString();
    issueDate = json['issue_date']?.toString();
    expiryDate = json['expiry_date']?.toString();
    status = json['status']?.toString();
    image = json['image']?.toString();
    additionalNotes = json['additional_notes']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['document_number'] = documentNumber;
    data['issuing_authority'] = issuingAuthority;
    data['issue_date'] = issueDate;
    data['expiry_date'] = expiryDate;
    data['status'] = status;
    data['image'] = image;
    data['additional_notes'] = additionalNotes;
    return data;
  }
}

class FoodHandlerCertificate {
  String? documentNumber;
  String? issuingAuthority;
  String? issueDate;
  String? expiryDate;
  String? uploadDate;
  String? status;
  String? image;
  String? additionalNotes;

  FoodHandlerCertificate(
      {this.documentNumber,
        this.issuingAuthority,
        this.issueDate,
        this.expiryDate,
        this.uploadDate,
        this.status,
        this.image,
        this.additionalNotes});

  FoodHandlerCertificate.fromJson(Map<String, dynamic> json) {
    documentNumber = json['document_number']?.toString();
    issuingAuthority = json['issuing_authority']?.toString();
    issueDate = json['issue_date']?.toString();
    expiryDate = json['expiry_date']?.toString();
    uploadDate = json['upload_date']?.toString();
    status = json['status']?.toString();
    image = json['image']?.toString();
    additionalNotes = json['additional_notes']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['document_number'] = documentNumber;
    data['issuing_authority'] = issuingAuthority;
    data['issue_date'] = issueDate;
    data['expiry_date'] = expiryDate;
    data['upload_date'] = uploadDate;
    data['status'] = status;
    data['image'] = image;
    data['additional_notes'] = additionalNotes;
    return data;
  }
}
class CuisineIds {
  String? id;
  String? name;

  CuisineIds({this.id, this.name});

  CuisineIds.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
  class CuisineOptions {
    String? name;
    String? id;

    CuisineOptions({this.name, this.id});

    CuisineOptions.fromJson(Map<String, dynamic> json) {
      name = json['name']?.toString();
      id = json['id']?.toString();
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['name'] = name;
      data['id'] = id;
      return data;
    }
  }

class LoginActivities {
  String? device;
  String? location;
  String? time;
  String? status;

  LoginActivities({this.device, this.location, this.time, this.status});

  LoginActivities.fromJson(Map<String, dynamic> json) {
    device = json['device']?.toString();
    location = json['location']?.toString();
    time = json['time']?.toString();
    status = json['status']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['device'] = device;
    data['location'] = location;
    data['time'] = time;
    data['status'] = status;
    return data;
  }
}




//
// class ProfileDetailsModel {
//   bool? status;
//   Vendor? vendor;
//   List<String>? serviceTypeOptions;
//
//   ProfileDetailsModel({this.status, this.vendor, this.serviceTypeOptions});
//
//   ProfileDetailsModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     vendor =
//     json['vendor'] != null ? Vendor.fromJson(json['vendor']) : null;
//     serviceTypeOptions = json['service_type_options'].cast<String>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     if (vendor != null) {
//       data['vendor'] = vendor!.toJson();
//     }
//     data['service_type_options'] = serviceTypeOptions;
//     return data;
//   }
// }
//
// class Vendor {
//   String? id;
//   String? shopName;
//   String? ownerName;
//   String? description;
//   String? dob;
//   String? phoneCode;
//   String? phone;
//   String? email;
//   String? website;
//   String? address;
//   String? latitude;
//   String? longitude;
//   String? logo;
//   String? coverPhoto;
//   String? licenseNumber;
//   String? taxNumber;
//   String? deaRegistrationNumber;
//   String? establishedDate;
//   String? noOfEmployees;
//   String? facebook;
//   String? instagram;
//   String? twitter;
//   String? youtube;
//   String? deliveryRadius;
//   String? minOrderAmount;
//   String? avgPreparationTime;
//   List<String>? serviceType;
//   String? deliveryFee;
//   List<CategoryIds>? categoryIds;
//   OpeningHours? openingHours;
//   List<int>? cuisineIds;
//   String? commissionRate;
//   String? commissionTier;
//   DocumentVerification? documentVerification;
//   String? otherDetails;
//   String? roleId;
//   String? parentId;
//   String? type;
//   String? otp;
//   String? rating;
//   String? emailVerify;
//   String? step;
//   String? deviceToken;
//   String? status;
//   String? addedBy;
//   String? notification;
//   String? emailNotification;
//   String? appVersion;
//   String? twoFaSms;
//   String? twoFaApp;
//   String? twoFaCode;
//   String? twoFaExpiresAt;
//   String? lastLoginAt;
//   String? isOnline;
//   String? createdAt;
//   String? updatedAt;
//   String? logoUrl;
//   String? coverPhotoUrl;
//
//   Vendor(
//       {this.id,
//         this.shopName,
//         this.ownerName,
//         this.description,
//         this.dob,
//         this.phoneCode,
//         this.phone,
//         this.email,
//         this.website,
//         this.address,
//         this.latitude,
//         this.longitude,
//         this.logo,
//         this.coverPhoto,
//         this.licenseNumber,
//         this.taxNumber,
//         this.deaRegistrationNumber,
//         this.establishedDate,
//         this.noOfEmployees,
//         this.facebook,
//         this.instagram,
//         this.twitter,
//         this.youtube,
//         this.deliveryRadius,
//         this.minOrderAmount,
//         this.avgPreparationTime,
//         this.serviceType,
//         this.deliveryFee,
//         this.categoryIds,
//         this.openingHours,
//         this.cuisineIds,
//         this.commissionRate,
//         this.commissionTier,
//         this.documentVerification,
//         this.otherDetails,
//         this.roleId,
//         this.parentId,
//         this.type,
//         this.otp,
//         this.rating,
//         this.emailVerify,
//         this.step,
//         this.deviceToken,
//         this.status,
//         this.addedBy,
//         this.notification,
//         this.emailNotification,
//         this.appVersion,
//         this.twoFaSms,
//         this.twoFaApp,
//         this.twoFaCode,
//         this.twoFaExpiresAt,
//         this.lastLoginAt,
//         this.isOnline,
//         this.createdAt,
//         this.updatedAt,
//         this.logoUrl,
//         this.coverPhotoUrl});
//
//   Vendor.fromJson(Map<String, dynamic> json) {
//     id = json['id']?.toString();
//     shopName = json['shop_name']?.toString();
//     ownerName = json['owner_name']?.toString();
//     description = json['description']?.toString();
//     dob = json['dob']?.toString();
//     phoneCode = json['phone_code']?.toString();
//     phone = json['phone']?.toString();
//     email = json['email']?.toString();
//     website = json['website']?.toString();
//     address = json['address']?.toString();
//     latitude = json['latitude']?.toString();
//     longitude = json['longitude']?.toString();
//     logo = json['logo']?.toString();
//     coverPhoto = json['cover_photo']?.toString();
//     licenseNumber = json['license_number']?.toString();
//     taxNumber = json['tax_number']?.toString();
//     deaRegistrationNumber = json['dea_registration_number']?.toString();
//     establishedDate = json['established_date']?.toString();
//     noOfEmployees = json['no_of_employees']?.toString();
//     facebook = json['facebook']?.toString();
//     instagram = json['instagram']?.toString();
//     twitter = json['twitter']?.toString();
//     youtube = json['youtube']?.toString();
//     deliveryRadius = json['delivery_radius']?.toString();
//     minOrderAmount = json['min_order_amount']?.toString();
//     avgPreparationTime = json['avg_preparation_time']?.toString();
//     if (json['service_type'] != null) {
//       serviceType = json['service_type'].cast<String>();
//     }else{
//       serviceType = [];
//     }
//     deliveryFee = json['delivery_fee']?.toString();
//     if (json['category_ids'] != null) {
//       categoryIds = <CategoryIds>[];
//       json['category_ids'].forEach((v) {
//         categoryIds!.add(CategoryIds.fromJson(v));
//       });
//     }
//     openingHours = json['opening_hours'] != null
//         ? OpeningHours.fromJson(json['opening_hours'])
//         : null;
//     cuisineIds = json['cuisine_ids'].cast<int>();
//     commissionRate = json['commission_rate']?.toString();
//     commissionTier = json['commission_tier']?.toString();
//     documentVerification = json['document_verification'] != null
//         ? DocumentVerification.fromJson(json['document_verification'])
//         : null;
//     otherDetails = json['other_details']?.toString();
//     roleId = json['role_id']?.toString();
//     parentId = json['parent_id']?.toString();
//     type = json['type']?.toString();
//     otp = json['otp']?.toString();
//     rating = json['rating']?.toString();
//     emailVerify = json['email_verify']?.toString();
//     step = json['step']?.toString();
//     deviceToken = json['device_token']?.toString();
//     status = json['status']?.toString();
//     addedBy = json['added_by']?.toString();
//     notification = json['notification']?.toString();
//     emailNotification = json['email_notification']?.toString();
//     appVersion = json['app_version']?.toString();
//     twoFaSms = json['two_fa_sms']?.toString();
//     twoFaApp = json['two_fa_app']?.toString();
//     twoFaCode = json['two_fa_code']?.toString();
//     twoFaExpiresAt = json['two_fa_expires_at']?.toString();
//     lastLoginAt = json['last_login_at']?.toString();
//     isOnline = json['is_online']?.toString();
//     createdAt = json['created_at']?.toString();
//     updatedAt = json['updated_at']?.toString();
//     logoUrl = json['logo_url']?.toString();
//     coverPhotoUrl = json['cover_photo_url']?.toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['shop_name'] = shopName;
//     data['owner_name'] = ownerName;
//     data['description'] = description;
//     data['dob'] = dob;
//     data['phone_code'] = phoneCode;
//     data['phone'] = phone;
//     data['email'] = email;
//     data['website'] = website;
//     data['address'] = address;
//     data['latitude'] = latitude;
//     data['longitude'] = longitude;
//     data['logo'] = logo;
//     data['cover_photo'] = coverPhoto;
//     data['license_number'] = licenseNumber;
//     data['tax_number'] = taxNumber;
//     data['dea_registration_number'] = deaRegistrationNumber;
//     data['established_date'] = establishedDate;
//     data['no_of_employees'] = noOfEmployees;
//     data['facebook'] = facebook;
//     data['instagram'] = instagram;
//     data['twitter'] = twitter;
//     data['youtube'] = youtube;
//     data['delivery_radius'] = deliveryRadius;
//     data['min_order_amount'] = minOrderAmount;
//     data['avg_preparation_time'] = avgPreparationTime;
//     data['service_type'] = serviceType;
//     data['delivery_fee'] = deliveryFee;
//     if (categoryIds != null) {
//       data['category_ids'] = categoryIds!.map((v) => v.toJson()).toList();
//     }
//     if (openingHours != null) {
//       data['opening_hours'] = openingHours!.toJson();
//     }
//     data['cuisine_ids'] = cuisineIds;
//     data['commission_rate'] = commissionRate;
//     data['commission_tier'] = commissionTier;
//     if (documentVerification != null) {
//       data['document_verification'] = documentVerification!.toJson();
//     }
//     data['other_details'] = otherDetails;
//     data['role_id'] = roleId;
//     data['parent_id'] = parentId;
//     data['type'] = type;
//     data['otp'] = otp;
//     data['rating'] = rating;
//     data['email_verify'] = emailVerify;
//     data['step'] = step;
//     data['device_token'] = deviceToken;
//     data['status'] = status;
//     data['added_by'] = addedBy;
//     data['notification'] = notification;
//     data['email_notification'] = emailNotification;
//     data['app_version'] = appVersion;
//     data['two_fa_sms'] = twoFaSms;
//     data['two_fa_app'] = twoFaApp;
//     data['two_fa_code'] = twoFaCode;
//     data['two_fa_expires_at'] = twoFaExpiresAt;
//     data['last_login_at'] = lastLoginAt;
//     data['is_online'] = isOnline;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['logo_url'] = logoUrl;
//     data['cover_photo_url'] = coverPhotoUrl;
//     return data;
//   }
// }
//
// class CategoryIds {
//   String? id;
//   String? status;
//   String? added;
//
//   CategoryIds({this.id, this.status, this.added});
//
//   CategoryIds.fromJson(Map<String, dynamic> json) {
//     id = json['id']?.toString();
//     status = json['status']?.toString();
//     added = json['added']?.toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['status'] = status;
//     data['added'] = added;
//     return data;
//   }
// }
//
// class OpeningHours {
//   Sunday? sunday;
//   Sunday? monday;
//   Tuesday? tuesday;
//   Tuesday? wednesday;
//   Tuesday? thursday;
//   Tuesday? friday;
//   Tuesday? saturday;
//
//   OpeningHours(
//       {this.sunday,
//         this.monday,
//         this.tuesday,
//         this.wednesday,
//         this.thursday,
//         this.friday,
//         this.saturday});
//
//   OpeningHours.fromJson(Map<String, dynamic> json) {
//     sunday =
//     json['Sunday'] != null ? Sunday.fromJson(json['Sunday']) : null;
//     monday =
//     json['Monday'] != null ? Sunday.fromJson(json['Monday']) : null;
//     tuesday =
//     json['Tuesday'] != null ? Tuesday.fromJson(json['Tuesday']) : null;
//     wednesday = json['Wednesday'] != null
//         ? Tuesday.fromJson(json['Wednesday'])
//         : null;
//     thursday = json['Thursday'] != null
//         ? Tuesday.fromJson(json['Thursday'])
//         : null;
//     friday =
//     json['Friday'] != null ? Tuesday.fromJson(json['Friday']) : null;
//     saturday = json['Saturday'] != null
//         ? Tuesday.fromJson(json['Saturday'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (sunday != null) {
//       data['Sunday'] = sunday!.toJson();
//     }
//     if (monday != null) {
//       data['Monday'] = monday!.toJson();
//     }
//     if (tuesday != null) {
//       data['Tuesday'] = tuesday!.toJson();
//     }
//     if (wednesday != null) {
//       data['Wednesday'] = wednesday!.toJson();
//     }
//     if (thursday != null) {
//       data['Thursday'] = thursday!.toJson();
//     }
//     if (friday != null) {
//       data['Friday'] = friday!.toJson();
//     }
//     if (saturday != null) {
//       data['Saturday'] = saturday!.toJson();
//     }
//     return data;
//   }
// }
//
// class Sunday {
//   String? status;
//   String? open;
//   String? close;
//
//   Sunday({this.status, this.open, this.close});
//
//   Sunday.fromJson(Map<String, dynamic> json) {
//     status = json['status']?.toString();
//     open = json['open']?.toString();
//     close = json['close']?.toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     data['open'] = open;
//     data['close'] = close;
//     return data;
//   }
// }
//
// class Tuesday {
//   String? open;
//   String? close;
//
//   Tuesday({this.open, this.close});
//
//   Tuesday.fromJson(Map<String, dynamic> json) {
//     open = json['open']?.toString();
//     close = json['close']?.toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['open'] = open;
//     data['close'] = close;
//     return data;
//   }
// }
//
// class DocumentVerification {
//   BusinessLicense? businessLicense;
//   TaxId? taxId;
//   TaxId? insurance;
//   TaxId? foodSafety;
//
//   DocumentVerification(
//       {this.businessLicense, this.taxId, this.insurance, this.foodSafety});
//
//   DocumentVerification.fromJson(Map<String, dynamic> json) {
//     businessLicense = json['business_license'] != null
//         ? BusinessLicense.fromJson(json['business_license'])
//         : null;
//     taxId = json['tax_id'] != null ? TaxId.fromJson(json['tax_id']) : null;
//     insurance = json['insurance'] != null
//         ? TaxId.fromJson(json['insurance'])
//         : null;
//     foodSafety = json['food_safety'] != null
//         ? TaxId.fromJson(json['food_safety'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (businessLicense != null) {
//       data['business_license'] = businessLicense!.toJson();
//     }
//     if (taxId != null) {
//       data['tax_id'] = taxId!.toJson();
//     }
//     if (insurance != null) {
//       data['insurance'] = insurance!.toJson();
//     }
//     if (foodSafety != null) {
//       data['food_safety'] = foodSafety!.toJson();
//     }
//     return data;
//   }
// }
//
// class BusinessLicense {
//   String? status;
//   String? image;
//   String? approveDate;
//
//   BusinessLicense({this.status, this.image, this.approveDate});
//
//   BusinessLicense.fromJson(Map<String, dynamic> json) {
//     status = json['status']?.toString();
//     image = json['image']?.toString();
//     approveDate = json['approve_date']?.toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     data['image'] = image;
//     data['approve_date'] = approveDate;
//     return data;
//   }
// }
//
// class TaxId {
//   String? status;
//   String? image;
//
//   TaxId({this.status, this.image});
//
//   TaxId.fromJson(Map<String, dynamic> json) {
//     status = json['status']?.toString();
//     image = json['image']?.toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     data['image'] = image;
//     return data;
//   }
// }
// // class ProfileDetailsModel {
// //   bool? status;
// //   Data? data;
// //   List<Reviews>? reviews;
// //   String? averageRating;
// //   StarPercentages? starPercentages;
// //
// //   ProfileDetailsModel({this.status, this.data, this.reviews,this.averageRating});
// //
// //   ProfileDetailsModel.fromJson(Map<String, dynamic> json) {
// //     status = json['status'];
// //     data = json['data'] != null ? Data.fromJson(json['data']) : null;
// //     if (json['reviews'] != null) {
// //       reviews = <Reviews>[];
// //       json['reviews'].forEach((v) {
// //         reviews!.add(Reviews.fromJson(v));
// //       });
// //     }
// //     averageRating = json['average_rating']?.toString();
// //     starPercentages = json['star_percentages'] != null ? StarPercentages.fromJson(json['star_percentages']) : null;
// //
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     data['status'] = status;
// //     if (this.data != null) {
// //       data['data'] = this.data!.toJson();
// //     }
// //
// //     if (reviews != null) {
// //       data['reviews'] = reviews!.map((v) => v.toJson()).toList();
// //     }
// //     data['average_rating'] = averageRating;
// //
// //     if (starPercentages != null) {
// //       data['star_percentages'] = starPercentages!.toJson();
// //     }
// //     return data;
// //   }
// // }
// //
// // class Data {
// //   String? id;
// //   String? firstName;
// //   String? lastName;
// //   String? name;
// //   String? email;
// //   String? image;
// //   String? dob;
// //   String? gender;
// //   String? pPassword;
// //   String? rating;
// //   String? emailVerify;
// //   String? avgPrice;
// //   String? currentStatus;
// //   String? phoneCode;
// //   String? phone;
// //   String? step;
// //   String? deviceToken;
// //   String? imageUrl;
// //   String? shopName;
// //   String? shopEmail;
// //   String? shopimage;
// //   String? shopAddress;
// //   String? latitude;
// //   String? longitude;
// //   String? shopDes;
// //   OpeningHours? openingHours;
// //   String? countryId;
// //   String? stateId;
// //   String? cityId;
// //   String? categoryId;
// //   String? role;
// //   String? status;
// //   String? delivery;
// //   String? addedBy;
// //   String? createdAt;
// //   String? updatedAt;
// //   String? notification;
// //   String? emailNotification;
// //
// //   Data(
// //       {this.id,
// //       this.firstName,
// //       this.lastName,
// //       this.name,
// //       this.email,
// //       this.image,
// //       this.dob,
// //       this.gender,
// //       this.pPassword,
// //       this.rating,
// //       this.emailVerify,
// //       this.avgPrice,
// //       this.currentStatus,
// //       this.phoneCode,
// //       this.phone,
// //       this.step,
// //       this.deviceToken,
// //       this.imageUrl,
// //       this.shopName,
// //       this.shopEmail,
// //       this.shopimage,
// //       this.shopAddress,
// //       this.latitude,
// //       this.longitude,
// //       this.shopDes,
// //       this.openingHours,
// //       this.countryId,
// //       this.stateId,
// //       this.cityId,
// //       this.categoryId,
// //       this.role,
// //       this.status,
// //       this.delivery,
// //       this.addedBy,
// //       this.createdAt,
// //       this.updatedAt,
// //       this.notification,
// //       this.emailNotification,
// //       });
// //
// //   Data.fromJson(Map<String, dynamic> json) {
// //     id = json['id']?.toString();
// //     firstName = json['first_name']?.toString();
// //     lastName = json['last_name']?.toString();
// //     name = json['name']?.toString();
// //     email = json['email']?.toString();
// //     image = json['image']?.toString();
// //     dob = json['dob']?.toString();
// //     gender = json['gender']?.toString();
// //     pPassword = json['p_password']?.toString();
// //     rating = json['rating']?.toString();
// //     emailVerify = json['email_verify']?.toString();
// //     avgPrice = json['avg_price']?.toString();
// //     currentStatus = json['current_status']?.toString();
// //     phoneCode = json['phone_code']?.toString();
// //     phone = json['phone']?.toString();
// //     step = json['step']?.toString();
// //     deviceToken = json['device_token']?.toString();
// //     imageUrl = json['image_url']?.toString();
// //     shopName = json['shop_name']?.toString();
// //     shopEmail = json['shop_email']?.toString();
// //     shopimage = json['shopimage']?.toString();
// //     shopAddress = json['shop_address']?.toString();
// //     latitude = json['latitude']?.toString();
// //     longitude = json['longitude']?.toString();
// //     shopDes = json['shop_des']?.toString();
// //     openingHours = json['opening_hours'] != null
// //         ? OpeningHours.fromJson(json['opening_hours'])
// //         : null;
// //     countryId = json['country_id']?.toString();
// //     stateId = json['state_id']?.toString();
// //     cityId = json['city_id']?.toString();
// //     categoryId = json['category_id']?.toString();
// //     role = json['role']?.toString();
// //     status = json['status']?.toString();
// //     delivery = json['delivery']?.toString();
// //     addedBy = json['added_by']?.toString();
// //     createdAt = json['created_at']?.toString();
// //     updatedAt = json['updated_at']?.toString();
// //     notification = json['notification']?.toString();
// //     emailNotification = json['email_notification']?.toString();
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     data['id'] = id;
// //     data['first_name'] = firstName;
// //     data['last_name'] = lastName;
// //     data['name'] = name;
// //     data['email'] = email;
// //     data['image'] = image;
// //     data['dob'] = dob;
// //     data['gender'] = gender;
// //     data['p_password'] = pPassword;
// //     data['rating'] = rating;
// //     data['email_verify'] = emailVerify;
// //     data['avg_price'] = avgPrice;
// //     data['current_status'] = currentStatus;
// //     data['phone_code'] = phoneCode;
// //     data['phone'] = phone;
// //     data['step'] = step;
// //     data['device_token'] = deviceToken;
// //     data['image_url'] = imageUrl;
// //     data['shop_name'] = shopName;
// //     data['shop_email'] = shopEmail;
// //     data['shopimage'] = shopimage;
// //     data['shop_address'] = shopAddress;
// //     data['latitude'] = latitude;
// //     data['longitude'] = longitude;
// //     data['shop_des'] = shopDes;
// //     if (openingHours != null) {
// //       data['opening_hours'] = openingHours!.toJson();
// //     }
// //     data['country_id'] = countryId;
// //     data['state_id'] = stateId;
// //     data['city_id'] = cityId;
// //     data['category_id'] = categoryId;
// //     data['role'] = role;
// //     data['status'] = status;
// //     data['delivery'] = delivery;
// //     data['added_by'] = addedBy;
// //     data['created_at'] = createdAt;
// //     data['updated_at'] = updatedAt;
// //     data['notification'] = notification;
// //     data['email_notification'] = emailNotification;
// //     return data;
// //   }
// // }
// //
// // class OpeningHours {
// //   Sunday? sunday;
// //   Sunday? monday;
// //   Sunday? tuesday;
// //   Sunday? wednesday;
// //   Sunday? thursday;
// //   Sunday? friday;
// //   Saturday? saturday;
// //
// //   OpeningHours(
// //       {this.sunday,
// //       this.monday,
// //       this.tuesday,
// //       this.wednesday,
// //       this.thursday,
// //       this.friday,
// //       this.saturday});
// //
// //   OpeningHours.fromJson(Map<String, dynamic> json) {
// //     sunday = json['Sunday'] != null ? Sunday.fromJson(json['Sunday']) : null;
// //     monday = json['Monday'] != null ? Sunday.fromJson(json['Monday']) : null;
// //     tuesday = json['Tuesday'] != null ? Sunday.fromJson(json['Tuesday']) : null;
// //     wednesday =
// //         json['Wednesday'] != null ? Sunday.fromJson(json['Wednesday']) : null;
// //     thursday =
// //         json['Thursday'] != null ? Sunday.fromJson(json['Thursday']) : null;
// //     friday = json['Friday'] != null ? Sunday.fromJson(json['Friday']) : null;
// //     saturday =
// //         json['Saturday'] != null ? Saturday.fromJson(json['Saturday']) : null;
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     if (sunday != null) {
// //       data['Sunday'] = sunday!.toJson();
// //     }
// //     if (monday != null) {
// //       data['Monday'] = monday!.toJson();
// //     }
// //     if (tuesday != null) {
// //       data['Tuesday'] = tuesday!.toJson();
// //     }
// //     if (wednesday != null) {
// //       data['Wednesday'] = wednesday!.toJson();
// //     }
// //     if (thursday != null) {
// //       data['Thursday'] = thursday!.toJson();
// //     }
// //     if (friday != null) {
// //       data['Friday'] = friday!.toJson();
// //     }
// //     if (saturday != null) {
// //       data['Saturday'] = saturday!.toJson();
// //     }
// //     return data;
// //   }
// // }
// //
// // class Sunday {
// //   String? status;
// //   String? open;
// //   String? close;
// //
// //   Sunday({this.status, this.open, this.close});
// //
// //   Sunday.fromJson(Map<String, dynamic> json) {
// //     status = json['status']?.toString();
// //     open = json['open']?.toString();
// //     close = json['close']?.toString();
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     data['status'] = status;
// //     data['open'] = open;
// //     data['close'] = close;
// //     return data;
// //   }
// // }
// //
// // class Saturday {
// //   String? open;
// //   String? close;
// //
// //   Saturday({this.open, this.close});
// //
// //   Saturday.fromJson(Map<String, dynamic> json) {
// //     open = json['open']?.toString();
// //     close = json['close']?.toString();
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     data['open'] = open;
// //     data['close'] = close;
// //     return data;
// //   }
// // }
// //
// // class Reviews {
// //   String? id;
// //   String? role;
// //   String? rating;
// //   String? review;
// //   String? createdAt;
// //   User? user;
// //
// //   Reviews({this.id, this.role, this.rating, this.review, this.user,this.createdAt});
// //
// //   Reviews.fromJson(Map<String, dynamic> json) {
// //     id = json['id']?.toString();
// //     role = json['role']?.toString();
// //     rating = json['rating']?.toString();
// //     review = json['review']?.toString();
// //     createdAt = json['created_at']?.toString();
// //     user = json['user'] != null ? User.fromJson(json['user']) : null;
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     data['id'] = id;
// //     data['role'] = role;
// //     data['rating'] = rating;
// //     data['review'] = review;
// //     data['created_at'] = createdAt;
// //     if (user != null) {
// //       data['user'] = user!.toJson();
// //     }
// //     return data;
// //   }
// // }
// //
// // class User {
// //   String? id;
// //   String? firstName;
// //   String? lastName;
// //   String? imageUrl;
// //
// //   User({this.id, this.firstName, this.lastName});
// //
// //   User.fromJson(Map<String, dynamic> json) {
// //     id = json['id']?.toString();
// //     firstName = json['first_name']?.toString();
// //     lastName = json['last_name']?.toString();
// //     imageUrl = json['image_url']?.toString();
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     data['id'] = id;
// //     data['first_name'] = firstName;
// //     data['last_name'] = lastName;
// //     data['image_url'] = imageUrl;
// //     return data;
// //   }
// // }
// // class StarPercentages {
// //   String? d1;
// //   String? d2;
// //   String? d3;
// //   String? d4;
// //   String? d5;
// //
// //   StarPercentages({this.d1, this.d2, this.d3, this.d4, this.d5});
// //
// //   StarPercentages.fromJson(Map<String, dynamic> json) {
// //     d1 = json['1']?.toString();
// //     d2 = json['2']?.toString();
// //     d3 = json['3']?.toString();
// //     d4 = json['4']?.toString();
// //     d5 = json['5']?.toString();
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     data['1'] = d1;
// //     data['2'] = d2;
// //     data['3'] = d3;
// //     data['4'] = d4;
// //     data['5'] = d5;
// //     return data;
// //   }
// // }
