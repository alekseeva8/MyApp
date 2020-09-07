//
//  DaysHandler.swift
//  WeatherApp
//
//  Created by Elena Alekseeva on 9/7/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import Foundation

class DaysHandler {
    
    static func groupDays(_ lists: [List]) -> [[List]] {
        
        var days: [[List]] = []
        
        var indexesFor0 : [Int] = []
        for (index, value) in lists.enumerated() {
            let time = value.time
            let timeSplitted = time.split(separator: " ")
            let hour = String(timeSplitted.last ?? "")
            if hour == "00:00:00" {
                indexesFor0.append(index)
            }
        }
        
        if !indexesFor0.isEmpty {
            let rangeFirst = 0..<indexesFor0[0]
            days.append(Array.init(lists[rangeFirst]))
            for (index, value) in indexesFor0.enumerated() {
                if let lastValue = indexesFor0.last {
                    if value < lastValue {
                        let range = value ..< indexesFor0[index+1]
                        days.append(Array.init(lists[range]))
                    }
                }
            }
            if let lastValue = indexesFor0.last {
                let rangeLast = lastValue..<lists.count
                days.append(Array.init(lists[rangeLast]))
            }
        }
        return days
    }
}
