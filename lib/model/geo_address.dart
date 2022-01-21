import 'dart:convert';

import 'package:amap_flutter_base/amap_flutter_base.dart';

class GeoAddress {
  GeoAddress({
    this.adcode,
    this.building,
    this.city,
    this.country,
    this.district,
    this.formatAddress,
    this.level,
    this.neighborhood,
    this.province,
    this.township,
    this.latLonPoint,
  });

  factory GeoAddress.fromJson(Map jsonRes) {
    var latLonPointJson = jsonRes['latLonPoint'];
    LatLng? latLonPoint;
    if (latLonPointJson is List && latLonPointJson.length > 1) {
      latLonPointJson = LatLng(latLonPointJson[0], latLonPointJson[1]);
    }
    return GeoAddress(
      adcode: jsonRes['adcode'],
      building: jsonRes['building'],
      city: jsonRes['city'],
      country: jsonRes['country'],
      district: jsonRes['district'],
      formatAddress: jsonRes['formatAddress'],
      neighborhood: jsonRes['neighborhood'],
      level: jsonRes['level'],
      province: jsonRes['province'],
      township: jsonRes['township'],
      latLonPoint: latLonPoint,
    );
  }

  String? adcode;
  String? building;
  String? city;
  String? country;
  String? district;
  String? formatAddress;
  String? level;
  String? neighborhood;
  String? province;
  String? township;
  LatLng? latLonPoint;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "adcode": adcode,
        "building": building,
        "city": city,
        "country": country,
        "district": district,
        "formatAddress": formatAddress,
        "level": level,
        "neighborhood": neighborhood,
        "province": province,
        "township": township,
        "latLonPoint": latLonPoint,
      };
}
