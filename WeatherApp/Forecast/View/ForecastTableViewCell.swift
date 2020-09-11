//
//  ForecastTableViewCell.swift
//  WeatherApp
//
//  Created by Elena Alekseeva on 9/6/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    static let reuseID = "ForecastTableViewCell"
    
    var forecastViewModel: ForecastViewModel! {
        didSet {
            let data = Converter.convert(forecastViewModel)
            
            textLabel?.text = "\(data.hour)"
            detailTextLabel?.text = "\(data.temperature)°"
            if let imageView = imageView {
                WeatherConditionHandler.setImage(for: imageView, with: data.weatherID)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        detailTextLabel?.font = UIFont.systemFont(ofSize: 30)
        detailTextLabel?.textColor = .systemBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
