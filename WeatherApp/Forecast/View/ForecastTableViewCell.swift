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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
