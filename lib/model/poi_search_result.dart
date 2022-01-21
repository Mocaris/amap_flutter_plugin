import 'dart:convert';

import 'package:amap_flutter_plugin/amap_flutter_plugin.dart';

class PoiSearchResult {
  PoiSearchResult({this.searchSuggestionCitys, this.searchSuggestionKeywords, this.pois});

  factory PoiSearchResult.fromJson(Map jsonRes) {
    var wordsJson = jsonRes["searchSuggestionKeywords"];
    var cityJson = jsonRes["searchSuggestionCitys"];
    var poisJson = jsonRes["pois"];

    return PoiSearchResult(
      searchSuggestionCitys: (cityJson is List) ? cityJson.map((e) => SuggestCity.fromJson(e)).toList() : null,
      searchSuggestionKeywords: (wordsJson is List) ? wordsJson.map((e) => e.toString()).toList() : null,
      pois: (poisJson is List) ? poisJson.map((e) => PoiItem.fromJson(e)).toList() : null,
    );
  }

  List<String>? searchSuggestionKeywords;
  List<SuggestCity>? searchSuggestionCitys;
  List<PoiItem>? pois;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'pois': pois,
        'searchSuggestionCitys': searchSuggestionCitys,
        'searchSuggestionKeywords': searchSuggestionKeywords,
      };
}

class SuggestCity {
  SuggestCity({
    required this.adCode,
    required this.cityCode,
    required this.suggestionNum,
  });

  factory SuggestCity.fromJson(Map jsonRes) => SuggestCity(
        adCode: jsonRes['adCode'],
        cityCode: jsonRes['cityCode'],
        suggestionNum: jsonRes['suggestionNum'],
      );

  String? adCode;
  String? cityCode;
  int? suggestionNum;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'adCode': adCode,
        'cityCode': cityCode,
        'suggestionNum': suggestionNum,
      };
}
