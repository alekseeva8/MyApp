//
//  APIHandler.swift
//  WeatherApp
//
//  Created by Elena Alekseeva on 9/4/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import Foundation
import CoreLocation

struct APIHandler {
    
    static func request (latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (Data?, Error?) -> Void) {
        let apiKey = "c5b6286e8fbc74adb2cd92af02f6ea33"
        let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(apiKey)" 
        guard let url = URL(string: urlString) else {return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
            }
            guard let data = data else { return }
            completion(data, nil)
            print(data)
        } .resume()
    }
}
