//
//  AddOutfitViewController.swift
//  weatherApp
//
//  Created by Yogesh Lakhani on 3/4/25.
//

import UIKit

class AddOutfitViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {

    // ✅ UI Outlets (All should be connected in Storyboard)
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
        }
    }

    // ✅ Save Outfit
    @IBAction func saveTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !clothingItems.isEmpty, let weather = selectedWeatherType else {
            showError(message: "Please fill all fields and add at least one clothing item")
            return
        }

        let minTemp = temperatures[minTempPicker.selectedRow(inComponent: 0)]
        let maxTemp = temperatures[maxTempPicker.selectedRow(inComponent: 0)]

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

        // Send system notification
        NotificationManager.shared.sendNotification(
            title: "New Outfit Added",
            message: "You added \(name) to your outfits."
        )

        navigationController?.popViewController(animated: true)
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
