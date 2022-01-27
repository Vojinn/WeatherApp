//
//  WeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Dusan Vojinovic on 27.1.22..
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell{

    static let identifier = "WeatherCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherCollectionViewCell", bundle: nil)
    }
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var highTempLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    func configure(with model: DailyWeatherModel) {
        self.lowTempLabel.text = ("Min:\(model.temperatureStringMin)°C")
        self.highTempLabel.text = ("Max:\(model.temperatureStringMax)°C")
        
        self.dayLabel.text = getDayForDate(model.dayOfWeek)
        self.iconImageView.image = UIImage(systemName: model.conditionName)
    }
    
    func getDayForDate(_ stringDate: String?) -> String {
        guard let inputDate = stringDate else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: inputDate)
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
