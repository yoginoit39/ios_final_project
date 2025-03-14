//
//  outfit.swift
//  weatherApp
//
//  Created by Yogesh lakhani on 3/4/25.
//

import Foundation

struct Outfit: Codable {
    let name: String
    let minTemp: Double
    let maxTemp: Double
    let weatherTypes: [String] // e.g., ["sunny", "rainy"]
    let items: [String] // Clothing items

    init(name: String, minTemp: Double, maxTemp: Double, weatherTypes: [String], items: [String]) {
        self.name = name
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.weatherTypes = weatherTypes
        self.items = items
    }
}
