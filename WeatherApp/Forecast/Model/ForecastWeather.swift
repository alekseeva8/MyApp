//
//  ForecastWeather.swift
//  WeatherApp
//
//  Created by Elena Alekseeva on 9/6/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import Foundation

struct ForecastWeather: Codable {
    let list: [List]
    let city: City
}

struct City: Codable {
    let name: String
}

struct List: Codable {
    let main: Main
    let weather: [Weather]
    let time: String
    
    enum CodingKeys: String, CodingKey {
        case main
        case weather
        case time = "dt_txt"
    }
}
