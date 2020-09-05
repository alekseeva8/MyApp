//
//  URLBuilder.swift
//  WeatherApp
//
//  Created by Elena Alekseeva on 9/5/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import Foundation

class URLBuilder {
    
    private var components: URLComponents

    init() {
        self.components = URLComponents()
    }

    func set(scheme: String) -> URLBuilder {
        self.components.scheme = scheme
        return self
    }

    func set(host: String) -> URLBuilder {
        self.components.host = host
        return self
    }

    func set(port: Int) -> URLBuilder {
        self.components.port = port
        return self
    }

    func set(path: String) -> URLBuilder {
        var path = path
        if !path.hasPrefix("/") {
            path = "/" + path
        }
        self.components.path = path
        return self
    }

    func addQueryItem(name: String, value: String) -> URLBuilder  {
        if self.components.queryItems == nil {
            self.components.queryItems = []
        }
        self.components.queryItems?.append(URLQueryItem(name: name, value: value))
        return self
    }

    func build() -> URL? {
        return self.components.url
    }
    
//    private var baseURL: String
//    private var requestCategory: RequestCategory?
//    private var latitude: Double?
//    private var longitude: Double?
//    private var unitsFormat: String?
//    private var apiKey: String?
//    
//    init() {
//        self.baseURL = Constants.baseURL
//    }
//    
//    func set(requestCategory: RequestCategory)  -> URLBuilder {
//        self.requestCategory = requestCategory
//        return self
//    }
//    
//    func set(latitude: Double) -> URLBuilder {
//        self.latitude = latitude
//        return self
//    }
//    
//    func set(longitude: Double) -> URLBuilder {
//        self.longitude = longitude
//        return self
//    }
//    
//    func set(unitsFormat: String) -> URLBuilder {
//        self.unitsFormat = unitsFormat
//        return self
//    }
//    
//    func set(apiKey: String?) -> URLBuilder {
//        self.apiKey = apiKey
//        return self
//    }
//    
//    func build() -> URL? {
//        if let requestCategory = requestCategory {
//            baseURL += requestCategory.rawValue
//        }
//        
//        if let latitude = latitude {
//            baseURL += "lat=\(latitude)"
//        }
//        if let longitude = longitude {
//            baseURL += "&lon=\(longitude)"
//        }
//        if let unitsFormat = unitsFormat {
//            baseURL += "&units=\(unitsFormat)"
//        }
//        if let apiKey = apiKey {
//            baseURL += "&appid=\(apiKey)"
//        }
//        
//        return URL(string: baseURL)
//    }
}
