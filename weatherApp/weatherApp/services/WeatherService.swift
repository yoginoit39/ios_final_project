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
    
    func getHourlyWeather(latitude: Double, longitude: Double) async throws -> WeatherData {
        let urlString = "https://api.weather.com/v3/wx/forecast/hourly?lat=\(latitude)&lon=\(longitude)&units=imperial&apiKey=YOUR_API_KEY"
        
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedData = try JSONDecoder().decode(WeatherData.self, from: data)
        
        return decodedData
    }
    
    func getCurrentWeather(latitude: Double, longitude: Double) async throws -> WeatherData {
        print("\n🌐 WeatherService - Starting API Calls")
        let pointURL = "\(baseURL)/points/\(latitude),\(longitude)"
        
        guard let url = URL(string: pointURL) else {
            throw NSError(domain: "Invalid URL", code: 0)
        }
        
        print("1️⃣ Fetching grid points from: \(pointURL)")
        let (pointData, _) = try await URLSession.shared.data(from: url)
        let pointResponse = try JSONDecoder().decode(WeatherPointResponse.self, from: pointData)
        
        guard let forecastURL = URL(string: pointResponse.properties.forecast),
              let alertsURL = URL(string: "\(baseURL)/alerts/active?point=\(latitude),\(longitude)") else {
            throw NSError(domain: "Invalid API Response", code: 0)
        }
        
        print("2️⃣ Fetching forecast from: \(forecastURL)")
        let (forecastData, _) = try await URLSession.shared.data(from: forecastURL)
        let forecastResponse = try JSONDecoder().decode(WeatherForecast.self, from: forecastData)
        
        print("3️⃣ Fetching alerts from: \(alertsURL)")
        let (alertData, _) = try await URLSession.shared.data(from: alertsURL)
        
        print("4️⃣ Parsing alerts response...")
        let alertsResponse = try JSONDecoder().decode(NWSAlertResponse.self, from: alertData)
        print("📝 Raw alert features count: \(alertsResponse.features.count)")
        
        // Map alerts to our model
        let alerts = alertsResponse.features.map { feature -> WeatherAlertData in
            let props = feature.properties
            return WeatherAlertData(
                event: props.event,
                description: props.description,
                startTime: props.effective ?? props.onset,
                endTime: props.expires ?? props.ends,
                temperature: nil
            )
        }
        
        print("5️⃣ Processed \(alerts.count) alerts")
        
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
            alerts: alerts
        )
    }
}

// API Response Models
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

// NWS Alert Response Models
struct NWSAlertResponse: Codable {
    let features: [NWSAlertFeature]
}

struct NWSAlertFeature: Codable {
    let properties: NWSAlertProperties
}

struct NWSAlertProperties: Codable {
    let event: String
    let description: String
    let effective: String?
    let onset: String?
    let expires: String?
    let ends: String?
}
