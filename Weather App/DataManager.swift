//
//  DataManager.swift
//  Weather App
//
//  Created by Luyện Hà Luyện on 04/07/2023.
//

import Foundation
import CoreLocation


class DataManager {
    static let shared = DataManager()
    
    private let apiKey = "00abbeffcd912666e8dcdffb85081c7a"
    
    func getCurrentWeather(lat: Double, long: Double, completion: @escaping (WeatherResponse?) -> Void) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(apiKey)&units=metric&lang=vi") else {
            completion(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data , response, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            guard let weatherData = try?JSONDecoder().decode(WeatherResponse.self, from: data) else { return }
            completion(weatherData)
        }
        task.resume()
    }
    func getForecastWeather(lat: Double, long: Double, completion: @escaping (ForecastWeather?) -> Void) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(long)&appid=\(apiKey)&units=metric&lang=vi") else {
            completion(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data , response, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            guard let weatherForecast = try?JSONDecoder().decode(ForecastWeather.self, from: data) else { return }
            completion(weatherForecast)
        }
        task.resume()
    }
}
//            // Chuyển Data sang Dictionary
//            var forecastDict: [String: Any] = [:]
//
//            for item in self.forecastWeather.list {
//                let key = item.dt_txt
//                let value: [String: Any] = [
//                    "main": item.main,
//                    "weather": item.weather,
//                    "wind": item.wind,
//                    "visibility": item.visibility
//                    // Add more properties if needed
//                ]
//                forecastDict[key] = value
//            }
//            DispatchQueue.main.async {
//                for i in Array(0...(forecastDict.keys.count - 1)) {
//                    let formatter = DateFormatter()
//                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                    let date = formatter.date(from: self.forecastWeather.list[i].dt_txt)
//
//                    let timeFormatter = DateFormatter()
//                    timeFormatter.dateFormat = "dd-MM-yyyy"
//                    let formattedTime = timeFormatter.string(from: date!)
//
//                    self.dayInSection.append(formattedTime)
//                }
//                // Duyệt qua từng ngày, nếu chưa có thì thêm vào
//                for element in self.dayInSection {
//                    if !self.dayInSectionFiltered.contains(element) {
//                        self.dayInSectionFiltered.append(element)
//                    }
//                }
//                // Sắp xếp thời gian trong cùng một ngày lại với nhau
//
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//                for dateStr in forecastDict.keys {
//                    if let date = dateFormatter.date(from: dateStr) {
//                        let calendar = Calendar.current
//                        let components = calendar.dateComponents([.year, .month, .day], from: date)
//                        let dayStr = "\(components.year!)-\(String(format: "%02d", components.month!))-\(String(format: "%02d", components.day!))"
//
//                        if self.dayTime[dayStr] == nil {
//                            self.dayTime[dayStr] = [dateStr]
//                        } else {
//                            self.dayTime[dayStr]?.append(dateStr)
//                        }
//                    }
//                }
//                for i in self.dayTime.keys {
//                    let timeArray = self.dayTime[i]
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//                    let sortedArray = timeArray!.sorted { (time1, time2) -> Bool in
//                        if let date1 = dateFormatter.date(from: time1), let date2 = dateFormatter.date(from: time2) {
//                            return date1 < date2
//                        }
//                        return false
//                    }
//                    self.dayTime[i] = sortedArray
//                } // cập nhật lại dayTime
//                var outputDateString = [String]()
//                for i in self.dayInSectionFiltered {
//                    let inputDateFormatter = DateFormatter()
//                    inputDateFormatter.dateFormat = "dd-MM-yyyy"
//
//                    if let inputDate = inputDateFormatter.date(from: i) {
//                        let outputDateFormatter = DateFormatter()
//                        outputDateFormatter.dateFormat = "yyyy-MM-dd"
//
//                        outputDateString.append( outputDateFormatter.string(from: inputDate))
//                    }
//                }
//                self.tableView.reloadData()
//            }
//        }).resume()
//    }
