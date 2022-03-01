import 'dart:async';

import 'package:amap_flutter_base/amap_flutter_base.dart' as base;
import '/model/geo_address.dart';
import '/model/geo_result.dart';
import '/model/poiItem.dart';
import '/model/poi_result.dart';
import '/model/poi_search_result.dart';
import '/model/regeo_search_result.dart';
import 'package:flutter/services.dart';

export '/model/geo_address.dart';
export '/model/poiItem.dart';
export '/model/poi_result.dart';
export '/model/geo_result.dart';
export '/model/poi_search_result.dart';

final MethodChannel _channel = const MethodChannel('mocaris_amap_flutter_plugin')..setMethodCallHandler((call) => _callHandler(call));

StreamController<dynamic> _callEventHandlerController = StreamController.broadcast();

Future<void> _callHandler(MethodCall call) async {
  var arg = call.arguments;
  switch (call.method) {
    case "poiSearchId":
      if (arg is Map) {
        _callEventHandlerController.add(PoiIdSearchResult(PoiItem.fromJson(arg)));
      }
      break;
    case "poiSearch":
      if (arg is Map) {
        _callEventHandlerController.add(PoiSearchResult.fromJson(arg));
      }
      break;
    case "geocodeSearch":
      if (arg is List) {
        _callEventHandlerController.add(GeoSearchResult(List.from(arg.map((e) => GeoAddress.fromJson(e)))));
      }
      break;
    case "regeoSearch":
      if (arg is Map) {
        _callEventHandlerController.add(ReGeoSearchResult.fromJson(arg));
      }
      break;
  }
}

class AmapFlutterPlugin {


  ///[PoiIdSearchResult] poiId 搜索结果
  ///[PoiSearchResult] poi关键字 搜索结果
  ///[GeoSearchResult] 地理编码（地址转坐标）结果
  ///[ReGeoSearchResult] 逆地理编码（坐标转地址）结果
  Stream<dynamic> get resultEventHandler => _callEventHandlerController.stream;

  static Future setApiKey(String androidKey, String iosKey) async {
    await _channel.invokeMethod("setApiKey", {"iosKey": iosKey, "androidKey": androidKey});
  }

  //是否同意
  static Future updatePrivacyAgree(bool agree) async {
    await _channel.invokeMethod("updatePrivacyAgree", {"agree": agree});
  }

//是否显示弹窗
  static Future updatePrivacyShow(bool agree, bool containPrivacy) async {
    await _channel.invokeMethod("updatePrivacyShow", {"agree": agree, "containPrivacy": containPrivacy});
  }

  //poiId搜索
  Future poiSearchId({required String poiId}) async {
    await _channel.invokeMethod("poiSearchId", {"poiId": poiId});
  }

  //poi搜索
  Future poiSearch(
      {required String keyWord,
      String? cityCode,
      String? type,
      base.LatLng? location,
      required int page,
      required int pageSize,
      bool cityLimit = false,
      bool requireSubPOIs = false}) async {
    await _channel.invokeMethod("poiSearch", {
      "keyWord": keyWord,
      "city": cityCode,
      "type": type,
      "page": page,
      "pageSize": pageSize,
      "cityLimit": cityLimit,
      "location": null != location ? <double>[location.latitude, location.longitude] : null,
      "requireSubPOIs": requireSubPOIs
    });
  }

  //地理编码（地址转坐标）
  Future geocodeSearch({required String address, String? cityCode, String? country}) async {
    await _channel.invokeMethod("geocodeSearch", {"address": address, "cityCode": cityCode, "country": country});
  }

  //逆地理编码（坐标转地址）
  Future regeoSearch({required base.LatLng latLon, int distance = 50}) async {
    await _channel.invokeMethod("regeoSearch", {
      "address": <double>[latLon.latitude, latLon.longitude],
      "distance": distance
    });
  }
}
