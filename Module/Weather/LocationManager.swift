struct WeatherModel: HandyJSON {
    /// 室外温度
    var temp: String?
    /// 体感温度
    var feelsLike: String?
    /// 天气状况描述
    var text: String?
    /// 风力等级
    var windScale: String?
    /// 降水量
    var precip: String?
    /// 能见度
    var vis: String?
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    private static let obj = LocationManager()
    private static let manager = CLLocationManager()
    public static var location: CLLocationCoordinate2D?
    private static var weatherHandle: ((WeatherModel) -> Void)?
    
    // MARK: 获取经纬度
    static func startLocation() {
        manager.delegate = obj
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.startUpdatingLocation()
    }
    
    /**
     获取天气信息
     
     - parameter res: 天气信息结果回调
     */
    
    // MARK: 获取天气信息
    static func requestWeather(_ res: @escaping ((WeatherModel) -> Void))  {
        let lat = location?.latitude.i.str
        let lon = location?.longitude.i.str
        // 非空校验
        guard lat != nil, lon != nil else { return }
        let location = String(format: "%@,%@", lon!,lat!)
        
        let url = "https://devapi.qweather.com/v7/weather/now"
        let param = ["location": location, "key": "cb31058f3ead4f26b0e085435006037a"]
        AF.request(url, method: .get, parameters: param).responseJSON { responseData in
            
            let data = responseData.value as? [String: Any]
            // 非空校验
            guard data != nil else { return }
            
            let code = data!["code"] as? String
            // 非空校验
            guard code == "200" else { return }
            
            let now = data!["now"] as? [String: Any]
            // 非空校验
            guard now != nil else { return }
            
            let model = WeatherModel.deserialize(from: now)
            // 非空校验
            guard model != nil else { return }
            
            res(model!)
        }
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let cLLocation = locations.last
        guard let coordinate = cLLocation?.coordinate else { return }
        manager.stopUpdatingLocation()
        LocationManager.location = coordinate
    }
}
