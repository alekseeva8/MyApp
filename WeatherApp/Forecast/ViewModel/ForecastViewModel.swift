//
//  ForecastViewModel.swift
//  WeatherApp
//
//  Created by Elena Alekseeva on 9/7/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import Foundation

struct ForecastViewModel {
    
    let list: List
    let textFortextLabel: String
    let textForDetailTextLabel: String
    var dayWeatherID: Int
    
    init(list: List) {
        self.list = list
        
        let dayTemperature = Int(list.main.temp)
        
        let time = list.time
        let timeSplitted = time.split(separator: " ")
        var hour = String(timeSplitted.last ?? "")
        let hourTrancated = hour.dropLast(3)
        hour = String(hourTrancated)
        
        let dayWeather = list.weather
         var dayWeatherID = 0
         dayWeather.forEach { (one) in
             dayWeatherID = one.id
         }
        self.dayWeatherID = dayWeatherID
        self.textFortextLabel = "\(hour)"
        self.textForDetailTextLabel = "\(dayTemperature)°"
        
    }
}
