//
//  ViewController.swift
//  Weather App
//
//  Created by Luyện Hà Luyện on 03/07/2023.
//

import UIKit
import CoreLocation

var locationNESW = ""

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var currentWeather = WeatherResponse(coord: Coord(lat: 0.0,
                                                      lon: 0.0),
                                         weather: [Weather(main: "",
                                                           description: "",
                                                           icon: "")],
                                         main: MainWeather(temp: 0.0,
                                                           feels_like: 0.0,
                                                           temp_min: 0.0,
                                                           temp_max: 0.0,
                                                           humidity: 0),
                                         visibility: 0,
                                         wind: WindData(speed: 0.0,
                                                        deg: 00,
                                                        gust: 0.0),
                                         sys: Sys(sunrise: 0,
                                                  sunset: 0),
                                         name: "")
    
    var forecastWeather = ForecastWeather(list: [List(main: MainWeather(temp: 0.0,
                                                                        feels_like: 0.0,
                                                                        temp_min: 0.0,
                                                                        temp_max: 0.0,
                                                                        humidity: 0),
                                                      weather: [Weather(main: "",
                                                                        description: "",
                                                                        icon: "")],
                                                      wind: WindData(speed: 0.0,
                                                                     deg: 00,
                                                                     gust: 0.0),
                                                      visibility: 00,
                                                      dt_txt: "")])
    @IBOutlet weak var nameLocation: UILabel!
    @IBOutlet weak var imageMainWeather: UIImageView!
    @IBOutlet weak var infomationTV: UITextView!
    @IBOutlet weak var mainWeatherLB: UILabel!
    @IBOutlet weak var locationNE: UILabel!
    var numberOfSection: [String] = []

    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCurrentWeatherShow()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
        setupCurrentWeatherShow()
    }
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            weatherForLocation()
            setupCurrentWeatherShow()
        }
    }
    func setupCurrentWeatherShow() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.nameLocation.backgroundColor = .red
            self.nameLocation.textColor = .yellow
            self.nameLocation.text = " \(self.currentWeather.name)"

            let latitudeDegrees = Int(self.currentWeather.coord.lat)
            let latitudeMinutes = Int((self.currentWeather.coord.lat - Double(latitudeDegrees)) * 60)
            let latitudeSeconds = Int(((self.currentWeather.coord.lat - Double(latitudeDegrees)) * 60 - Double(latitudeMinutes)) * 60)

            let longitudeDegrees = Int(self.currentWeather.coord.lon)
            let longitudeMinutes = Int((self.currentWeather.coord.lon - Double(longitudeDegrees)) * 60)
            let longitudeSeconds = Int(((self.currentWeather.coord.lon - Double(longitudeDegrees)) * 60 - Double(longitudeMinutes)) * 60)

            let formattedLatitude = "\(latitudeDegrees)° \(latitudeMinutes)′ \(latitudeSeconds)″ N"
            let formattedLongitude = "\(longitudeDegrees)° \(longitudeMinutes)′ \(longitudeSeconds)″ E"
            self.locationNE.text = "\(formattedLatitude), \(formattedLongitude)   "
            self.locationNE.textColor = .yellow
            self.locationNE.backgroundColor = .red
            
            self.imageMainWeather.image = UIImage(named: self.currentWeather.weather[0].icon)
            
            let attributedForString = NSMutableAttributedString()
            // Current Temp
            let line1 = NSAttributedString(string: "\(String(self.currentWeather.main.temp).replacingOccurrences(of: ".", with: ","))°C\n", attributes: [.font: UIFont.systemFont(ofSize: 40), .foregroundColor: UIColor.red])
            // Độ ẩm
            let line2 = NSAttributedString(string: "Độ ẩm: \(String(self.currentWeather.main.humidity).replacingOccurrences(of: ".", with: ","))%\n", attributes: [.font: UIFont.systemFont(ofSize: 17), .foregroundColor: UIColor.link])
            // Feels like temp
            let line3 = NSAttributedString(string: "Cảm giác như: \(String(self.currentWeather.main.feels_like).replacingOccurrences(of: ".", with: ","))°C\n", attributes: [.font: UIFont.systemFont(ofSize: 17), .foregroundColor: UIColor.blue])
            // Temp min max
            let line4 = NSAttributedString(string: "Nhiệt độ cao nhất: \(String(self.currentWeather.main.temp_max).replacingOccurrences(of: ".", with: ","))°C\nNhiệt độ cao nhất: \(String(self.currentWeather.main.temp_min).replacingOccurrences(of: ".", with: ","))°C\n", attributes: [.font: UIFont.systemFont(ofSize: 17), .foregroundColor: UIColor.black])
            // Tốc độ gió
            let line5 = NSAttributedString(string: "Tốc độ gió: \(String(self.currentWeather.wind.speed).replacingOccurrences(of: ".", with: ",")) m/s\n", attributes: [.font: UIFont.systemFont(ofSize: 25), .foregroundColor: UIColor.purple])
            // Hướng gió
            var windDirection = ""
            if self.currentWeather.wind.deg >= 0, self.currentWeather.wind.deg < 45 {
                windDirection = "Đông Bắc"
            } else if self.currentWeather.wind.deg >= 45, self.currentWeather.wind.deg < 90 {
                windDirection = "Đông"
            } else if self.currentWeather.wind.deg >= 90, self.currentWeather.wind.deg < 135 {
                windDirection = "Đông Nam"
            } else if self.currentWeather.wind.deg >= 135, self.currentWeather.wind.deg < 180 {
                windDirection = "Nam"
            } else if self.currentWeather.wind.deg >= 180, self.currentWeather.wind.deg < 225 {
                windDirection = "Tây Nam"
            } else if self.currentWeather.wind.deg >= 225, self.currentWeather.wind.deg < 270 {
                windDirection = "Tây"
            } else if self.currentWeather.wind.deg >= 270, self.currentWeather.wind.deg < 315 {
                windDirection = "Tây Bắc"
            } else if self.currentWeather.wind.deg >= 315, self.currentWeather.wind.deg <= 360 {
                windDirection = "Bắc"
            }
            let line6 = NSAttributedString(string: "Hướng gió: \(windDirection)\n Gió giật: \(self.currentWeather.wind.gust)m/s\n", attributes: [.font: UIFont.systemFont(ofSize: 17), .foregroundColor: UIColor.black])
            // Gió giật
            let line7 = NSAttributedString(string: "Tầm nhìn xa: \(self.currentWeather.visibility / 1000) km\n", attributes: [.font: UIFont.systemFont(ofSize: 17), .foregroundColor: UIColor.black])
            // Giờ mặt trời mọc, lặn
            let unixTimestampSunrise = self.currentWeather.sys.sunrise
            let unixTimestampSunset = self.currentWeather.sys.sunset
            
            let hanoiTimeZone = TimeZone(identifier: "Asia/Ho_Chi_Minh")

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.timeZone = hanoiTimeZone

            let sunriseDate = Date(timeIntervalSince1970: TimeInterval(unixTimestampSunrise))
            let sunsetDate = Date(timeIntervalSince1970: TimeInterval(unixTimestampSunset))
            let formattedSunriseTime = dateFormatter.string(from: sunriseDate)
            let formattedSunsetTime = dateFormatter.string(from: sunsetDate)
            
            let line8 = NSAttributedString(string: "Bình minh: \(formattedSunriseTime)\n", attributes: [.font: UIFont.systemFont(ofSize: 17), .foregroundColor: UIColor.black])
            let line9 = NSAttributedString(string: "Hoàng hôn: \(formattedSunsetTime)", attributes: [.font: UIFont.systemFont(ofSize: 17), .foregroundColor: UIColor.black])

            attributedForString.append(line1)
            attributedForString.append(line2)
            attributedForString.append(line3)
            attributedForString.append(line4)
            attributedForString.append(line5)
            attributedForString.append(line6)
            attributedForString.append(line7)
            attributedForString.append(line8)
            attributedForString.append(line9)
            
            self.infomationTV.attributedText = attributedForString
            self.infomationTV.textAlignment = .center
            
            self.mainWeatherLB.text = self.currentWeather.weather[0].description.prefix(1).capitalized + self.currentWeather.weather[0].description.dropFirst()
        }
    }
    func weatherForLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        DataManager.shared.getCurrentWeather(lat: lat, long: long) { currentData in
            DispatchQueue.main.async {
                if var data = currentData {
                    self.currentWeather = data
                } else {
                    print("Lỗi Get Current Weather")
                }
            }
        }
        DataManager.shared.getForecastWeather(lat: lat, long: long) { forecastData in
            DispatchQueue.main.async {
                if var data = forecastData {
                    self.forecastWeather = data
                    
                    var softDayTime = [String: Any]()
                    
                    for items in data.list {
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let date = formatter.date(from: items.dt_txt)
                        
                        let timeFormatter = DateFormatter()
                        timeFormatter.dateFormat = "HH dd-MM-yyyy"
                        let formatterTime = timeFormatter.string(from: date!)
                        
                        let key = formatterTime
                        let value: [String: Any] = [
                            "main": items.main,
                            "weather": items.weather,
                            "wind": items.wind,
                            "visibility": items.visibility
                        ]
                        softDayTime[key] = value
                    }// Lọc ra các ngày trong
                    var dates: [String] = []
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    
                    for dateTimeString in softDayTime.keys {
                        let components = dateTimeString.components(separatedBy: " ")
                        if components.count == 2 {
                            let dateString = components[1]
                            if !dates.contains(dateString) {
                                dates.append(dateString)
                            }
                        }
                    }//Sắp xếp theo thời gian tăng dần
                    let sortedTimeArray = dates.sorted { (time1, time2) -> Bool in
                        if let date1 = dateFormatter.date(from: time1), let date2 = dateFormatter.date(from: time2) {
                            return date1 < date2
                        }
                        return false
                    }
                    // Tạo ra mảng gồm các ngày theo đúng thứ tự
                    self.numberOfSection = sortedTimeArray
                } else {
                    print("Lỗi Get Forecast Weather")
                }
            }
        }
    }
}
struct Weather: Codable {
    let main: String
    let description: String
    let icon: String
}
struct MainWeather: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Int
}
struct WindData: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}
struct ForecastWeather: Codable {
    let list: [List]
}
struct List: Codable {
    let main: MainWeather
    let weather: [Weather]
    let wind: WindData
    let visibility: Int
    let dt_txt: String
}
struct WeatherResponse: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: MainWeather
    let visibility: Int
    let wind: WindData
    let sys: Sys
    let name: String
}
struct Sys: Codable {
    let sunrise: Int
    let sunset: Int
}
struct Coord: Codable {
    let lat: Double
    let lon: Double
}
