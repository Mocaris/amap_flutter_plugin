import 'dart:convert';

import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_plugin/amap_flutter_plugin.dart';

class ReGeoSearchResult {
  ReGeoSearchResult({this.formatAddress, this.roads, this.crossroads, this.aois, this.pois});

  factory ReGeoSearchResult.fromJson(Map jsonRes) {
    final List<Roads> roads = (jsonRes['roads'] is List) ? (jsonRes['roads'] as List).map((e) => Roads.fromJson(e)).toList() : <Roads>[];
    final List<CrossRoads> crossroads =
        (jsonRes['crossroads'] is List) ? (jsonRes['crossroads'] as List).map((e) => CrossRoads.fromJson(e)).toList() : <CrossRoads>[];
    final List<AoiItem> aois = (jsonRes['aois'] is List) ? (jsonRes['aois'] as List).map((e) => AoiItem.fromJson(e)).toList() : <AoiItem>[];
    final List<PoiItem> pois = (jsonRes['pois'] is List) ? (jsonRes['pois'] as List).map((e) => PoiItem.fromJson(e)).toList() : <PoiItem>[];

    return ReGeoSearchResult(
      formatAddress: jsonRes['formatAddress'],
      roads: roads,
      crossroads: crossroads,
      aois: aois,
      pois: pois,
    );
  }

  String? formatAddress;
  List<Roads>? roads;
  List<CrossRoads>? crossroads;
  List<AoiItem>? aois;
  List<PoiItem>? pois;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "formatAddress": formatAddress,
        "roads": roads,
        "crossroads": crossroads,
        "aois": aois,
        "pois": pois,
      };
}

class Roads {
  Roads({this.direction, this.distance, this.id, this.location, this.name});

  factory Roads.fromJson(Map jsonRes) {
    var latLonPointJson = jsonRes['location'];
    LatLng? latLonPoint;
    if (latLonPointJson is List && latLonPointJson.length > 1) {
      latLonPointJson = LatLng(latLonPointJson[0], latLonPointJson[1]);
    }
    return Roads(
      direction: jsonRes['direction'],
      distance: jsonRes['distance'],
      id: jsonRes['id'],
      location: latLonPoint,
      name: jsonRes['name'],
    );
  }

  String? direction;
  double? distance;
  String? id;
  LatLng? location;
  String? name;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "name": name,
        "direction": direction,
        "distance": distance,
        "id": id,
        "location": location,
      };
}

class CrossRoads {
  CrossRoads({
    this.direction,
    this.distance,
    this.firstRoadId,
    this.firstRoadName,
    this.secondRoadId,
    this.secondRoadName,
    this.location,
  });

  factory CrossRoads.fromJson(Map jsonRes) {
    var latLonPointJson = jsonRes['location'];
    LatLng? latLonPoint;
    if (latLonPointJson is List && latLonPointJson.length > 1) {
      latLonPointJson = LatLng(latLonPointJson[0], latLonPointJson[1]);
    }
    return CrossRoads(
      direction: jsonRes['direction'],
      distance: jsonRes['distance'],
      firstRoadId: jsonRes['firstRoadId'],
      firstRoadName: jsonRes['firstRoadName'],
      secondRoadId: jsonRes['secondRoadId'],
      secondRoadName: jsonRes['secondRoadName'],
      location: latLonPoint,
    );
  }

  String? direction;
  double? distance;
  String? firstRoadId;
  String? firstRoadName;
  String? secondRoadId;
  String? secondRoadName;
  LatLng? location;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "direction": direction,
        "distance": distance,
        "firstRoadId": firstRoadId,
        "firstRoadName": firstRoadName,
        "secondRoadId": secondRoadId,
        "secondRoadName": secondRoadName,
        "location": location,
      };
}

class AoiItem {
  AoiItem({
    this.adCode,
    this.aoiArea,
    this.aoiId,
    this.aoiName,
    this.location,
  });

  factory AoiItem.fromJson(Map jsonRes) {
    var latLonPointJson = jsonRes['location'];
    LatLng? latLonPoint;
    if (latLonPointJson is List && latLonPointJson.length > 1) {
      latLonPointJson = LatLng(latLonPointJson[0], latLonPointJson[1]);
    }
    return AoiItem(
      adCode: jsonRes['adCode'],
      aoiArea: jsonRes['aoiArea'],
      aoiId: jsonRes['aoiId'],
      aoiName: jsonRes['aoiName'],
      location: latLonPoint,
    );
  }

  String? adCode;
  String? aoiArea;
  String? aoiId;
  String? aoiName;
  LatLng? location;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "adCode": adCode,
        "aoiArea": aoiArea,
        "aoiId": aoiId,
        "aoiName": aoiName,
        "location": location,
      };
}
