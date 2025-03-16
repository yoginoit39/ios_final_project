//
//  NotificationSettingsViewController.swift
//  weatherApp
//
//  Created by Yogesh lakhani on 3/14/25.
//
import UIKit

class NotificationSettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var weatherSwitch: UISwitch!
    @IBOutlet weak var temperatureSwitch: UISwitch!
    @IBOutlet weak var rainSwitch: UISwitch!
    @IBOutlet weak var belowTempPicker: UIPickerView!
    @IBOutlet weak var aboveTempPicker: UIPickerView!

    let temperatureOptions = Array(-20...120) // Range from -20°F to 120°F
    var selectedBelowTemp: Int = 40 // Default below temp
    var selectedAboveTemp: Int = 85 // Default above temp

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set pickers' dataSource and delegate
        belowTempPicker.dataSource = self
        belowTempPicker.delegate = self
        aboveTempPicker.dataSource = self
        aboveTempPicker.delegate = self

        // Load saved preferences
        loadSettings()
    }

    @IBAction func saveSettings(_ sender: UIButton) {
        let weatherAlertsEnabled = weatherSwitch.isOn
        let tempAlertsEnabled = temperatureSwitch.isOn
        let rainAlertsEnabled = rainSwitch.isOn

        // Save data locally (UserDefaults)
        let defaults = UserDefaults.standard
        defaults.set(weatherAlertsEnabled, forKey: "weatherAlerts")
        defaults.set(tempAlertsEnabled, forKey: "tempAlerts")
        defaults.set(rainAlertsEnabled, forKey: "rainAlerts")
        defaults.set(selectedBelowTemp, forKey: "belowTemp")
        defaults.set(selectedAboveTemp, forKey: "aboveTemp")

        // Show confirmation
        let alert = UIAlertController(title: "Saved", message: "Your notification settings have been saved!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func loadSettings() {
        let defaults = UserDefaults.standard
        weatherSwitch.isOn = defaults.bool(forKey: "weatherAlerts")
        temperatureSwitch.isOn = defaults.bool(forKey: "tempAlerts")
        rainSwitch.isOn = defaults.bool(forKey: "rainAlerts")

        selectedBelowTemp = defaults.integer(forKey: "belowTemp") != 0 ? defaults.integer(forKey: "belowTemp") : 40
        selectedAboveTemp = defaults.integer(forKey: "aboveTemp") != 0 ? defaults.integer(forKey: "aboveTemp") : 85

        // Update picker selection
        if let belowIndex = temperatureOptions.firstIndex(of: selectedBelowTemp) {
            belowTempPicker.selectRow(belowIndex, inComponent: 0, animated: false)
        }
        if let aboveIndex = temperatureOptions.firstIndex(of: selectedAboveTemp) {
            aboveTempPicker.selectRow(aboveIndex, inComponent: 0, animated: false)
        }
    }

    // MARK: - UIPickerView DataSource & Delegate Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Single column picker
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return temperatureOptions.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(temperatureOptions[row])°F"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedTemperature = temperatureOptions[row]
        if pickerView == belowTempPicker {
            selectedBelowTemp = selectedTemperature
            print("Selected Below Temperature: \(selectedBelowTemp)°F")
        } else if pickerView == aboveTempPicker {
            selectedAboveTemp = selectedTemperature
            print("Selected Above Temperature: \(selectedAboveTemp)°F")
        }
    }
}
