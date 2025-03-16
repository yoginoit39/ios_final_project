//
//  OutfitStore.swift
//  weatherApp
//
//  Created by Yogesh lakhani on 3/4/25.
//

//import Foundation
//
//class OutfitStore {
//    static let shared = OutfitStore()
//    
//    private let outfitsKey = "savedOutfits" // Storage key for UserDefaults
//    
//    private var savedOutfits: [Outfit] = [] {
//        didSet { saveToUserDefaults() } // ✅ Automatically save when updated
//    }
//    
//    private init() {
//        loadFromUserDefaults() // ✅ Load outfits when the app starts
//    }
//
//    // ✅ Save outfit
//    func saveOutfit(_ outfit: Outfit) {
//        savedOutfits.append(outfit)
//        saveToUserDefaults()
//        print("✅ Outfit saved! Total outfits count: \(savedOutfits.count)")
//    }
//
//    // ✅ Get all outfits
//    func getAllOutfits() -> [Outfit] {
//        print("📂 Fetching all outfits. Total: \(savedOutfits.count)")
//        return savedOutfits
//    }
//
//    // ✅ Delete outfit
//    func deleteOutfit(_ outfit: Outfit) {
//        savedOutfits.removeAll { $0.name == outfit.name }
//        saveToUserDefaults()
//    }
//
//    // ✅ Get suggested outfit based on weather condition
//    func getSuggestedOutfit(for weather: CurrentWeather) -> Outfit? {
//        print("🔍 Searching outfit for Weather Condition: \(weather.condition), Temperature: \(weather.temperature)°F")
//
//        let matches = savedOutfits.filter { outfit in
//            // ✅ Now checking if any saved weather type is contained in the API's condition
//            let isWeatherMatching = outfit.weatherTypes.contains { savedType in
//                let savedLower = savedType.lowercased()
//                let weatherLower = weather.condition.lowercased()
//                return weatherLower.contains(savedLower) || savedLower.contains(weatherLower)
//            }
//
//            let isTempMatching = weather.temperature >= outfit.minTemp && weather.temperature <= outfit.maxTemp
//
//            print("👕 Checking Outfit: \(outfit.name)")
//            print("   ✅ Weather Match: \(isWeatherMatching), Outfit Types: \(outfit.weatherTypes)")
//            print("   ✅ Temp Match: \(isTempMatching), Range: \(outfit.minTemp)°F - \(outfit.maxTemp)°F")
//
//            return isWeatherMatching && isTempMatching
//        }
//
//        print("🔍 Matching outfits found: \(matches.count)")
//
//        return matches.first
//    }
//
//
//
//    
//    private func saveToUserDefaults() {
//        do {
//            let data = try JSONEncoder().encode(savedOutfits)
//            UserDefaults.standard.set(data, forKey: outfitsKey)
//            print("✅ Successfully saved outfits to UserDefaults")
//        } catch {
//            print("❌ Failed to save outfits: \(error)")
//        }
//    }
//
//    private func loadFromUserDefaults() {
//        if let data = UserDefaults.standard.data(forKey: outfitsKey) {
//            do {
//                savedOutfits = try JSONDecoder().decode([Outfit].self, from: data)
//                print("✅ Successfully loaded \(savedOutfits.count) outfits from UserDefaults")
//            } catch {
//                print("❌ Failed to load outfits: \(error)")
//            }
//        } else {
//            print("⚠️ No saved outfits found in UserDefaults")
//        }
//    }
//
//    

    // ✅ Save outfits to UserDefaults
//    private func saveToUserDefaults() {
//        do {
//            let data = try JSONEncoder().encode(savedOutfits)
//            UserDefaults.standard.set(data, forKey: outfitsKey)
//        } catch {
//            print("❌ Failed to save outfits: \(error)")
//        }
//    }
//
//    // ✅ Load outfits from UserDefaults
//    private func loadFromUserDefaults() {
//        if let data = UserDefaults.standard.data(forKey: outfitsKey) {
//            do {
//                savedOutfits = try JSONDecoder().decode([Outfit].self, from: data)
//            } catch {
//                print("❌ Failed to load outfits: \(error)")
//            }
//        }
//    }
//}

//
//import Foundation
//
//class OutfitStore {
//    static let shared = OutfitStore()
//    
//    private let outfitsKey = "savedOutfits"
//    private var savedOutfits: [Outfit] = [] {
//        didSet { saveToUserDefaults() }
//    }
//    
//    private init() {
//        loadFromUserDefaults()
//    }
//
//    func saveOutfit(_ outfit: Outfit) {
//        savedOutfits.append(outfit)
//        saveToUserDefaults()
//        print("✅ Outfit saved! Total outfits count: \(savedOutfits.count)")
//
//        // ✅ Send notification about the saved outfit
//        let outfitMessage = "You saved a new outfit: \(outfit.name) - \(outfit.items.joined(separator: ", "))"
//        NotificationManager.shared.scheduleWeatherAlert(title: "👕 New Outfit Saved", body: outfitMessage, timeInterval: 5)
//    }
//
//    func getAllOutfits() -> [Outfit] {
//        return savedOutfits
//    }
//
//    func deleteOutfit(_ outfit: Outfit) {
//        savedOutfits.removeAll { $0.name == outfit.name }
//        saveToUserDefaults()
//    }
//
//    func getSuggestedOutfit(for weather: CurrentWeather) -> Outfit? {
//        let matches = savedOutfits.filter { outfit in
//            let isWeatherMatching = outfit.weatherTypes.contains { savedType in
//                let savedLower = savedType.lowercased()
//                let weatherLower = weather.condition.lowercased()
//                return weatherLower.contains(savedLower) || savedLower.contains(weatherLower)
//            }
//
//            let isTempMatching = weather.temperature >= outfit.minTemp && weather.temperature <= outfit.maxTemp
//            return isWeatherMatching && isTempMatching
//        }
//        return matches.first
//    }
//
//    private func saveToUserDefaults() {
//        do {
//            let data = try JSONEncoder().encode(savedOutfits)
//            UserDefaults.standard.set(data, forKey: outfitsKey)
//        } catch {
//            print("❌ Failed to save outfits: \(error)")
//        }
//    }
//
//    private func loadFromUserDefaults() {
//        if let data = UserDefaults.standard.data(forKey: outfitsKey) {
//            do {
//                savedOutfits = try JSONDecoder().decode([Outfit].self, from: data)
//            } catch {
//                print("❌ Failed to load outfits: \(error)")
//            }
//        }
//    }
//}

import Foundation

class OutfitStore {
    static let shared = OutfitStore()
    
    private let outfitsKey = "savedOutfits" // Storage key for UserDefaults
    private var savedOutfits: [Outfit] = [] {
        didSet { saveToUserDefaults() }
    }
    
    private init() {
        loadFromUserDefaults()
    }

    // ✅ Save outfit and send push notification
    func saveOutfit(_ outfit: Outfit) {
        savedOutfits.append(outfit)
        saveToUserDefaults()
        print("✅ Outfit saved! Total outfits count: \(savedOutfits.count)")

        // ✅ Send push notification
        let outfitMessage = "You saved a new outfit: \(outfit.name) - \(outfit.items.joined(separator: ", "))"
        NotificationManager.shared.scheduleNotification(title: "👕 Outfit Added", body: outfitMessage, timeInterval: 2)
    }

    // ✅ Delete outfit and send push notification
    func deleteOutfit(_ outfit: Outfit) {
        savedOutfits.removeAll { $0.name == outfit.name }
        saveToUserDefaults()
        print("❌ Outfit deleted! Total outfits count: \(savedOutfits.count)")

        // ✅ Send push notification
        let outfitMessage = "The outfit '\(outfit.name)' was deleted."
        NotificationManager.shared.scheduleNotification(title: "🗑 Outfit Removed", body: outfitMessage, timeInterval: 2)
    }

    // ✅ Get all outfits
    func getAllOutfits() -> [Outfit] {
        return savedOutfits
    }

    // ✅ Save outfits to UserDefaults
    private func saveToUserDefaults() {
        do {
            let data = try JSONEncoder().encode(savedOutfits)
            UserDefaults.standard.set(data, forKey: outfitsKey)
        } catch {
            print("❌ Failed to save outfits: \(error)")
        }
    }

    // ✅ Load outfits from UserDefaults
    private func loadFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: outfitsKey) {
            do {
                savedOutfits = try JSONDecoder().decode([Outfit].self, from: data)
            } catch {
                print("❌ Failed to load outfits: \(error)")
            }
        }
    }
    
    // ✅ Get suggested outfit based on weather condition
    func getSuggestedOutfit(for weather: CurrentWeather) -> Outfit? {
        print("🔍 Searching outfit for Weather Condition: \(weather.condition), Temperature: \(weather.temperature)°F")
        print("📱 Total saved outfits: \(savedOutfits.count)")

        // Map similar weather conditions
        let weatherMappings: [String: [String]] = [
            "clear": ["clear", "sunny", "mostly sunny"],
            "cloudy": ["cloudy", "mostly cloudy", "partly cloudy", "overcast"],
            "rain": ["rain", "rain showers", "light rain", "heavy rain", "drizzle"],
            "snow": ["snow", "light snow", "heavy snow", "sleet"],
            "storm": ["thunderstorms", "thunderstorm"],
            "fog": ["fog", "haze", "mist"],
            "wind": ["windy", "breezy", "gusty winds"]
        ]

        let currentWeatherLower = weather.condition.lowercased()
        
        let matches = savedOutfits.filter { outfit in
            // Temperature check
            let isTempMatching = weather.temperature >= outfit.minTemp && weather.temperature <= outfit.maxTemp
            
            // Weather condition check
            let isWeatherMatching = outfit.weatherTypes.contains { savedType in
                let savedLower = savedType.lowercased()
                
                // Direct match
                if currentWeatherLower.contains(savedLower) || savedLower.contains(currentWeatherLower) {
                    return true
                }
                
                // Check weather mappings
                for (_, conditions) in weatherMappings {
                    if conditions.contains(savedLower) && conditions.contains(currentWeatherLower) {
                        return true
                    }
                }
                
                return false
            }
            
            print("👕 Checking Outfit: \(outfit.name)")
            print("   Temperature Match: \(isTempMatching) (Current: \(weather.temperature)°F, Range: \(outfit.minTemp)°F - \(outfit.maxTemp)°F)")
            print("   Weather Match: \(isWeatherMatching) (Current: \(weather.condition), Outfit Types: \(outfit.weatherTypes))")
            
            return isWeatherMatching && isTempMatching
        }

        if let match = matches.first {
            print("✅ Found matching outfit: \(match.name)")
        } else {
            print("❌ No matching outfit found")
        }

        return matches.first
    }
}
