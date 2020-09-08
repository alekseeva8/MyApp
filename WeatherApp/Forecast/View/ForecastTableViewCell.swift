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
    
    var forecastViewModel: ForecastViewModel! {
        didSet {
            let dayTemperature = Int(forecastViewModel.list.main.temp)
            
            let time = forecastViewModel.list.time
            let timeSplitted = time.split(separator: " ")
            var hour = String(timeSplitted.last ?? "")
            let hourTrancated = hour.dropLast(3)
            hour = String(hourTrancated)
            
            let dayWeather = forecastViewModel.list.weather
            var dayWeatherID = 0
            dayWeather.forEach { (one) in
                dayWeatherID = one.id
            }
            textLabel?.text = "\(hour)"
            detailTextLabel?.text = "\(dayTemperature)°"
            if let imageView = imageView {
                WeatherConditionHandler.setImage(for: imageView, with: dayWeatherID)
            }
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
