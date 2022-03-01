import AMapFoundationKit
import AMapSearchKit
import Flutter
import UIKit

public class SwiftAmapFlutterPlugin: NSObject, FlutterPlugin, AMapSearchDelegate {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "mocaris_amap_flutter_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftAmapFlutterPlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        callback.onPOISearchDone(request: request!, response: response!)
    }
    
    public func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        callback.aMapSearchRequest(request: request, didFailWithError: error)
    }
 
    public func onGeocodeSearchDone(_ request: AMapGeocodeSearchRequest!, response: AMapGeocodeSearchResponse!) {
        callback.onGeocodeSearchDone(request: request, response: response)
    }

    public func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        callback.onReGeocodeSearchDone(request: request, response: response)
    }
 
    init(channel: FlutterMethodChannel) {
        self.flutterChannel = channel
        callback = SearchCallback(channel: self.flutterChannel)
        super.init()
    }
    
    private let flutterChannel: FlutterMethodChannel

    private let callback: SearchCallback
    
    private var searchApi: AMapSearchAPI? = nil

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "updatePrivacyAgree":
            let args = call.arguments as! [String: Any]
            let agree = args["agree"] as! Bool
            AMapSearchAPI.updatePrivacyAgree(agree ? AMapPrivacyAgreeStatus.didAgree : AMapPrivacyAgreeStatus.notAgree)
            result(true)
            
        case "updatePrivacyShow":
            let args = call.arguments as! [String: Any]
            let show = args["agree"] as! Bool
            let agree = args["containPrivacy"] as! Bool
            AMapSearchAPI.updatePrivacyShow(show ? AMapPrivacyShowStatus.didShow : AMapPrivacyShowStatus.notShow,
                                            privacyInfo: agree ? AMapPrivacyInfoStatus.didContain : AMapPrivacyInfoStatus.notContain)
            result(true)
            
        case "setApiKey":
            let args = call.arguments as! [String: Any]
            let apiKey = args["iosKey"] as! String
            AMapServices.shared().apiKey = apiKey
            if searchApi == nil {
                searchApi = AMapSearchAPI.init()
                searchApi?.delegate = self
            }
            result(true)
//            poiId搜索
        case "poiSearchId":
            let args = call.arguments as! [String: Any]
            let poiId = args["poiId"] as! String
            let request = AMapPOIIDSearchRequest()
            request.requireSubPOIs = false
            request.uid = poiId
            request.requireExtension = true
            searchApi?.aMapPOIIDSearch(request)
            result(true)
            
        // poi搜索
        case "poiSearch":
            let args = call.arguments as! [String: Any]
            let request = AMapPOIKeywordsSearchRequest()
            request.keywords = args["keyWord"] as? String
            request.city = args["city"] as? String ?? ""
            let type = args["type"] as? String
            if type != nil {
                request.types = type
            }
            let location = args["location"] as? [Double]
            if location != nil {
                request.location = AMapGeoPoint.location(withLatitude: CGFloat(location![0]), longitude: CGFloat(location![1]))
            }
            request.page = args["page"] as? Int ?? 1
            request.offset = args["pageSize"] as? Int ?? 10
            request.cityLimit = args["cityLimit"] as? Bool ?? false
            request.requireSubPOIs = (args["requireSubPOIs"] as? Bool) ?? false
            request.requireExtension = true
            searchApi?.aMapPOIKeywordsSearch(request)
            result(true)
        // 地理编码（地址转坐标）
        case "geocodeSearch":
            let args = call.arguments as! [String: Any]
            let address = args["address"] as! String
            let city = args["city"] as? String
            let country = args["country"] as? String
            let request = AMapGeocodeSearchRequest()
            if country != nil {
                request.country = country
            }
            if city != nil {
                request.city = city
            }
            request.address = address
            searchApi?.aMapGeocodeSearch(request)
            result(true)
        // 逆地理编码（坐标转地址）
        case "regeoSearch":
            let args = call.arguments as! [String: Any]
            let latLon = args["address"] as! [Double]
            let distance = args["distance"] as! Int
            let request = AMapReGeocodeSearchRequest()
            request.poitype = "autonavi"
            let point = AMapGeoPoint()
            point.latitude = latLon[0]
            point.longitude = latLon[1]
            request.location = point
            request.radius = distance
            searchApi?.aMapReGoecodeSearch(request)
            result(true)
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
