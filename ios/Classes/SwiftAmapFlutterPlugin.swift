import AMapFoundationKit
import AMapSearchKit
import Flutter
import UIKit

public class SwiftAmapFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "amap_flutter_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftAmapFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "updatePrivacyAgree":
            let args = call.arguments as! [String: Any]
            let agree = args["agree"] as! Bool
            AMapSearchAPI.updatePrivacyAgree(agree ? AMapPrivacyAgreeStatus.didAgree : AMapPrivacyAgreeStatus.notAgree)
        case "updatePrivacyShow":
            let args = call.arguments as! [String: Any]
            let show = args["show"] as! Bool
            let agree = args["containPrivacy"] as! Bool
            AMapSearchAPI.updatePrivacyShow(show ? AMapPrivacyShowStatus.didShow : AMapPrivacyShowStatus.notShow,
                                            privacyInfo: agree ? AMapPrivacyInfoStatus.didContain : AMapPrivacyInfoStatus.notContain)
        case "setApiKey":
            let args = call.arguments as! [String: Any]
            let apiKey = args["iosKey"] as! String
            AMapServices.shared().apiKey = apiKey
            result(nil)
//            poiId搜索
        case "poiSearchId":
            let poiId = call.value(forKey: "poiId") as! String
            let request = AMapPOIIDSearchRequest()
            request.requireSubPOIs = false
            request.uid = poiId
            let search = AMapSearchAPI()!
            let callback = SearchCallback(result: result, poiIdSearch: true)
            search.delegate = callback
            search.aMapPOIIDSearch(request)

        // poi搜索
        case "poiSearch":
            let args = call.arguments as! [String: Any]
            let request = AMapPOIKeywordsSearchRequest()
            request.keywords = args["keyWord"] as? String
            request.city = args["city"] as? String ?? ""
            request.types = args["type"] as? String ?? ""
            request.page = args["page"] as? Int ?? 1
            request.offset = args["pageSize"] as? Int ?? 10
            request.cityLimit = args["cityLimit"] as? Bool ?? false
            request.requireSubPOIs = (args["requireSubPOIs"] as? Bool) ?? false
            let search = AMapSearchAPI()
            search!.aMapPOIKeywordsSearch(request)
            let callback = SearchCallback(result: result, poiIdSearch: false)
            search!.delegate = callback
        // 地理编码（地址转坐标）
        case "geocodeSearch":
            let args = call.arguments as! [String: Any]
            let address = args["address"] as! String
            let city = args["city"] as? String
            let country = args["country"] as? String
            let search = AMapSearchAPI()!
            let request = AMapGeocodeSearchRequest()
            if country != nil {
                request.country = country
            }
            if city != nil {
                request.city = city
            }
            request.address = address
            search.aMapGeocodeSearch(request)
            let callback = SearchCallback(result: result)
            search.delegate = callback

        // 逆地理编码（坐标转地址）
        case "regeoSearch":
            let args = call.arguments as! [String: Any]
            let latLon = args["latLon"] as! [Double]
            let distance = args["distance"] as! Int
            let search = AMapSearchAPI()!
            let request = AMapReGeocodeSearchRequest()
            request.poitype = "autonavi"
            let point = AMapGeoPoint()
            point.latitude = latLon[0]
            point.longitude = latLon[1]
            request.location = point
            request.radius = distance
            let callback = SearchCallback(result: result)
            search.delegate = callback
            search.aMapReGoecodeSearch(request)
        default:
            break
        }
    }
}
