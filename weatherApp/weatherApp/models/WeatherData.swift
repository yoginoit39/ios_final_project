////
////  weatherData.swift
////  weatherApp
////
////  Created by Yogesh lakhani on 3/4/25.
////
//
//import Foundation
//
//struct WeatherData: Codable {
//    let current: CurrentWeather
//    let forecast: [DailyForecast]
//    let alerts: [WeatherAlert]
//}
//
//struct CurrentWeather: Codable {
//    let temperature: Double
//    let condition: String
//    let icon: String
//}
//
//struct DailyForecast: Codable {
//    let date: Date
//    let high: Double
//    let low: Double
//    let condition: String
//
//    // Regular initializer for direct creation
//    init(date: Date, high: Double, low: Double, condition: String) {
//        self.date = date
//        self.high = high
//        self.low = low
//        self.condition = condition
//    }
//
//    // Custom date decoder
//    private enum CodingKeys: String, CodingKey {
//        case date = "startTime"
//        case high = "temperature"
//        case low
//        case condition = "shortForecast"
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        // Convert ISO 8601 date string to Date object
//        let dateString = try container.decode(String.self, forKey: .date)
//        let formatter = ISO8601DateFormatter()
//        formatter.formatOptions = [.withInternetDateTime]
//        self.date = formatter.date(from: dateString) ?? Date()
//
//        self.high = try container.decode(Double.self, forKey: .high)
//        self.low = self.high - 10 // Assume a default 10-degree drop if low isn't available
//        self.condition = try container.decode(String.self, forKey: .condition)
//    }
//}
//
//struct WeatherAlert: Codable {
//    let title: String
//    let description: String
//    let severity: String
//}


import Foundation

struct WeatherData: Codable {
    let current: CurrentWeather
    let forecast: [DailyForecast]
    let alerts: [WeatherAlertData]?
}

struct CurrentWeather: Codable {
    let temperature: Double
    let condition: String
    let icon: String
}

struct DailyForecast: Codable {
    let date: Date
    let high: Double
    let low: Double
    let condition: String

    // Regular initializer for direct creation
    init(date: Date, high: Double, low: Double, condition: String) {
        self.date = date
        self.high = high
        self.low = low
        self.condition = condition
    }

    // Custom date decoder
    private enum CodingKeys: String, CodingKey {
        case date = "startTime"
        case high = "temperature"
        case low
        case condition = "shortForecast"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Convert ISO 8601 date string to Date object
        let dateString = try container.decode(String.self, forKey: .date)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        self.date = formatter.date(from: dateString) ?? Date()  // ✅ FIXED

        self.high = try container.decode(Double.self, forKey: .high)
        self.low = try container.decodeIfPresent(Double.self, forKey: .low) ?? (self.high - 10) // ✅ FIXED
        self.condition = try container.decode(String.self, forKey: .condition)
    }
}

struct WeatherAlert: Codable {
    let title: String
    let description: String
    let severity: String
}
