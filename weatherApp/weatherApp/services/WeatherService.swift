////
////  WeatherService.swift
////  weatherApp
////
////  Created by Yogesh lakhani on 3/4/25.
//import Foundation  // ✅ Add this to fix missing types
//
//class WeatherService {
//    static let shared = WeatherService()
//    private let baseURL = "https://api.weather.gov"
//
//    func getCurrentWeather(latitude: Double, longitude: Double) async throws -> WeatherData {
//        let pointURL = "\(baseURL)/points/\(latitude),\(longitude)"
//
//        // Get grid points
//        guard let url = URL(string: pointURL) else {
//            throw NSError(domain: "Invalid URL", code: 0)
//        }
//
//        let (pointData, _) = try await URLSession.shared.data(from: url)
//        let pointResponse = try JSONDecoder().decode(WeatherPointResponse.self, from: pointData)
//
//        guard let forecastURL = URL(string: pointResponse.properties.forecast),
//              let alertsURL = URL(string: "\(baseURL)/alerts/active?point=\(latitude),\(longitude)") else {
//            throw NSError(domain: "Invalid API Response", code: 0)
//        }
//
//        // Fetch forecast
//        let (forecastData, _) = try await URLSession.shared.data(from: forecastURL)
//        let forecastResponse = try JSONDecoder().decode(WeatherForecast.self, from: forecastData)
//
//        // Fetch alerts
//        let (alertData, _) = try await URLSession.shared.data(from: alertsURL)
//        let alerts = try JSONDecoder().decode(WeatherAlertResponse.self, from: alertData)
//
//        let dailyForecasts = forecastResponse.properties.periods.map { period in
//            DailyForecast(
//                date: Date(),
//                high: period.temperature,
//                low: period.temperature - 10,
//                condition: period.shortForecast
//            )
//        }
//
//        return WeatherData(
//            current: CurrentWeather(
//                temperature: forecastResponse.properties.periods.first?.temperature ?? 0,
//                condition: forecastResponse.properties.periods.first?.shortForecast ?? "N/A",
//                icon: ""  // API does not provide an icon field directly
//            ),
//            forecast: dailyForecasts,
//            alerts: alerts.alerts
//        )
//    }
//}
//
//// ✅ Updated Data Models
//struct WeatherPointResponse: Codable {
//    let properties: WeatherPointProperties
//}
//
//struct WeatherPointProperties: Codable {
//    let forecast: String
//}
//
//struct WeatherForecast: Codable {
//    struct ForecastPeriod: Codable {
//        let startTime: String  // API provides this as a String (ISO 8601 format)
//        let temperature: Double
//        let shortForecast: String
//    }
//
//    let properties: Properties
//
//    struct Properties: Codable {
//        let periods: [ForecastPeriod]
//    }
//}
//
//struct WeatherAlertResponse: Codable {
//    let alerts: [WeatherAlert]
//}


//import Foundation  // ✅ Ensure Foundation is imported
//class WeatherService {
//    static let shared = WeatherService()
//    private let baseURL = "https://api.weather.gov"
//
//    func getCurrentWeather(latitude: Double, longitude: Double) async throws -> WeatherData {
//        let pointURL = "\(baseURL)/points/\(latitude),\(longitude)"
//
//        // ✅ Get grid points
//        guard let url = URL(string: pointURL) else {
//            throw NSError(domain: "Invalid URL", code: 0)
//        }
//
//        let (pointData, _) = try await URLSession.shared.data(from: url)
//        let pointResponse = try JSONDecoder().decode(WeatherPointResponse.self, from: pointData)
//
//        guard let forecastURL = URL(string: pointResponse.properties.forecast),
//              let alertsURL = URL(string: "\(baseURL)/alerts/active?point=\(latitude),\(longitude)") else {
//            throw NSError(domain: "Invalid API Response", code: 0)
//        }
//
//        // ✅ Fetch forecast
//        let (forecastData, _) = try await URLSession.shared.data(from: forecastURL)
//        let forecastResponse = try JSONDecoder().decode(WeatherForecast.self, from: forecastData)
//
//        // ✅ Fetch alerts (Handle missing `alerts` gracefully)
//        let (alertData, _) = try await URLSession.shared.data(from: alertsURL)
//        let alertsResponse = try? JSONDecoder().decode(WeatherAlertResponse.self, from: alertData)
//
//        let dailyForecasts = forecastResponse.properties.periods.map { period in
//            DailyForecast(
//                date: Date(),
//                high: period.temperature,
//                low: period.temperature - 10,
//                condition: period.shortForecast
//            )
//        }
//
//        return WeatherData(
//            current: CurrentWeather(
//                temperature: forecastResponse.properties.periods.first?.temperature ?? 0,
//                condition: forecastResponse.properties.periods.first?.shortForecast ?? "N/A",
//                icon: ""  // API does not provide an icon field directly
//            ),
//            forecast: dailyForecasts,
//            alerts: alertsResponse?.alerts ?? [] // ✅ Handle missing alerts
//        )
//    }
//}
//
//// ✅ Updated Data Models
//struct WeatherPointResponse: Codable {
//    let properties: WeatherPointProperties
//}
//
//struct WeatherPointProperties: Codable {
//    let forecast: String
//}
//
//struct WeatherForecast: Codable {
//    struct ForecastPeriod: Codable {
//        let startTime: String  // ✅ API provides this as a String (ISO 8601 format)
//        let temperature: Double
//        let shortForecast: String
//    }
//
//    let properties: Properties
//
//    struct Properties: Codable {
//        let periods: [ForecastPeriod]
//    }
//}
//
//struct WeatherAlertResponse: Codable {
//    let alerts: [WeatherAlert]
//}

import Foundation

class WeatherService {
    static let shared = WeatherService()
    private let baseURL = "https://api.weather.gov"

    func getCurrentWeather(latitude: Double, longitude: Double) async throws -> WeatherData {
        let pointURL = "\(baseURL)/points/\(latitude),\(longitude)"

        guard let url = URL(string: pointURL) else {
            throw NSError(domain: "Invalid URL", code: 0)
        }

        let (pointData, _) = try await URLSession.shared.data(from: url)
        let pointResponse = try JSONDecoder().decode(WeatherPointResponse.self, from: pointData)

        guard let forecastURL = URL(string: pointResponse.properties.forecast),
              let alertsURL = URL(string: "\(baseURL)/alerts/active?point=\(latitude),\(longitude)") else {
            throw NSError(domain: "Invalid API Response", code: 0)
        }

        let (forecastData, _) = try await URLSession.shared.data(from: forecastURL)
        let forecastResponse = try JSONDecoder().decode(WeatherForecast.self, from: forecastData)

        let (alertData, _) = try await URLSession.shared.data(from: alertsURL)
        let alertsResponse = try? JSONDecoder().decode(WeatherAlertResponse.self, from: alertData)

        let dailyForecasts = forecastResponse.properties.periods.map { period in
            DailyForecast(
                date: Date(),
                high: period.temperature,
                low: period.temperature - 10,
                condition: period.shortForecast
            )
        }

        return WeatherData(
            current: CurrentWeather(
                temperature: forecastResponse.properties.periods.first?.temperature ?? 0,
                condition: forecastResponse.properties.periods.first?.shortForecast ?? "N/A",
                icon: ""
            ),
            forecast: dailyForecasts,
            alerts: alertsResponse?.features.map { $0.properties } ?? [] // ✅ Corrected API mapping
        )
    }
}

// ✅ API Models
struct WeatherPointResponse: Codable {
    let properties: WeatherPointProperties
}

struct WeatherPointProperties: Codable {
    let forecast: String
}

struct WeatherForecast: Codable {
    struct ForecastPeriod: Codable {
        let startTime: String
        let temperature: Double
        let shortForecast: String
    }

    let properties: Properties
    struct Properties: Codable {
        let periods: [ForecastPeriod]
    }
}

// ✅ Corrected Weather Alerts
struct WeatherAlertResponse: Codable {
    let features: [WeatherAlertFeature]
}

struct WeatherAlertFeature: Codable {
    let properties: WeatherAlertData
}

// ✅ Avoid name conflict: Rename to WeatherAlertData
struct WeatherAlertData: Codable {
    let event: String
    let description: String
}
