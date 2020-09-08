//
//  ForecastViewModel.swift
//  WeatherApp
//
//  Created by Elena Alekseeva on 9/7/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import Foundation
import CoreLocation

protocol ForecastViewModelDelegate: class  {
    
    func useData(_ data: ForecastWeather)
    func updateData(_ data: ForecastWeather)
}

class ForecastViewModel {
    
    var forecastViewModelDelegate: ForecastViewModelDelegate?
    let list: List
    
    init(list: List) {
        self.list = list
    }
    
    func getForecastFromCache() {
        DataHandler.getForecastFromCache { [weak self] (forecastWeather) in
            guard let self = self else {return}
            self.forecastViewModelDelegate?.useData(forecastWeather)
        }
    }
}

extension ForecastViewModel: LocationDelegate2 {
    
    func getForecast(on requestCategory: RequestCategory, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        DataHandler.getInfo(on: requestCategory, latitude: latitude, longitude: longitude) { [weak self] (forecastWeather, error) in
            
            switch error {
            case nil:
                guard let forecastWeather = forecastWeather else {return}
                self?.forecastViewModelDelegate?.updateData(forecastWeather)
                
            default:
                print(String(describing: error?.localizedDescription))
            }
        }
    }
}
