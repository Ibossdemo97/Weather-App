//
//  ForecastFiveDayViewController.swift
//  Weather App
//
//  Created by Luyện Hà Luyện on 11/07/2023.
//

import UIKit
import CoreLocation

class ForecastFiveDayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    var forecastData = ForecastWeather(list: [List(main: MainWeather(temp: 0.0,
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
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var dates: [String] = []
    var forecastWeatherData = [String: Any]()
    var timeInDayArranged = [String: [String]]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
    }
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        setupLocation()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
            forecastWeatherForLocation()
        }
    }
    func forecastWeatherForLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        DataManager.shared.getForecastWeather(lat: lat, long: long) { getData in
            DispatchQueue.main.async {
                guard let data = getData else {
                    return
                }
                
                for items in data.list {
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let date = formatter.date(from: items.dt_txt)
                    
                    let timeFormatter = DateFormatter()
                    timeFormatter.dateFormat = "HH dd-MM-yyyy"
                    let formatterTime = timeFormatter.string(from: date!)
                    
                    let key = formatterTime
                    let value: [String: Any] = [
                        "temp": items.main.temp,
                        "main": items.weather[0].description,
                        "icon": items.weather[0].icon
                    ]
                    self.forecastWeatherData[key] = value
                }
                //Lọc ra số ngày
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                
                for dateTimeString in self.forecastWeatherData.keys {
                    let components = dateTimeString.components(separatedBy: " ")
                    if components.count == 2 {
                        let dateString = components[1]
                        if !self.dates.contains(dateString) {
                            self.dates.append(dateString)
                        }
                    }
                }
                //Sắp xếp ngày theo thứ tự tăng dần
                let sortedTimeArray = self.dates.sorted { (time1, time2) -> Bool in
                    if let date1 = dateFormatter.date(from: time1), let date2 = dateFormatter.date(from: time2) {
                        return date1 < date2
                    }
                    return false
                }
                for i in self.dates {
                    let filteredElements = self.forecastWeatherData.keys.filter { element in
                        let components = element.components(separatedBy: " ")
                        guard components.count == 2 else {
                            return false
                        }
                        let dateString = components[1]
                        return dateString == i
                    }
                    let sortedArray = filteredElements.sorted { (element1, element2) -> Bool in
                        let time1 = element1.components(separatedBy: " ")[0]
                        let time2 = element2.components(separatedBy: " ")[0]
                        
                        return time1 < time2
                    }
                    
                    self.timeInDayArranged[i] = sortedArray
                }
                self.dates = sortedTimeArray // Cập nhật dates
                self.tableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dates.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableViewCell", for: indexPath) as! ForecastTableViewCell
        cell.dayMonthYearLB.text = "Dự báo ngày \(dates[indexPath.row])"
        cell.collectionView.tag = indexPath.row
        let keys = dates[indexPath.row]
        cell.arrayTimeInDay = timeInDayArranged[keys]!
        cell.dayTime = self.forecastWeatherData
        return cell
    }
}
