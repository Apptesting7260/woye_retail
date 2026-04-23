class MapBoxModel {
  String? type;
  List<Features>? features;
  String? attribution;

  MapBoxModel({this.type, this.features, this.attribution});

  MapBoxModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features!.add(Features.fromJson(v));
      });
    }
    attribution = json['attribution']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    if (features != null) {
      data['features'] = features!.map((v) => v.toJson()).toList();
    }
    data['attribution'] = attribution;
    return data;
  }
}

class Features {
  String? type;
  String? id;
  Geometry? geometry;
  Properties? properties;

  Features({this.type, this.id, this.geometry, this.properties});

  Features.fromJson(Map<String, dynamic> json) {
    type = json['type']?.toString();
    id = json['id']?.toString();
    geometry = json['geometry'] != null
        ? Geometry.fromJson(json['geometry'])
        : null;
    properties = json['properties'] != null
        ? Properties.fromJson(json['properties'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['id'] = id;
    if (geometry != null) {
      data['geometry'] = geometry!.toJson();
    }
    if (properties != null) {
      data['properties'] = properties!.toJson();
    }
    return data;
  }
}

class Geometry {
  String? type;
  List<double>? coordinates;

  Geometry({this.type, this.coordinates});

  Geometry.fromJson(Map<String, dynamic> json) {
    type = json['type']?.toString();
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}

class Properties {
  String? mapboxId;
  String? featureType;
  String? fullAddress;
  String? name;
  String? namePreferred;
  Coordinates? coordinates;
  String? placeFormatted;
  // List<double>? bbox;
  Context? context;

  Properties(
      {this.mapboxId,
        this.featureType,
        this.fullAddress,
        this.name,
        this.namePreferred,
        this.coordinates,
        this.placeFormatted,
        // this.bbox,
        this.context});

  Properties.fromJson(Map<String, dynamic> json) {
    mapboxId = json['mapbox_id']?.toString();
    featureType = json['feature_type']?.toString();
    fullAddress = json['full_address']?.toString();
    name = json['name']?.toString();
    namePreferred = json['name_preferred']?.toString();
    coordinates = json['coordinates'] != null
        ? Coordinates.fromJson(json['coordinates'])
        : null;
    placeFormatted = json['place_formatted']?.toString();
    // bbox = json['bbox'].cast<double>();
    context =
    json['context'] != null ? Context.fromJson(json['context']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mapbox_id'] = mapboxId;
    data['feature_type'] = featureType;
    data['full_address'] = fullAddress;
    data['name'] = name;
    data['name_preferred'] = namePreferred;
    if (coordinates != null) {
      data['coordinates'] = coordinates!.toJson();
    }
    data['place_formatted'] = placeFormatted;
    // data['bbox'] = bbox;
    if (context != null) {
      data['context'] = context!.toJson();
    }
    return data;
  }
}

class Coordinates {
  double? longitude;
  double? latitude;

  Coordinates({this.longitude, this.latitude});

  Coordinates.fromJson(Map<String, dynamic> json) {
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    return data;
  }
}

class Context {
  District? district;
  Region? region;
  Country? country;
  District? place;
  Locality? locality;
  Locality? postcode;
  Locality? neighborhood;

  Context(
      {this.district,
        this.region,
        this.country,
        this.place,
        this.locality,
        this.postcode,
        this.neighborhood});

  Context.fromJson(Map<String, dynamic> json) {
    district = json['district'] != null
        ? District.fromJson(json['district'])
        : null;
    region =
    json['region'] != null ? Region.fromJson(json['region']) : null;
    country =
    json['country'] != null ? Country.fromJson(json['country']) : null;
    place = json['place'] != null ? District.fromJson(json['place']) : null;
    locality = json['locality'] != null
        ? Locality.fromJson(json['locality'])
        : null;
    postcode = json['postcode'] != null
        ? Locality.fromJson(json['postcode'])
        : null;
    neighborhood = json['neighborhood'] != null
        ? Locality.fromJson(json['neighborhood'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (district != null) {
      data['district'] = district!.toJson();
    }
    if (region != null) {
      data['region'] = region!.toJson();
    }
    if (country != null) {
      data['country'] = country!.toJson();
    }
    if (place != null) {
      data['place'] = place!.toJson();
    }
    if (locality != null) {
      data['locality'] = locality!.toJson();
    }
    if (postcode != null) {
      data['postcode'] = postcode!.toJson();
    }
    if (neighborhood != null) {
      data['neighborhood'] = neighborhood!.toJson();
    }
    return data;
  }
}

class District {
  String? mapboxId;
  String? name;
  String? wikidataId;

  District({this.mapboxId, this.name, this.wikidataId});

  District.fromJson(Map<String, dynamic> json) {
    mapboxId = json['mapbox_id']?.toString();
    name = json['name']?.toString();
    wikidataId = json['wikidata_id']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mapbox_id'] = mapboxId;
    data['name'] = name;
    data['wikidata_id'] = wikidataId;
    return data;
  }
}

class Region {
  String? mapboxId;
  String? name;
  String? wikidataId;
  String? regionCode;
  String? regionCodeFull;

  Region(
      {this.mapboxId,
        this.name,
        this.wikidataId,
        this.regionCode,
        this.regionCodeFull});

  Region.fromJson(Map<String, dynamic> json) {
    mapboxId = json['mapbox_id']?.toString();
    name = json['name']?.toString();
    wikidataId = json['wikidata_id']?.toString();
    regionCode = json['region_code']?.toString();
    regionCodeFull = json['region_code_full']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mapbox_id'] = mapboxId;
    data['name'] = name;
    data['wikidata_id'] = wikidataId;
    data['region_code'] = regionCode;
    data['region_code_full'] = regionCodeFull;
    return data;
  }
}

class Country {
  String? mapboxId;
  String? name;
  String? wikidataId;
  String? countryCode;
  String? countryCodeAlpha3;

  Country(
      {this.mapboxId,
        this.name,
        this.wikidataId,
        this.countryCode,
        this.countryCodeAlpha3});

  Country.fromJson(Map<String, dynamic> json) {
    mapboxId = json['mapbox_id']?.toString();
    name = json['name']?.toString();
    wikidataId = json['wikidata_id']?.toString();
    countryCode = json['country_code']?.toString();
    countryCodeAlpha3 = json['country_code_alpha_3']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mapbox_id'] = mapboxId;
    data['name'] = name;
    data['wikidata_id'] = wikidataId;
    data['country_code'] = countryCode;
    data['country_code_alpha_3'] = countryCodeAlpha3;
    return data;
  }
}

class Locality {
  String? mapboxId;
  String? name;

  Locality({this.mapboxId, this.name});

  Locality.fromJson(Map<String, dynamic> json) {
    mapboxId = json['mapbox_id']?.toString();
    name = json['name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mapbox_id'] = mapboxId;
    data['name'] = name;
    return data;
  }
}
