//
//  SearchCallback.swift
//  amap_flutter_plugin
//
//  Created by Mocaris on 2022/1/20.
//
import AMapFoundationKit
import AMapSearchKit
import Flutter

class SearchCallback {
    
    private let flutterChannel : FlutterMethodChannel
    
     init(channel : FlutterMethodChannel) {
         self.flutterChannel = channel
    }
   
    public func aMapSearchRequest(request: Any!, didFailWithError error: Error!) {
        print("aMapSearchRequest-------------\(error.localizedDescription)")
    }

    //poi搜索
    public func onPOISearchDone(request:  AMapPOISearchBaseRequest,
                                response: AMapPOISearchResponse) {
        if(request is AMapPOIIDSearchRequest){
            if response.count != 0 {
                let poiMap = poiItem2Map(poiItem: response.pois.first!)
                flutterChannel.invokeMethod("poiSearchId", arguments:poiMap)
            }
        }else{
              let suggestion = response.suggestion
              let poiInfo = [
                "pois":response.pois.map{(item:AMapPOI) -> [String:Any?] in
                      poiItem2Map(poiItem: item)
                  },
                  "searchSuggestionKeywords":suggestion?.keywords ,
                  "searchSuggestionCitys": suggestion?.cities?.map{(c : AMapCity) -> [String:Any?] in
                      [
                       "cityName":c.city,
                       "cityCode": c.citycode,
                       "adcode": c.adcode,
                       "suggestionNum": c.num
                      ] as [String : Any?]
                  },
              ] as [String : Any?]
            flutterChannel.invokeMethod("poiSearch", arguments:poiInfo)
        }
    }
    
    
    //地理编码（地址转坐标）
    public func onGeocodeSearchDone(request: AMapGeocodeSearchRequest!, response: AMapGeocodeSearchResponse!) {
        let codes =  response.geocodes
        if codes != nil{
            let list = codes!.map { (code : AMapGeocode) -> [String : Any?] in
               return geoAddress2Map(geoCode: code)
            }
            flutterChannel.invokeMethod("geocodeSearch", arguments: list)
        }
    }
    
    //逆地理编码（坐标转地址）
    public func onReGeocodeSearchDone(request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        let regeoCode =  response.regeocode
        if regeoCode != nil{
         let map = regeoAddessResult2Map(regeoCode: regeoCode!)
            flutterChannel.invokeMethod("regeoSearch", arguments: map)
        }
    }

    private func regeoAddessResult2Map(regeoCode : AMapReGeocode) -> [String : Any?]  {
        let map : [String : Any?] = [
            "formatAddress" : regeoCode.formattedAddress,
            "roads" : regeoCode.roads?.map{(road : AMapRoad) -> [String:Any?] in
                return [
                    "id":road.uid,
                    "direction":road.direction,
                    "distance":road.distance,
                    "name":road.name,
                    "location":[road.location.latitude,road.location.longitude],
                ]
            },
            "crossroads" : regeoCode.roadinters?.map{ (inter : AMapRoadInter) -> [String : Any?] in
                return [
                    "distance" : inter.distance,
                    "direction" : inter.direction,
                    "location" : [inter.location.latitude,inter.location.longitude],
                    "firstRoadId" : inter.firstId,
                    "firstRoadName" : inter.firstName,
                    "secondRoadId" : inter.secondId,
                    "secondRoadName" : inter.secondName,
                ]
            },
            "pois" : regeoCode.pois?.map({ (poi : AMapPOI) -> [String : Any?] in
                return poiItem2Map(poiItem: poi)
            }),
            "aois" : regeoCode.aois?.map{ (aoi : AMapAOI ) -> [String : Any?] in
                return [
                    "adCode" : aoi.adcode,
                    "aoiArea" : aoi.area,
                    "aoiId" : aoi.uid,
                    "aoiName" : aoi.name,
                    "location" : [aoi.location.latitude,aoi.location.longitude],
                ]
            }
        ]
        return map
    }
    
    private func geoAddress2Map(geoCode : AMapGeocode)->[String : Any?]{
        let map : [String : Any?] = [
            "adcode" : geoCode.adcode,
            "building" : geoCode.building,
            "city" : geoCode.city,
            "cityCode" : geoCode.citycode,
            "country" : geoCode.country,
            "district" : geoCode.district,
            "formatAddress" : geoCode.formattedAddress,
            "level" : geoCode.level,
            "neighborhood" : geoCode.neighborhood,
            "postcode" : geoCode.postcode,
            "province" : geoCode.province,
            "township" : geoCode.township,
            "latLonPoint" : geoCode.location != nil ? [geoCode.location.longitude,geoCode.location.longitude] : nil
        ]
        return map
    }
    
    
    private func poiItem2Map(poiItem:AMapPOI) -> [String : Any?]{
       let indoorData =  poiItem.indoorData
       let extensionInfo = poiItem.extensionInfo
        let map : [String : Any?]  = [
        "adCode" : poiItem.adcode,
        "adName": poiItem.district,
        "businessArea" : poiItem.businessArea,
        "cityCode" : poiItem.citycode,
        "cityName":poiItem.city,
        "direction":poiItem.direction,
        "distance":poiItem.distance,
        "email":poiItem.email,
        "enter":poiItem.enterLocation != nil ? [poiItem.enterLocation.latitude,poiItem.enterLocation.longitude] : nil,
        "exit":poiItem.exitLocation != nil ? [poiItem.exitLocation.latitude,poiItem.exitLocation.longitude] : nil,
        "indoorData":["floor" : indoorData?.floor ,"floorName" : indoorData?.floorName,"poiId" : indoorData?.pid] as [String : Any?],
        "isIndoorMap":poiItem.hasIndoorMap,
        "latLonPoint":poiItem.location != nil ?  [poiItem.location.latitude,poiItem.location.longitude] : nil,
        "parkingType":poiItem.parkingType,
        "photos":poiItem.images?.map{ (img) -> [String : Any?] in
               return [
                "title":img.title,
                "url":img.url
               ]
        },
        "poiExtension": [
            "opentime":extensionInfo?.openTime,
            "rating":extensionInfo?.rating == nil ? "" : "\(String(describing: extensionInfo?.rating))"
        ] as [String : Any?],
        "poiId":poiItem.uid,
        "postcode":poiItem.postcode,
        "provinceCode":poiItem.pcode,
        "provinceName":poiItem.province,
        "tel":poiItem.tel,
        "title":poiItem.name,
        "typeCode":poiItem.typecode,
        "typeDes":poiItem.type,
        "website":poiItem.website,
        "subPois":poiItem.subPOIs?.map{ (sub : AMapSubPOI) -> [String : Any?] in
            return [
                "distance":sub.distance,
                "latLonPoint":sub.location != nil ? [sub.location.latitude,sub.location.longitude] : nil,
                "poiId":sub.uid,
                "subName":sub.sname,
                "snippet":sub.address,
                "subTypeDes":sub.subtype,
                "title":sub.name
            ]
        }
        ]
        return map
    }
    
}
