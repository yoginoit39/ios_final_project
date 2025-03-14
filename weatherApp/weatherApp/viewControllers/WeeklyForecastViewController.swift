//
//  WeeklyForecastViewController.swift
//  weatherApp
//
//  Created by Yogesh Lakhani on 3/4/25.
//

import UIKit

class WeeklyForecastViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var weeklyForecast: [DailyForecast] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchWeather()
    }

    private func fetchWeather() {
        Task {
            do {
                // ✅ Using hardcoded coordinates, just like TodayViewController
                let weather = try await WeatherService.shared.getCurrentWeather(
                    latitude: 41.8781,
                    longitude: -87.6298
                )
                self.weeklyForecast = weather.forecast
                
                DispatchQueue.main.async {
                    print("✅ Loaded Forecast Data: \(self.weeklyForecast.count) days")
                    self.tableView.reloadData()
                }
            } catch {
                print("❌ Failed to fetch weekly forecast: \(error)")
            }
        }
    }
}



// MARK: - TableView DataSource & Delegate
extension WeeklyForecastViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("📊 TableView Rows: \(weeklyForecast.count)")
        return weeklyForecast.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("🔄 Creating cell for row \(indexPath.row)")

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeeklyForecastCell else {
            print("❌ Failed to dequeue WeatherCell")
            return UITableViewCell()
        }

        let forecast = weeklyForecast[indexPath.row]
        
        // ✅ Corrected date formatting logic
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" // Get full weekday name
        dateFormatter.locale = Locale(identifier: "en_US") // Ensure correct locale

        let calendar = Calendar.current
        let today = Date() // Get today's date
        
        var dayString: String
        
        if indexPath.row == 0 {
            dayString = "Today" // First row should be Today
        } else {
            let forecastDate = calendar.date(byAdding: .day, value: indexPath.row, to: today) ?? today
            dayString = dateFormatter.string(from: forecastDate)
        }

        cell.dayLabel.text = dayString
        cell.temperatureLabel.text = "\(forecast.high)°F"

        // ✅ Fetch suggested outfit
        if let suggestedOutfit = OutfitStore.shared.getSuggestedOutfit(for: CurrentWeather(temperature: forecast.high, condition: forecast.condition, icon: "")) {
            cell.outfitLabel.text = suggestedOutfit.items.joined(separator: ", ")
        } else {
            cell.outfitLabel.text = "No outfit suggested"
        }

        return cell
    }
}
