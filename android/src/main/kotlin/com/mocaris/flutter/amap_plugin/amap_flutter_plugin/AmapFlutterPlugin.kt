package com.mocaris.flutter.amap_plugin.amap_flutter_plugin

import android.content.Context

import androidx.annotation.NonNull
import com.amap.api.services.core.LatLonPoint
import com.amap.api.services.core.PoiItem
import com.amap.api.services.geocoder.*
import com.amap.api.services.poisearch.PoiResult
import com.amap.api.services.poisearch.PoiSearch

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** AmapFlutterPlugin */
class AmapFlutterPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "mocaris_amap_flutter_plugin")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "updatePrivacyAgree" -> {
//                val agree = call.argument<Boolean>("agree")
                result.success(null)
            }
            "updatePrivacyShow" -> {
//                val show = call.argument<Boolean>("show")
//                val containPrivacy = call.argument<Boolean>("containPrivacy")
                result.success(null)
            }
            "setApiKey" -> {

//                val apiKey=call.argument<String>("apiKey")
                result.success(null)
            }
            //poiId搜索
            "poiSearchId" -> {
                val poiId = call.argument<String>("poiId")
                val poiSearch = PoiSearch(context, null)
                poiSearch.setOnPoiSearchListener(object : PoiSearch.OnPoiSearchListener {
                    override fun onPoiSearched(poiResult: PoiResult, code: Int) {}

                    override fun onPoiItemSearched(poiItem: PoiItem, code: Int) {
                        if (code == 1000) {
                            val poiItem2Map = poiItem2Map(poiItem)
                            result.success(poiItem2Map)
                        } else {
                            result.error("$code", "", "")
                        }
                    }
                })
                poiSearch.searchPOIIdAsyn(poiId)
            }
            //poi搜索
            "poiSearch" -> {
                val keyWord = call.argument<String>("keyWord")
                val city = call.argument<String>("city")
                val cityLimit = call.argument<Boolean>("cityLimit")?:false
                val page = call.argument<Int>("page") ?: 1
                val pageSize = call.argument<Int>("pageSize") ?: 10
                val requireSubPOIs = call.argument<Boolean>("requireSubPOIs") ?: false
                //keyWord表示搜索字符串，
                //第二个参数表示POI搜索类型，二者选填其一，选用POI搜索类型时建议填写类型代码，码表可以参考下方（而非文字）
                //cityCode表示POI搜索区域，可以是城市编码也可以是城市名称，也可以传空字符串，空字符串代表全国在全国范围内进行搜索
                val poiSearch = PoiSearch(context, PoiSearch.Query(keyWord, "", city).apply {
                    this.pageNum = page
                    this.pageSize = pageSize
                    this.requireSubPois(requireSubPOIs)
                    this.cityLimit=cityLimit
                })
                poiSearch.setOnPoiSearchListener(object : PoiSearch.OnPoiSearchListener {
                    override fun onPoiSearched(poiResult: PoiResult, code: Int) {
                        if (code == 1000) {
                            val map = HashMap<String, Any>().apply {
                                this["pois"] = poiResult.pois.map { poiItem -> poiItem2Map(poiItem) }
                                this["searchSuggestionKeywords"] = poiResult.searchSuggestionKeywords
                                this["searchSuggestionCitys"] = poiResult.searchSuggestionCitys.map { city ->
                                    HashMap<String, Any>().apply {
                                        this["adCode"] = city.adCode
                                        this["cityCode"] = city.cityCode
                                        this["cityName"] = city.cityName
                                        this["suggestionNum"] = city.suggestionNum
                                    }
                                }
                            }
                            result.success(map)
                        } else {
                            result.error("$code", "", "")
                        }
                    }

                    override fun onPoiItemSearched(poiItem: PoiItem, code: Int) {}

                })
                poiSearch.searchPOIAsyn()
            }
            //地理编码（地址转坐标）
            "geocodeSearch" -> {
                val address = call.argument<String>("address")!!
                val city = call.argument<String>("cityCode")
                val country = call.argument<String>("country")
                val geocodeSearch = GeocodeSearch(context).apply {
                    this.setOnGeocodeSearchListener(object : GeocodeSearch.OnGeocodeSearchListener {
                        override fun onRegeocodeSearched(regResult: RegeocodeResult, code: Int) {
                        }

                        override fun onGeocodeSearched(geoResult: GeocodeResult, code: Int) {
                            if (1000 == code) {
                                val geocodeAddressList = geoResult.geocodeAddressList
                                result.success(geocodeAddressList.map { address -> geoAddress2Map(address) })
                            } else {
                                result.error("$code", "", "")
                            }
                        }
                    })
                }
                //name表示地址，第二个参数表示查询城市，中文或者中文全拼，citycode、adcode
                val request = GeocodeQuery(address, city).apply {
                    if (null != country) {
                        this.country = country
                    }
                }
                geocodeSearch.getFromLocationNameAsyn(request)
            }
            //逆地理编码（坐标转地址）
            "regeoSearch" -> {
                val latLonPoint = call.argument<List<Double>>("address")!!
                val distance = call.argument<Int>("distance")!!
                //// 第一个参数表示一个Latlng，第二参数表示范围多少米，第三个参数表示是火系坐标系还是GPS原生坐标系
                val regeocodeQuery = RegeocodeQuery(LatLonPoint(latLonPoint[0], latLonPoint[1]), distance.toFloat(), GeocodeSearch.AMAP)
                val geocodeSearch = GeocodeSearch(context).apply {
                    this.setOnGeocodeSearchListener(object : GeocodeSearch.OnGeocodeSearchListener {
                        override fun onRegeocodeSearched(regResult: RegeocodeResult, code: Int) {
                            if (1000 == code) {
                                val regeocodeAddress = regResult.regeocodeAddress
                                result.success(regeoAddessResult2Map(regeocodeAddress))
                            } else {
                                result.error("$code", "", "")
                            }
                        }

                        override fun onGeocodeSearched(geoResult: GeocodeResult, code: Int) {
                        }
                    })
                }
                geocodeSearch.getFromLocationAsyn(regeocodeQuery)
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun poiItem2Map(poiItem: PoiItem): HashMap<String, Any?> {
        return HashMap<String, Any?>().apply {
            this["adCode"] = poiItem.adCode
            this["adName"] = poiItem.adName
            this["businessArea"] = poiItem.businessArea
            this["cityCode"] = poiItem.cityCode
            this["cityName"] = poiItem.cityName
            this["direction"] = poiItem.direction
            this["distance"] = poiItem.distance
            this["email"] = poiItem.email
            this["enter"] = poiItem.enter?.let {
                doubleArrayOf(it.latitude, it.longitude)
            }
            this["exit"] = poiItem.exit?.let {
                doubleArrayOf(it.latitude, it.longitude)
            }
            this["indoorData"] = HashMap<String, Any>().apply {
                val indoorData = poiItem.indoorData
                this["floor"] = indoorData.floor
                this["floorName"] = indoorData.floorName
                this["poiId"] = indoorData.poiId
            }
            this["isIndoorMap"] = poiItem.isIndoorMap
            this["latLonPoint"] = poiItem.latLonPoint?.let {
                doubleArrayOf(it.latitude, it.longitude)
            }
            this["parkingType"] = poiItem.parkingType
            this["photos"] = poiItem.photos?.map { photo ->
                HashMap<String, String>().apply {
                    this["title"] = photo.title
                    this["url"] = photo.url
                }
            }
            this["poiExtension"] = HashMap<String, String>().apply {
                val poiExtension = poiItem.poiExtension
                this["opentime"] = poiExtension.opentime
                this["rating"] = poiExtension.getmRating()
            }
            this["poiId"] = poiItem.poiId
            this["postcode"] = poiItem.postcode
            this["provinceCode"] = poiItem.provinceCode
            this["provinceName"] = poiItem.provinceName
            this["tel"] = poiItem.tel
            this["title"] = poiItem.title
            this["typeCode"] = poiItem.typeCode
            this["typeDes"] = poiItem.typeDes
            this["website"] = poiItem.website
            this["subPois"] = poiItem.subPois?.map { sub ->
                HashMap<String, Any?>().apply {
                    this["distance"] = sub.distance
                    this["latLonPoint"] = sub.latLonPoint?.let {
                        doubleArrayOf(it.latitude, it.longitude)
                    }
                    this["poiId"] = sub.poiId
                    this["snippet"] = sub.snippet
                    this["subName"] = sub.subName
                    this["subTypeDes"] = sub.subTypeDes
                    this["title"] = sub.title
                }
            }
        }
    }

    private fun geoAddress2Map(address: GeocodeAddress): HashMap<String, Any?> {
        println(address)
        return HashMap<String, Any?>().apply {
            this["adcode"] = address.adcode
            this["building"] = address.building
            this["city"] = address.city
            this["country"] = address.country
            this["district"] = address.district
            this["formatAddress"] = address.formatAddress
            this["level"] = address.level
            this["neighborhood"] = address.neighborhood
            this["postcode"] = address.postcode
            this["province"] = address.province
            this["township"] = address.township
            this["latLonPoint"] = address.latLonPoint?.let {
                doubleArrayOf(it.latitude, it.longitude)
            }
        }
    }

    private fun regeoAddessResult2Map(result: RegeocodeAddress): Map<String, Any?> {
        println(result.formatAddress)
        println(result.roads.toString())
        println(result.crossroads.toString())
        return HashMap<String, Any?>().apply {
            this["formatAddress"] = result.formatAddress
            this["pois"] = result.pois.map { poiItem -> poiItem2Map(poiItem) }
            this["roads"] = result.roads.map { road ->
                HashMap<String, Any?>().apply {
                    this["direction"] = road.direction
                    this["distance"] = road.distance
                    this["id"] = road.id
                    this["location"] = road.latLngPoint?.let {
                        doubleArrayOf(it.latitude, it.longitude)
                    }
                    this["name"] = road.name
                }
            }
            this["crossroads"] = result.crossroads.map { road ->
                HashMap<String, Any?>().apply {
                    this["direction"] = road.direction
                    this["distance"] = road.distance
                    this["firstRoadId"] = road.firstRoadId
                    this["firstRoadName"] = road.firstRoadName
                    this["secondRoadId"] = road.secondRoadId
                    this["secondRoadName"] = road.secondRoadName
                    this["location"] = road.centerPoint?.let {
                        doubleArrayOf(it.latitude, it.longitude)
                    }
                }
            }
            this["aois"] = result.aois.map { aoiItem ->
                HashMap<String, Any?>().apply {
                    this["adCode"] = aoiItem.adCode
                    this["aoiArea"] = aoiItem.aoiArea
                    this["aoiId"] = aoiItem.aoiId
                    this["aoiName"] = aoiItem.aoiName
                    this["location"] = aoiItem.aoiCenterPoint?.let {
                        doubleArrayOf(it.latitude, it.longitude)
                    }
                }
            }
        }
    }
}
