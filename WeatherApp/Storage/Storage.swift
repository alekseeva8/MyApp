//
//  Storage.swift
//  WeatherApp
//
//  Created by Elena Alekseeva on 9/8/20.
//  Copyright © 2020 Elena Alekseeva. All rights reserved.
//

import Foundation

struct Storage {
    
    static let urls = FileManager.default.urls(for: .libraryDirectory, in: .allDomainsMask)
    
    static func save(data: Data, fileName: String) {
        guard let url = urls.first?.appendingPathComponent(fileName) else { return }
        do {
            try data.write(to: url)
        } catch {
            print(error)
        }
    }
    
    static func read(fileName: String) -> Data? {
        guard let url = urls.first?.appendingPathComponent(fileName) else { return nil }
        
        var dataFromFile = Data()
        do {
            dataFromFile = try Data(contentsOf: url)
        } catch {
            print(error)
        }
        return dataFromFile
    }
}
