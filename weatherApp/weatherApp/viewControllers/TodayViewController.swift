//
//  TodayViewController.swift
//  weatherApp
//
//  Created by Yogesh lakhani on 3/4/25.

import UIKit

class TodayViewController: UIViewController {
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var outfitTitleLabel: UILabel!
    @IBOutlet weak var outfitLabel1: UILabel!
    @IBOutlet weak var outfitLabel2: UILabel!
    @IBOutlet weak var outfitLabel3: UILabel!
    @IBOutlet weak var hourlyForecastStackView: UIStackView!

    private var dateTimer: Timer?
    private var currentWeather: CurrentWeather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add observer for outfit updates
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleOutfitUpdate),
            name: NSNotification.Name("OutfitUpdated"),
            object: nil
        )
        
        fetchWeather()
        setupDateTimeUpdates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("🔄 Today view appearing, refreshing data...")
        // Refresh weather and outfit data when view appears
        fetchWeather()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dateTimer?.invalidate()
        dateTimer = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupDateTimeUpdates() {
        // Update immediately
        updateDateTime()
        
        // Then update every minute
        dateTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            self?.updateDateTime()
        }
    }
    
    private func updateDateTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        let dateString = dateFormatter.string(from: Date())
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let timeString = timeFormatter.string(from: Date())
        
        DispatchQueue.main.async {
            self.dateTimeLabel.text = "\(dateString) at \(timeString)"
        }
    }

    @objc private func handleOutfitUpdate() {
        print("🔄 Outfit updated, refreshing suggested outfit...")
        // Only refresh outfit suggestion if we have current weather
        if let weather = self.currentWeather {
            self.updateSuggestedOutfit(for: weather)
        } else {
            // If no weather data, fetch everything again
            self.fetchWeather()
        }
    }
    
    private func updateSuggestedOutfit(for weather: CurrentWeather) {
        let suggestedOutfit = OutfitStore.shared.getSuggestedOutfit(for: weather)
        
        DispatchQueue.main.async {
            if let outfit = suggestedOutfit {
                print("👕 Displaying outfit: \(outfit.name)")
                print("   Items: \(outfit.items)")
                self.outfitLabel1.text = outfit.items.count > 0 ? outfit.items[0] : ""
                self.outfitLabel2.text = outfit.items.count > 1 ? outfit.items[1] : ""
                self.outfitLabel3.text = outfit.items.count > 2 ? outfit.items[2] : ""
            } else {
                print("⚠️ No outfit found for current conditions")
                print("   Temperature: \(weather.temperature)°F")
                print("   Condition: \(weather.condition)")
                self.outfitLabel1.text = "No saved outfit"
                self.outfitLabel2.text = ""
                self.outfitLabel3.text = ""
            }
        }
    }

    func fetchWeather() {
        Task {
            do {
                let weather = try await WeatherService.shared.getCurrentWeather(latitude: 41.8781, longitude: -87.6298)

                // ✅ Print received weather data
                print("🌦️ Current Weather Data:")
                print("   Temperature: \(weather.current.temperature)°F")
                print("   Condition: \(weather.current.condition)")
                print("   Feels Like: \(weather.current.temperature)°F")

                // Store current weather for later use
                self.currentWeather = weather.current

                DispatchQueue.main.async {
                    self.temperatureLabel.text = "\(weather.current.temperature)°F"
                    self.conditionLabel.text = weather.current.condition
                    self.feelsLikeLabel.text = "Feels Like: \(weather.current.temperature)°F"
                }
                
                // Update outfit suggestion
                self.updateSuggestedOutfit(for: weather.current)
                
            } catch {
                print("❌ Failed to fetch weather: \(error)")
            }
        }
    }


//    func fetchWeather() {
//        Task {
//            do {
//                // ✅ Fetch weather from API
//                let weather = try await WeatherService.shared.getCurrentWeather(latitude: 41.8781, longitude: -87.6298)
//                let suggestedOutfit = OutfitStore.shared.getSuggestedOutfit(for: weather.current)
//
//
//
//
//                DispatchQueue.main.async {
//                    // ✅ Set Weather Data
//                    self.temperatureLabel.text = "\(weather.current.temperature)°F"
//                    self.conditionLabel.text = weather.current.condition
//                    self.feelsLikeLabel.text = "Feels Like: \(weather.current.temperature)°F"
//
//                    // ✅ Display Suggested Outfit (Fetched from User-Saved Outfits)
//                    if let outfit = suggestedOutfit {
//                        let items = outfit.items
//                        self.outfitLabel1.text = items.count > 0 ? items[0] : ""
//                        self.outfitLabel2.text = items.count > 1 ? items[1] : ""
//                        self.outfitLabel3.text = items.count > 2 ? items[2] : ""
//                    } else {
//                        self.outfitLabel1.text = "No saved outfit for this weather"
//                        self.outfitLabel2.text = ""
//                        self.outfitLabel3.text = ""
//                    }
//
//                    // ✅ Update Hourly Forecast (First 3 Forecast Entries)
//                    for subview in self.hourlyForecastStackView.arrangedSubviews {
//                        subview.removeFromSuperview()
//                    }
//                    for (index, forecast) in weather.forecast.prefix(3).enumerated() {
//                        let label = UILabel()
//                        label.text = "\(index * 3)hr: \(forecast.high)°F"
//                        label.textAlignment = .center
//                        self.hourlyForecastStackView.addArrangedSubview(label)
//                    }
//                }
//            } catch {
//                print("❌ Failed to load weather data: \(error)")
//            }
//        }
//    }

}
