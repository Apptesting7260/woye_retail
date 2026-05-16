class VendorSubCategoriesModel{
  bool? status;
  List<Data>? data;
  List<Null>? attributes;

  VendorSubCategoriesModel({this.status, this.data, this.attributes});

  VendorSubCategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add( Data.fromJson(v));
      });
    }
    // if (json['attributes'] != null) {
    //   attributes = <Null>[];
    //   json['attributes'].forEach((v) {
    //     attributes!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    // if (this.attributes != null) {
    //   data['attributes'] = this.attributes!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Data {
  String? id;
  String? parentId;
  String? slug;
  String? name;
  String? description;
  String? image;
  String? status;
  String? isDeleted;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;

  Data(
      {this.id,
        this.parentId,
        this.slug,
        this.name,
        this.description,
        this.image,
        this.status,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
        this.imageUrl});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    parentId = json['parent_id']?.toString();
    slug = json['slug']?.toString();
    name = json['name']?.toString();
    description = json['description']?.toString();
    image = json['image']?.toString();
    status = json['status']?.toString();
    isDeleted = json['is_deleted']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    imageUrl = json['image_url']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent_id'] = parentId;
    data['slug'] = slug;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    data['status'] = status;
    data['is_deleted'] = isDeleted;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image_url'] = imageUrl;
    return data;
  }
}
