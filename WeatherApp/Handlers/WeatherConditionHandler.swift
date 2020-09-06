//
//  WeatherConditionHandler.swift
//  WeatherApp
//
//  Created by Elena Alekseeva on 9/5/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import UIKit

struct WeatherConditionHandler {
    
    static func setImage(for imageView: UIImageView, with weatherID: Int) {
        
        switch weatherID {
        case 200...232:
            imageView.image = UIImage(named: "thunderstorm")
        case 300...321:
            imageView.image = UIImage(named: "drizzle")
        case 500...531:
            imageView.image = UIImage(named: "rain")
        case 600...622:
            imageView.image = UIImage(named: "snow")
        case 701...781:
            imageView.image = UIImage(named: "fog")
        case 800:
            imageView.image = UIImage(named: "sun")
        case 801...804:
            imageView.image = UIImage(named: "clouds")
        default: 
            imageView.image = UIImage()
        }
    }
}
