//
//  Converter.swift
//  WeatherApp
//
//  Created by Elena Alekseeva on 9/11/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import Foundation

struct Converter {
    
    static func convert(_ currentViewModel: CurrentViewModel) -> (city: String, country: String, description: String, weatherID: Int, temperature: Int, humidity: Int, pressure: Int, windSpeed: Double, minTemp: Int, maxTemp: Int) {
        
        let city = currentViewModel.currentWeather.name
        let country = currentViewModel.currentWeather.sys.country
        
        var weatherDescription = ""
        var weatherID = 0
        let weatherArray = currentViewModel.currentWeather.weather
        weatherArray.forEach { (weather) in
            weatherDescription = weather.main
            weatherID = weather.id
        }
        
        let temperature = Int(currentViewModel.currentWeather.main.temp)
        let humidity = currentViewModel.currentWeather.main.humidity
        let pressure = currentViewModel.currentWeather.main.pressure
        let windSpeed = currentViewModel.currentWeather.wind.speed
        let minTemp = Int(currentViewModel.currentWeather.main.tempMin)
        let maxTemp = Int(currentViewModel.currentWeather.main.tempMax)
        
        return (city, country, weatherDescription, weatherID, temperature, humidity, pressure, windSpeed, minTemp, maxTemp)
        
    }
    
    static func convert(_ forecastViewModel: ForecastViewModel) -> (temperature: Int, hour: String, weatherID: Int) {
        
        let temperature = Int(forecastViewModel.list.main.temp)
        
        let time = forecastViewModel.list.time
        let timeSplitted = time.split(separator: " ")
        var hour = String(timeSplitted.last ?? "")
        let hourTrancated = hour.dropLast(3)
        hour = String(hourTrancated)
        
        let dayWeather = forecastViewModel.list.weather
        var weatherID = 0
        dayWeather.forEach { (one) in
            weatherID = one.id
        }
        
        return (temperature, hour, weatherID)
    }
}
