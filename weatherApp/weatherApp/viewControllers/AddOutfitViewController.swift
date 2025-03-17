//
//  AddOutfitViewController.swift
//  weatherApp
//
//  Created by Yogesh Lakhani on 3/4/25.
//

import UIKit

class AddOutfitViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var minTempPicker: UIPickerView!
    @IBOutlet weak var maxTempPicker: UIPickerView!
    @IBOutlet weak var weatherTypePicker: UIPickerView! // ✅ Fixed: Renamed to PickerView
    @IBOutlet weak var clothingItemsTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteButton: UIButton!

    var onSave: ((Outfit) -> Void)?
    var outfitToEdit: Outfit?

    private var selectedWeatherType: String? // ✅ Stores selected weather type
    private var clothingItems: [String] = []
    private var selectedItemIndex: Int?

    // ✅ Predefined temperature values
    private let temperatures = Array(-10...120)

    // ✅ Updated Weather Conditions (Matches API)
    private let weatherOptions = [
        "Clear", "Mostly Sunny", "Partly Cloudy", "Cloudy", "Overcast",
        "Rain Showers", "Light Rain", "Heavy Rain", "Thunderstorms",
        "Drizzle", "Snow", "Light Snow", "Heavy Snow", "Sleet",
        "Freezing Rain", "Fog", "Haze", "Dust", "Smoke",
        "Windy", "Breezy", "Gusty Winds"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ✅ Setup Table View
        tableView.delegate = self
        tableView.dataSource = self
        
        // ✅ Setup Picker Views
        minTempPicker.delegate = self
        minTempPicker.dataSource = self
        maxTempPicker.delegate = self
        maxTempPicker.dataSource = self
        weatherTypePicker.delegate = self
        weatherTypePicker.dataSource = self
        
        // ✅ Ensure delete button is disabled initially
        deleteButton.isEnabled = false
        
        // ✅ Pre-fill outfit data if editing
        if let outfit = outfitToEdit {
            nameTextField.text = outfit.name
            minTempPicker.selectRow(temperatures.firstIndex(of: Int(outfit.minTemp)) ?? 0, inComponent: 0, animated: false)
            maxTempPicker.selectRow(temperatures.firstIndex(of: Int(outfit.maxTemp)) ?? 0, inComponent: 0, animated: false)
            clothingItems = outfit.items
            selectedWeatherType = outfit.weatherTypes.first
            if let index = weatherOptions.firstIndex(of: outfit.weatherTypes.first ?? "") {
                weatherTypePicker.selectRow(index, inComponent: 0, animated: false)
            }
        } else {
            // Set default values for new outfit
            resetForm()
        }
    }

    private func resetForm() {
        // Reset text fields
        nameTextField.text = ""
        clothingItemsTextField.text = ""
        
        // Reset clothing items
        clothingItems.removeAll()
        tableView.reloadData()
        
        // Reset pickers to default values
        minTempPicker.selectRow(temperatures.firstIndex(of: -0) ?? 0, inComponent: 0, animated: true)
        maxTempPicker.selectRow(temperatures.firstIndex(of: 80) ?? 0, inComponent: 0, animated: true)
        weatherTypePicker.selectRow(0, inComponent: 0, animated: false)
        selectedWeatherType = weatherOptions[0]
        
        // Reset delete button
        deleteButton.isEnabled = false
        selectedItemIndex = nil
    }

    // ✅ Save Outfit
    @IBAction func saveTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty else {
            showError(message: "Please enter an outfit name")
            return
        }
        
        guard !clothingItems.isEmpty else {
            showError(message: "Please add at least one clothing item")
            return
        }
        
        guard let weather = selectedWeatherType else {
            showError(message: "Please select a weather type")
            return
        }

        let minTemp = temperatures[minTempPicker.selectedRow(inComponent: 0)]
        let maxTemp = temperatures[maxTempPicker.selectedRow(inComponent: 0)]
        
        // Validate temperature range
        guard minTemp <= maxTemp else {
            showError(message: "Minimum temperature should be less than or equal to maximum temperature")
            return
        }

        let newOutfit = Outfit(
            name: name,
            minTemp: Double(minTemp),
            maxTemp: Double(maxTemp),
            weatherTypes: [weather],
            items: clothingItems
        )

        if let existingOutfit = outfitToEdit {
            OutfitStore.shared.deleteOutfit(existingOutfit)
        }

        OutfitStore.shared.saveOutfit(newOutfit)
        
        // Post notification that outfit was updated
        NotificationCenter.default.post(name: NSNotification.Name("OutfitUpdated"), object: nil)

        // Show success message
        let alert = UIAlertController(
            title: "Success",
            message: "Outfit saved successfully!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            // Reset the form after user acknowledges the save
            self?.resetForm()
        })
        present(alert, animated: true)
    }

    // ✅ Add Clothing Item
    @IBAction func addClothingItemTapped(_ sender: UIButton) {
        guard let item = clothingItemsTextField.text, !item.isEmpty else {
            showError(message: "Please enter a clothing item")
            return
        }
        
        clothingItems.append(item)
        tableView.reloadData()
        clothingItemsTextField.text = ""
    }

    // ✅ Delete Selected Clothing Item
    @IBAction func deleteItemTapped(_ sender: UIButton) {
        guard let index = selectedItemIndex else { return }
        clothingItems.remove(at: index)
        tableView.reloadData()
        selectedItemIndex = nil
        deleteButton.isEnabled = false
    }
    
    

    // ✅ Show error messages
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // ✅ Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clothingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClothingItemCell", for: indexPath)
        cell.textLabel?.text = clothingItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItemIndex = indexPath.row
        deleteButton.isEnabled = true
    }

    // ✅ Picker View Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == minTempPicker || pickerView == maxTempPicker {
            return temperatures.count
        } else {
            return weatherOptions.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == minTempPicker || pickerView == maxTempPicker {
            return "\(temperatures[row])°F"
        } else {
            return weatherOptions[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == weatherTypePicker {
            selectedWeatherType = weatherOptions[row] // ✅ Store selected weather type
        }
    }
}
