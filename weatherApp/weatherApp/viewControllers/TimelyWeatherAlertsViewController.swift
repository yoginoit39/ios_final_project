//
//  TimelyWeatherAlertsViewController.swift
//  weatherApp
//
//  Created by Yogesh lakhani on 3/14/25.
//



import UIKit

class TimelyWeatherAlertsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var weatherAlerts: [WeatherAlertData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchWeatherAlerts()
    }

    func fetchWeatherAlerts() {
        Task {
            do {
                let location = await getLocationSafely()
                let weatherData = try await WeatherService.shared.getCurrentWeather(
                    latitude: location.latitude,
                    longitude: location.longitude
                )

                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.weatherAlerts = weatherData.alerts ?? []
                    if self.weatherAlerts.isEmpty {
                        // Show a message when there are no alerts
                        let label = UILabel()
                        label.text = "No active weather alerts"
                        label.textAlignment = .center
                        label.textColor = .gray
                        self.tableView.backgroundView = label
                    } else {
                        self.tableView.backgroundView = nil
                    }
                    self.tableView.reloadData()
                }
            } catch {
                self.showError(message: "Failed to fetch weather alerts")
            }
        }
    }

    
    
    func getLocationSafely() async -> (latitude: Double, longitude: Double) {
        if let location = LocationManager.shared.getCurrentLocation() {
            return (location.latitude, location.longitude)
        } else {
            if let newLocation = await LocationManager.shared.requestLocationUpdate() {
                return (newLocation.latitude, newLocation.longitude)
            }
            return (41.8781, -87.6298) // Default to Chicago
        }
    }

    // TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherAlerts.count
    }
    
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherAlertCell", for: indexPath) as! WeatherAlertCell
        let alert = weatherAlerts[indexPath.row]
        
        cell.titleLabel.text = "⚠️ \(alert.event)"
        
        // Format the description text
        let timeText = alert.formattedTime()
        cell.descriptionLabel.text = timeText
        
        return cell
    }

    // Clear All Alerts
    @IBAction func clearAlerts(_ sender: UIButton) {
        weatherAlerts.removeAll()
        tableView.reloadData()
        
        // Show "No alerts" message
        let label = UILabel()
        label.text = "No active weather alerts"
        label.textAlignment = .center
        label.textColor = .gray
        tableView.backgroundView = label
    }
    
    private func showError(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Error",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

