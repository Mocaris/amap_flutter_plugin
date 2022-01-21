import 'dart:convert';

import 'package:amap_flutter_base/amap_flutter_base.dart';

class PoiItem {
  PoiItem(
      {this.distance,
      this.isIndoorMap,
      this.cityCode,
      this.latLonPoint,
      this.title,
      this.photos,
      this.cityName,
      this.adCode,
      this.tel,
      this.enter,
      this.poiId,
      this.email,
      this.typeDes,
      this.direction,
      this.adName,
      this.parkingType,
      this.website,
      this.poiExtension,
      this.provinceCode,
      this.postcode,
      this.typeCode,
      this.exit,
      this.businessArea,
      this.provinceName,
      this.indoorData,
      this.subPois});

  factory PoiItem.fromJson(Map jsonRes) {
    var latLon = jsonRes['latLonPoint'];
    LatLng? latLonPoint;
    if (latLon is List && latLon.length > 1) {
      latLonPoint = LatLng(latLon[0], latLon[1]);
    }
    var enterJson = jsonRes['enter'];
    LatLng? enter;
    if (enterJson is List && enterJson.length > 1) {
      enter = LatLng(latLon[0], latLon[1]);
    }
    var exitJson = jsonRes['exit'];
    LatLng? exit;
    if (exitJson is List && exitJson.length > 1) {
      exit = LatLng(latLon[0], latLon[1]);
    }

    final List<String>? photos = (jsonRes['photos'] is List) ? (jsonRes['photos'] as List).map((e) => e.toString()).toList() : <String>[];
    final List<SubPois>? subPois =
        (jsonRes['subPois'] is List) ? (jsonRes['subPois'] as List).map((e) => SubPois.fromJson(e)).toList() : <SubPois>[];

    return PoiItem(
        distance: jsonRes['distance'],
        isIndoorMap: jsonRes['isIndoorMap'],
        cityCode: jsonRes['cityCode'],
        latLonPoint: latLonPoint,
        title: jsonRes['title'],
        photos: photos,
        cityName: jsonRes['cityName'],
        adCode: jsonRes['adCode'],
        tel: jsonRes['tel'],
        enter: enter,
        poiId: jsonRes['poiId'],
        email: jsonRes['email'],
        typeDes: jsonRes['typeDes'],
        direction: jsonRes['direction'],
        adName: jsonRes['adName'],
        parkingType: jsonRes['parkingType'],
        website: jsonRes['website'],
        poiExtension: (jsonRes['poiExtension'] is Map) ? PoiExtension.fromJson(jsonRes['poiExtension']) : null,
        provinceCode: jsonRes['provinceCode'],
        postcode: jsonRes['postcode'],
        typeCode: jsonRes['typeCode'],
        exit: exit,
        businessArea: jsonRes['businessArea'],
        provinceName: jsonRes['provinceName'],
        indoorData: (jsonRes['indoorData'] is Map) ? IndoorData.fromJson(jsonRes['indoorData']) : null,
        subPois: subPois);
  }

  int? distance;
  bool? isIndoorMap;
  String? cityCode;
  LatLng? latLonPoint;
  String? title;
  List<String>? photos;
  String? cityName;
  String? adCode;
  String? tel;
  LatLng? enter;
  String? poiId;
  String? email;
  String? typeDes;
  String? direction;
  String? adName;
  String? parkingType;
  String? website;
  PoiExtension? poiExtension;
  String? provinceCode;
  String? postcode;
  String? typeCode;
  LatLng? exit;
  String? businessArea;
  String? provinceName;
  IndoorData? indoorData;
  List<SubPois>? subPois;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'distance': distance,
        'isIndoorMap': isIndoorMap,
        'cityCode': cityCode,
        'latLonPoint': latLonPoint,
        'title': title,
        'photos': photos,
        'cityName': cityName,
        'adCode': adCode,
        'tel': tel,
        'enter': enter,
        'poiId': poiId,
        'email': email,
        'typeDes': typeDes,
        'direction': direction,
        'adName': adName,
        'parkingType': parkingType,
        'website': website,
        'poiExtension': poiExtension,
        'provinceCode': provinceCode,
        'postcode': postcode,
        'typeCode': typeCode,
        'exit': exit,
        'businessArea': businessArea,
        'provinceName': provinceName,
        'indoorData': indoorData,
      };
}

class PoiExtension {
  PoiExtension({
    this.rating,
    this.opentime,
  });

  factory PoiExtension.fromJson(Map jsonRes) => PoiExtension(
        rating: jsonRes['rating'],
        opentime: jsonRes['opentime'],
      );

  String? rating;
  String? opentime;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'rating': rating,
        'opentime': opentime,
      };
}

class IndoorData {
  IndoorData({
    this.floorName,
    this.poiId,
    this.floor,
  });

  factory IndoorData.fromJson(Map jsonRes) => IndoorData(
        floorName: jsonRes['floorName'],
        poiId: jsonRes['poiId'],
        floor: jsonRes['floor'],
      );

  String? floorName;
  String? poiId;
  int? floor;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'floorName': floorName,
        'poiId': poiId,
        'floor': floor,
      };
}

class SubPois {
  SubPois({
    this.distance,
    this.snippet,
    this.subName,
    this.subTypeDes,
    this.title,
    this.poiId,
    this.latLonPoint,
  });

  factory SubPois.fromJson(Map jsonRes) {
    var latLon = jsonRes['latLonPoint'];
    LatLng? latLonPoint;
    if (latLon is List && latLon.length > 1) {
      latLonPoint = LatLng(latLon[0], latLon[1]);
    }
    return SubPois(
        distance: jsonRes['distance'],
        snippet: jsonRes['snippet'],
        subName: jsonRes['subName'],
        poiId: jsonRes['poiId'],
        subTypeDes: jsonRes['subTypeDes'],
        title: jsonRes['title'],
        latLonPoint: latLonPoint);
  }

  double? distance;
  double? snippet;
  double? subName;
  double? subTypeDes;
  double? title;
  String? poiId;
  LatLng? latLonPoint;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'floorName': distance,
        'snippet': snippet,
        'subName': subName,
        'subTypeDes': subTypeDes,
        'title': title,
        'latLonPoint': latLonPoint,
        'poiId': poiId,
      };
}
