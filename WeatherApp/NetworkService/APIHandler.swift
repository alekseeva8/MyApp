//
//  APIHandler.swift
//  WeatherApp
//
//  Created by Elena Alekseeva on 9/4/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import UIKit
import CoreLocation

struct APIHandler {
    
    static weak var viewController: UIViewController?
    static private var alertHasShown = false
    static private var alertHasShownSearchVC = false
    
    static func request (on requestCategory: RequestCategory, latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (Data?, Error?) -> Void) {
        
        let optURL = URLBuilder()
            .set(scheme: Constants.scheme)
            .set(host: Constants.host)
            .set(path: Constants.path + requestCategory.rawValue)
            .addQueryItem(name: "lat", value: "\(latitude)")
            .addQueryItem(name: "lon", value: "\(longitude)")
            .addQueryItem(name: "units", value: Constants.metriFormat)
            .addQueryItem(name: "appid", value: Constants.apiKey)
            .build()
        
        guard let url = optURL else {return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            switch error {
            case nil:
                completion(data, error)
            default:
                if alertHasShown == false {
                    guard let viewController = viewController else {return}
                    DispatchQueue.main.async {
                        Alert.noInternetConnection(viewController)
                        alertHasShown = true
                    }
                }
            }
        } .resume()
    }
    
    static func request (on requestCategory: RequestCategory, city: String, completion: @escaping (Data?, Error?) -> Void) {
        
        let optURL = URLBuilder()
            .set(scheme: Constants.scheme)
            .set(host: Constants.host)
            .set(path: Constants.path + requestCategory.rawValue)
            .addQueryItem(name: "q", value: "\(city)")
            .addQueryItem(name: "units", value: Constants.metriFormat)
            .addQueryItem(name: "appid", value: Constants.apiKey)
            .build()
        
        guard let url = optURL else {return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            switch error {
            case nil:
                completion(data, error)
            default:
                if alertHasShownSearchVC == false {
                    guard let viewController = viewController else {return}
                    DispatchQueue.main.async {
                        Alert.noInternetConnection(viewController)
                        alertHasShownSearchVC = true
                    }
                }
            }
        } .resume()
    }
}
