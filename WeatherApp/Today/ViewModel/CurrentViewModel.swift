//
//  CurrentViewModel.swift
//  WeatherApp
//
//  Created by Elena Alekseeva on 9/7/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import Foundation

struct CurrentViewModel {
    
    var currentWeather: CurrentWeather
    var weatherID: Int
    let locationLabelText: String
    let weatherLabelText: String
    let humidityLabelText: String
    let pressureLabelText: String
    let windLabelText: String    
    let minTempLabelText: String
    let maxTempLabelText: String
    
    init(currentWeather: CurrentWeather) {
        self.currentWeather = currentWeather
        
        let city = currentWeather.name
        let country = currentWeather.sys.country
        self.locationLabelText = "\(city), \(country)"
        
        var weatherDescription = ""
        var weatherID = 0
        let weatherArray = currentWeather.weather
        weatherArray.forEach { (weather) in
            weatherDescription = weather.main
            weatherID = weather.id
        }
        self.weatherID = weatherID
        
        let temperature = Int(currentWeather.main.temp)
        self.weatherLabelText = "\(temperature)°C | \(weatherDescription)"
        
        let humidity = currentWeather.main.humidity
        self.humidityLabelText = "\(humidity)%"
        
        let pressure = currentWeather.main.pressure
        self.pressureLabelText = "\(pressure)hPa"
        
        let windSpeed = currentWeather.wind.speed
        self.windLabelText = "\(windSpeed)\nm/sec"
        
        let minTemperature = Int(currentWeather.main.tempMin)
        self.minTempLabelText = "\(minTemperature)°C"
        
        let maxTemperature = Int(currentWeather.main.tempMax)
        self.maxTempLabelText = "\(maxTemperature)°C"
    }
}
