//
//  DataHandler.swift
//  WeatherApp
//
//  Created by Elena Alekseeva on 9/4/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import Foundation
import CoreLocation

struct DataHandler {
    
    static func getData(on requestCategory: RequestCategory, latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (CurrentWeather) -> Void) {
        
        APIHandler.request(on: requestCategory, latitude: latitude, longitude: longitude) { (data, error) in
            guard let data = data else {return}
            guard error == nil else {return}
            
            Storage.save(data: data, fileName: Constants.fileName)
            
            do {
                let weatherData = try JSONDecoder().decode(CurrentWeather.self, from: data)   
                DispatchQueue.main.async {
                    completion(weatherData)
                }
            } catch let jsonError {
                print("Failed to decode JSON ", jsonError)
            }
        }
    }
    
    static func getInfo(on requestCategory: RequestCategory, latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (ForecastWeather) -> Void) {
        
        APIHandler.request(on: requestCategory, latitude: latitude, longitude: longitude) { (data, error) in
            guard let data = data else {return}
            guard error == nil else {return}
            
            Storage.save(data: data, fileName: Constants.forecastFileName)
            
            do {
                let weatherData = try JSONDecoder().decode(ForecastWeather.self, from: data)
                DispatchQueue.main.async {
                    completion(weatherData)
                }
            } catch let jsonError {
                print("Failed to decode JSON ", jsonError)
            }
        }
    }
    
    static func getWeatherFromCache(completion: @escaping (CurrentWeather) -> Void) {
        guard let dataFromFile = Storage.read(fileName: Constants.fileName) else { return }
        do {
            let weatherData = try JSONDecoder().decode(CurrentWeather.self, from: dataFromFile)   
            DispatchQueue.main.async {
                completion(weatherData)
            }
        } catch let jsonError {
            print("Failed to decode JSON ", jsonError)
        }
    }
    
    static func getForecastFromCache(completion: @escaping (ForecastWeather) -> Void) {
        guard let dataFromFile = Storage.read(fileName: Constants.forecastFileName) else { return }
        do {
            let weatherData = try JSONDecoder().decode(ForecastWeather.self, from: dataFromFile)   
            DispatchQueue.main.async {
                completion(weatherData)
            }
        } catch let jsonError {
            print("Failed to decode JSON ", jsonError)
        }
    }
}
