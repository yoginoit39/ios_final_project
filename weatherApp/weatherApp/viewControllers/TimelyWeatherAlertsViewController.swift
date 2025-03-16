//
//  TimelyWeatherAlertsViewController.swift
//  weatherApp
//
//  Created by Yogesh lakhani on 3/14/25.
//



import UIKit
import CoreLocation


class TimelyWeatherAlertsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var weatherAlerts: [WeatherAlertData] = []
    private var previousAlertCount = 0 // Track previous number of alerts

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Request notification permission
        NotificationManager.shared.requestPermission()
        
        fetchWeatherAlerts()
    }

    func fetchWeatherAlerts() {
        Task {
            do {
                print("\n🔄 Starting to fetch weather alerts...")
                
                // Request location permission
                await LocationManager.shared.requestLocationPermission()
                
                // Get location
                let location = await getLocationSafely()
                print("📍 Using location: \(location.latitude), \(location.longitude)")
                
                // Fetch weather data
                print("🌐 Fetching weather data from NWS API...")
                let weatherData = try await WeatherService.shared.getCurrentWeather(
                    latitude: location.latitude,
                    longitude: location.longitude
                )
                
                print("\n📊 Weather Data Response:")
                print("- Total Alerts: \(weatherData.alerts?.count ?? 0)")
                
                if let alerts = weatherData.alerts {
                    print("\n🚨 Alert Details:")
                    for (index, alert) in alerts.enumerated() {
                        print("\nAlert #\(index + 1):")
                        print("- Event: \(alert.event)")
                        print("- Start Time: \(alert.startTime ?? "N/A")")
                        print("- End Time: \(alert.endTime ?? "N/A")")
                        print("- Description: \(String(describing: alert.description).prefix(100))...")
                    }
                    
                    // Check for new alerts
                    if alerts.count > previousAlertCount {
                        // Send notification for each new alert
                        for alert in alerts {
                            let title = "⚠️ Weather Alert: \(alert.event)"
                            let timeText = alert.formattedTime()
                            let body = "Active from \(timeText)"
                            NotificationManager.shared.scheduleNotification(
                                title: title,
                                body: body,
                                timeInterval: 1
                            )
                        }
                    }
                }

                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.previousAlertCount = self.weatherAlerts.count // Store current count
                    self.weatherAlerts = weatherData.alerts ?? []
                    
                    print("\n📱 UI Update:")
                    print("- Alerts to display: \(self.weatherAlerts.count)")
                    
                    if self.weatherAlerts.isEmpty {
                        print("ℹ️ No active alerts - showing empty state message")
                        let label = UILabel()
                        label.text = "No active weather alerts"
                        label.textAlignment = .center
                        label.textColor = .gray
                        self.tableView.backgroundView = label
                    } else {
                        print("✅ Displaying \(self.weatherAlerts.count) alert(s)")
                        self.tableView.backgroundView = nil
                    }
                    
                    self.tableView.reloadData()
                }
            } catch {
                print("\n❌ Error fetching weather alerts:")
                print("- Error details: \(error)")
                print("- Localized description: \(error.localizedDescription)")
                self.showError(message: "Failed to fetch weather alerts: \(error.localizedDescription)")
            }
        }
    }





    


    func getLocationSafely() async -> (latitude: Double, longitude: Double) {
        // Check if location services are enabled at system level
        guard CLLocationManager.locationServicesEnabled() else {
            print("❌ Location services are disabled.")
            return (41.8781, -87.6298) // Default to Chicago
        }
        
        // Get current authorization status
        let status = await LocationManager.shared.getAuthorizationStatus()
        
        switch status {
        case .notDetermined:
            // Request permission and wait for result
            print("📍 Requesting location permission...")
            await LocationManager.shared.requestLocationPermission()
            
        case .denied, .restricted:
            print("❌ Location access denied or restricted")
            return (41.8781, -87.6298) // Default to Chicago
            
        case .authorizedWhenInUse, .authorizedAlways:
            break // Permission already granted, continue
            
        @unknown default:
            print("⚠️ Unknown authorization status")
            return (41.8781, -87.6298) // Default to Chicago
        }
        
        // Try to get current location
        if let location = await LocationManager.shared.getCurrentLocation() {
            return (location.coordinate.latitude, location.coordinate.longitude)
        }
        
        // If no current location, request an update
        if let location = await LocationManager.shared.requestLocationUpdate() {
            return (location.coordinate.latitude, location.coordinate.longitude)
        }
        
        // Fallback to default location
        print("❌ Could not get location, using default coordinates")
        return (41.8781, -87.6298) // Default to Chicago
    }






    // TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherAlerts.count
    }
    
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherAlertCell", for: indexPath) as! WeatherAlertCell
        let alert = weatherAlerts[indexPath.row]
        
        cell.titleLabel.text = "⚠️ \(alert.event)"
        
        let timeText = alert.formattedTime()
        let fullDescription = """
        Time: \(timeText)
        
        \(alert.description)
        """
        cell.descriptionLabel.text = fullDescription
        
        return cell
    }

    // Set the row height to automatically adjust based on content
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150 // Provide an estimated height for better performance
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

