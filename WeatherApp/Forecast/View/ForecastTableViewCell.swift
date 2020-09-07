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
            textLabel?.text = forecastViewModel.textFortextLabel
            detailTextLabel?.text = forecastViewModel.textForDetailTextLabel
            if let imageView = imageView {
                WeatherConditionHandler.setImage(for: imageView, with: forecastViewModel.dayWeatherID)
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
