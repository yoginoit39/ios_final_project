//
//  MyOutfitsViewController.swift
//  weatherApp
//
//  Created by Yogesh Lakhani on 3/4/25.
//


import UIKit
import UserNotifications


class MyOutfitsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // ✅ UI Outlets (All should be connected in Storyboard)
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var weatherFilterPicker: UIPickerView!
    
    private var outfits: [Outfit] = []  // Stores all user outfits
    private var filteredOutfits: [Outfit] = []  // Stores filtered outfits

    // ✅ Updated Weather Conditions (Matches API)
    private let weatherTypes = [
        "All", "Clear", "Mostly Sunny", "Partly Cloudy", "Cloudy", "Overcast",
        "Rain Showers", "Light Rain", "Heavy Rain", "Thunderstorms",
        "Drizzle", "Snow", "Light Snow", "Heavy Snow", "Sleet",
        "Freezing Rain", "Fog", "Haze", "Dust", "Smoke",
        "Windy", "Breezy", "Gusty Winds"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ✅ Setup Table View and Picker View
        tableView.delegate = self
        tableView.dataSource = self
        weatherFilterPicker.delegate = self
        weatherFilterPicker.dataSource = self
        
        loadOutfits()
    }
    
    // ✅ Required UIPickerViewDataSource methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1  // Single column for weather types
    }
    
    
    
    

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weatherTypes.count  // Number of weather types
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return weatherTypes[row]
    }

    // ✅ Filtering outfits by weather type
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedFilter = weatherTypes[row]

        if selectedFilter == "All" {
            filteredOutfits = outfits
        } else {
            filteredOutfits = outfits.filter { $0.weatherTypes.contains(selectedFilter) }
        }
        tableView.reloadData()
    }
    
    // ✅ Load outfits from storage
    private func loadOutfits() {
        outfits = OutfitStore.shared.getAllOutfits() // ✅ Now persistent
        filteredOutfits = outfits
        tableView.reloadData()
        print("📂 Outfits loaded in MyOutfitsViewController: \(outfits.count)")
    }
    
    // ✅ Number of sections in tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredOutfits.count
    }
    
    // ✅ Number of rows per section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // ✅ Configure outfit cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OutfitCell", for: indexPath)
        let outfit = filteredOutfits[indexPath.section]
        
        cell.textLabel?.text = "\(outfit.name) (\(outfit.minTemp)°F - \(outfit.maxTemp)°F)"
        cell.detailTextLabel?.text = outfit.items.joined(separator: ", ")
        
        return cell
    }
    
    // ✅ Improved Delete Outfit Function
//    @IBAction func deleteOutfitTapped(_ sender: UIButton) {
//        // ✅ Ensure the button is inside a UITableViewCell
//        guard let cell = sender.superview?.superview as? UITableViewCell,
//              let indexPath = tableView.indexPath(for: cell) else {
//            print("❌ Failed to get indexPath for deletion")
//            return
//        }
//
//        let outfitToDelete = filteredOutfits[indexPath.section]
//
//        // ✅ Remove from OutfitStore (Persistent storage)
//        OutfitStore.shared.deleteOutfit(outfitToDelete)
//
//        // ✅ Update local lists
//        outfits.removeAll { $0.name == outfitToDelete.name }
//        filteredOutfits.remove(at: indexPath.section)
//
//        // ✅ Reload table to reflect deletion
//        tableView.reloadData()
//    }
    
    @IBAction func deleteOutfitTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell) else {
            print("❌ Failed to get indexPath for deletion")
            return
        }

        let outfitToDelete = filteredOutfits[indexPath.section]

        // ✅ Remove from storage and update table
        OutfitStore.shared.deleteOutfit(outfitToDelete)
        outfits.removeAll { $0.name == outfitToDelete.name }
        filteredOutfits.remove(at: indexPath.section)
        tableView.reloadData()

        // ✅ Send system notification (Fixed the function call)
      NotificationManager.shared.sendNotification(title: "Outfit Removed", message: "You deleted \(outfitToDelete.name) from your outfits.")

        // ✅ Post in-app notification
        NotificationCenter.default.post(name: NSNotification.Name("OutfitNotification"), object: "🗑 Outfit Removed: \(outfitToDelete.name)")

        print("🗑 Outfit deleted: \(outfitToDelete.name)")
    }


    
 

//    // ✅ Improved Edit Outfit Function
//    @IBAction func editOutfitTapped(_ sender: UIButton) {
//        // ✅ Find the cell's indexPath
//        guard let cell = sender.superview?.superview as? UITableViewCell,
//              let indexPath = tableView.indexPath(for: cell) else {
//            print("❌ Failed to get indexPath for editing")
//            return
//        }
//
//        let outfitToEdit = filteredOutfits[indexPath.section]
//
//        // ✅ Navigate to AddOutfitViewController
//        if let addOutfitVC = storyboard?.instantiateViewController(withIdentifier: "AddOutfitViewController") as? AddOutfitViewController {
//            addOutfitVC.outfitToEdit = outfitToEdit
//
//            // ✅ Ensure edited outfit is saved back to OutfitStore
//            addOutfitVC.onSave = { updatedOutfit in
//                if let index = self.outfits.firstIndex(where: { $0.name == outfitToEdit.name }) {
//                    self.outfits[index] = updatedOutfit
//                }
//                if let filteredIndex = self.filteredOutfits.firstIndex(where: { $0.name == outfitToEdit.name }) {
//                    self.filteredOutfits[filteredIndex] = updatedOutfit
//                }
//
//                // ✅ Save to OutfitStore to persist changes
//                OutfitStore.shared.saveOutfit(updatedOutfit)
//
//                // ✅ Refresh UI
//                self.tableView.reloadData()
//            }
//
//            navigationController?.pushViewController(addOutfitVC, animated: true)
//        }
//    }

    
//    // ✅ IBAction for Delete Button
//    @IBAction func deleteOutfitTapped(_ sender: UIButton) {
//        if let cell = sender.superview?.superview as? UITableViewCell,
//           let indexPath = tableView.indexPath(for: cell) {
//            
//            let outfitToDelete = filteredOutfits[indexPath.section]
//            
//            // Remove from both filtered and original list
//            outfits.removeAll { $0.name == outfitToDelete.name }
//            filteredOutfits.remove(at: indexPath.section)
//            
//            // Update OutfitStore (Remove from persistent storage)
//            OutfitStore.shared.deleteOutfit(outfitToDelete)
//            
//            tableView.reloadData()
//        }
//    }
//
//    // ✅ IBAction for Edit Button
//    @IBAction func editOutfitTapped(_ sender: UIButton) {
//        if let cell = sender.superview?.superview as? UITableViewCell,
//           let indexPath = tableView.indexPath(for: cell) {
//            
//            let outfitToEdit = filteredOutfits[indexPath.section]
//            
//            // Navigate to AddOutfitViewController to edit
//            if let addOutfitVC = storyboard?.instantiateViewController(withIdentifier: "AddOutfitViewController") as? AddOutfitViewController {
//                addOutfitVC.outfitToEdit = outfitToEdit
//                
//                addOutfitVC.onSave = { updatedOutfit in
//                    if let existingIndex = self.outfits.firstIndex(where: { $0.name == updatedOutfit.name }) {
//                        self.outfits[existingIndex] = updatedOutfit
//                    }
//                    if let filteredIndex = self.filteredOutfits.firstIndex(where: { $0.name == updatedOutfit.name }) {
//                        self.filteredOutfits[filteredIndex] = updatedOutfit
//                    }
//                    self.tableView.reloadData()
//                }
//                
//                navigationController?.pushViewController(addOutfitVC, animated: true)
//            }
//        }
//    }
}
