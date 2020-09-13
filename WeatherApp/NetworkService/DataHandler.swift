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
    
    static func getData(on requestCategory: RequestCategory, latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (CurrentWeather?, Error?) -> Void) {
        APIHandler.request(on: requestCategory, latitude: latitude, longitude: longitude) { (data, error) in
            guard let data = data else {return}
            
            switch error {
            case nil: 
                Storage.save(data: data, fileName: Constants.fileName)
                do {
                    let weatherData = try JSONDecoder().decode(CurrentWeather.self, from: data)
                    DispatchQueue.main.async {
                        completion(weatherData, nil)
                    }
                } catch let jsonError {
                    print("Failed to decode JSON ", jsonError)
                }
            default:
                completion(nil, error)
            }
        }
    }
    
    static func getData(on requestCategory: RequestCategory, city: String, completion: @escaping (CurrentWeather?, Error?) -> Void) {
        APIHandler.request(on: requestCategory, city: city) { (data, error) in
            guard let data = data else {return}
            
            switch error {
            case nil: 
                do {
                    let weatherData = try JSONDecoder().decode(CurrentWeather.self, from: data)   
                    DispatchQueue.main.async {
                        completion(weatherData, nil)
                    }
                } catch let jsonError {
                    print("Failed to decode JSON ", jsonError)
                }
            default:
                completion(nil, error)
            }
        }
    }
    
    static func getInfo(on requestCategory: RequestCategory, latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (ForecastWeather?, Error?) -> Void) {
        
        APIHandler.request(on: requestCategory, latitude: latitude, longitude: longitude) { (data, error) in
            guard let data = data else {return}
            
            switch error {
            case nil:
                Storage.save(data: data, fileName: Constants.forecastFileName)
                do {
                    let weatherData = try JSONDecoder().decode(ForecastWeather.self, from: data)
                    DispatchQueue.main.async {
                        completion(weatherData, nil)
                    }
                } catch let jsonError {
                    print("Failed to decode JSON ", jsonError)
                }
            default:
                completion(nil, error)
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
