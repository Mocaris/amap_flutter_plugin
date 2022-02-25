import 'dart:async';
import 'package:amap_flutter_base/amap_flutter_base.dart' as base;
import 'package:amap_flutter_plugin/model/geo_address.dart';
import 'package:amap_flutter_plugin/model/poi_search_result.dart';
import 'package:amap_flutter_plugin/model/regeo_search_result.dart';
import 'package:flutter/services.dart';

import 'model/poiItem.dart';

export 'package:amap_flutter_plugin/model/poiItem.dart';
export 'package:amap_flutter_plugin/model/geo_address.dart';
export 'package:amap_flutter_plugin/model/poi_search_result.dart';

class AmapFlutterPlugin {
  AmapFlutterPlugin._();

 static const MethodChannel _channel = MethodChannel('mocaris_amap_flutter_plugin');

  static Future setApiKey({required String iosKey}) async {
    await _channel.invokeMethod("setApiKey", {"iosKey": iosKey});
  }

  /// require for ios
  //是否同意
  static Future updatePrivacyAgree({required bool agree}) async {
    await _channel.invokeMethod("updatePrivacyAgree", {"agree": agree});
  }

  /// require for ios
//是否显示弹窗
  static Future updatePrivacyShow({required bool agree, required bool containPrivacy}) async {
    await _channel.invokeMethod("updatePrivacyShow", {"agree": agree, "containPrivacy": containPrivacy});
  }

  //poiId搜索
   Future<PoiItem?> poiSearchId({required String poiId}) async {
    var res = await _channel.invokeMapMethod<String, dynamic>("poiSearchId", {"poiId": poiId});
    return null != res ? PoiItem.fromJson(res) : null;
  }

  //poi搜索
   Future<PoiSearchResult?> poiSearch(
      {required String keyWord,
      String? cityCode,
      String? type,
      required int page,
      required int pageSize,
      bool requireSubPOIs = false}) async {
    var res = await _channel.invokeMapMethod<String, dynamic>("poiSearch",
        {"keyWord": keyWord, "city": cityCode, "type": type, "page": page, "pageSize": pageSize, "requireSubPOIs": requireSubPOIs});
    return null != res ? PoiSearchResult.fromJson(res) : null;
  }

  //地理编码（地址转坐标）
   Future<List<GeoAddress>> geocodeSearch({required String address, String? cityCode, String? country}) async {
    var res = await _channel.invokeListMethod("geocodeSearch", {"address": address, "cityCode": cityCode, "country": country});
    return null != res ? res.map((e) => GeoAddress.fromJson(e)).toList() : <GeoAddress>[];
  }

  //逆地理编码（坐标转地址）
   Future<ReGeoSearchResult?> regeoSearch({required base.LatLng latLon, int distance = 50}) async {
    var res = await _channel.invokeMapMethod("regeoSearch", {
      "address": <double>[latLon.latitude, latLon.longitude],
      "distance": distance
    });
    return null != res ? ReGeoSearchResult.fromJson(res) : null;
  }
}
