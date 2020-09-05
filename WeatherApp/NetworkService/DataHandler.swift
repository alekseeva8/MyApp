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
    
    static func getData(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (CurrentWeather) -> Void) {
        
        APIHandler.request(latitude: latitude, longitude: longitude) { (data, error) in
            guard let data = data else {return}
            guard error == nil else {return}
            
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
}
