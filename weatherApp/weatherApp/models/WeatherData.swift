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

// Main Weather Data Model
struct WeatherData: Codable {
    let current: CurrentWeather
    let forecast: [DailyForecast]
    let alerts: [WeatherAlertData]?
}

// Current Weather Model
struct CurrentWeather: Codable {
    let temperature: Double
    let condition: String
    let icon: String
}

// Daily Forecast Model
struct DailyForecast: Codable {
    let date: Date
    let high: Double
    let low: Double
    let condition: String
    
    // Regular initializer
    init(date: Date, high: Double, low: Double, condition: String) {
        self.date = date
        self.high = high
        self.low = low
        self.condition = condition
    }
    
    // Custom decoder for API date format
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
        self.date = formatter.date(from: dateString) ?? Date()
        
        self.high = try container.decode(Double.self, forKey: .high)
        self.low = self.high - 10 // Assume a default 10-degree drop if low isn't available
        self.condition = try container.decode(String.self, forKey: .condition)
    }
}

// Weather Alert Model (Now inside WeatherData.swift)
//struct WeatherAlertData: Codable {
//    let event: String
//    let description: String
//    let startTime: String?   // Start time of the alert
//    let endTime: String?     // End time of the alert
//    let temperature: Double? // Optional: Associated temperature
//
//    private enum CodingKeys: String, CodingKey {
//        case event, description, startTime, endTime, temperature
//    }
//    
//    // Convert API date format (ISO 8601) to user-friendly format
//    // ✅ Convert API ISO 8601 date to user-friendly format
//       func formattedTime() -> String {
//           guard let start = startTime, let end = endTime else {
//               return "No Time Data Available"
//           }
//
//           let isoFormatter = ISO8601DateFormatter()
//           isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//
//           let outputFormatter = DateFormatter()
//           outputFormatter.dateFormat = "MMM d, h:mm a"  // Example: Mar 14, 2:00 PM
//           outputFormatter.timeZone = TimeZone.current
//
//           if let startDate = isoFormatter.date(from: start),
//              let endDate = isoFormatter.date(from: end) {
//               let startStr = outputFormatter.string(from: startDate)
//               let endStr = outputFormatter.string(from: endDate)
//               return "\(startStr) - \(endStr)"
//           }
//
//           print("⚠️ Date Parsing Failed for: \(start) to \(end)")
//           return "Invalid Date Format"
//       }
//}


