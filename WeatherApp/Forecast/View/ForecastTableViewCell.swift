//
//  ForecastTableViewCell.swift
//  WeatherApp
//
//  Created by Elena Alekseeva on 9/6/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    static let reuseID = "ForecastTableViewCell"
    
    var list : List? {
        didSet {
            guard let list = list else {
                return
            }
            let dayTemperature = Int(list.main.temp)
            
            let time = list.time         //"2020-09-06 21:00:00"
            let timeSplitted = time.split(separator: " ")
            let hour = String(timeSplitted.last ?? "")
            
            let dayWeather = list.weather
            var dayWeatherID = 0
            dayWeather.forEach { (one) in
                dayWeatherID = one.id
            }
            if let imageView = imageView {
                WeatherConditionHandler.setImage(for: imageView, with: dayWeatherID)
            }
            textLabel?.text = "\(hour)"
            detailTextLabel?.text = "\(dayTemperature)°"
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        detailTextLabel?.font = UIFont.systemFont(ofSize: 30)
        detailTextLabel?.textColor = .systemBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
