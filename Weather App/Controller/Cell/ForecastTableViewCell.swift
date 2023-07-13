//
//  ForecastTableViewCell.swift
//  Weather App
//
//  Created by Luyện Hà Luyện on 11/07/2023.
//

import UIKit

class ForecastTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var dayMonthYearLB: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dayTime: [String: Any] = [:]
    var arrayTimeInDay = [String]()
    var timeInDay: [String: [String]] = [:]
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureTime(with data: [String]) {
        self.arrayTimeInDay = data
    }
    func configureData(with data: [String: Any]) {
        self.dayTime = data
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayTimeInDay.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCollectionViewCell", for: indexPath) as! ForecastCollectionViewCell
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH dd-MM-yyyy"
        let date = timeFormatter.date(from: arrayTimeInDay[indexPath.row])
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        let formatterTime = formatter.string(from: date!)
        
        cell.timeInDay.text = "\(formatterTime)h"
        
        if let dictionary = dayTime[arrayTimeInDay[indexPath.row]] as? [String: Any] {
            if let mainValue = dictionary["main"] as? String {
                cell.mainWeather.text = mainValue.prefix(1).capitalized + mainValue.dropFirst()
            }
            if let iconValue = dictionary["icon"] as? String {
                cell.imageWeather.image = UIImage(named: iconValue)
            }
            if let tempValue = dictionary["temp"] as? Double {
                cell.tempWeather.text = "\(tempValue)°C"
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 200)
    }
}
