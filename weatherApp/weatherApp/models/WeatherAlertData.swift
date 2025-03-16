import Foundation

struct WeatherAlertData: Codable {
    let event: String
    let description: String
    let startTime: String?
    let endTime: String?
    let temperature: Double?
    
    // Coding keys to match API response
    private enum CodingKeys: String, CodingKey {
        case event
        case description
        case startTime = "effective"
        case endTime = "expires"
        case temperature
    }
    
    func formattedTime() -> String {
        guard let startTime = startTime, let endTime = endTime else {
            return "Time not specified"
        }
        
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM d, h:mm a"
        outputFormatter.timeZone = TimeZone.current
        
        if let startDate = isoFormatter.date(from: startTime),
           let endDate = isoFormatter.date(from: endTime) {
            let startStr = outputFormatter.string(from: startDate)
            let endStr = outputFormatter.string(from: endDate)
            return "\(startStr) - \(endStr)"
        }
        
        // If we can't parse the dates, try a simpler ISO format
        isoFormatter.formatOptions = [.withInternetDateTime]
        if let startDate = isoFormatter.date(from: startTime),
           let endDate = isoFormatter.date(from: endTime) {
            let startStr = outputFormatter.string(from: startDate)
            let endStr = outputFormatter.string(from: endDate)
            return "\(startStr) - \(endStr)"
        }
        
        return "Invalid Date Format"
    }
} 
