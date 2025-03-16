//
//  TemperatureCategoriesViewController.swift
//  weatherApp
//
//  Created by Yogesh lakhani on 3/14/25.
//

import UIKit

class TemperatureCategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    let temperatureCategories: [(range: String, suggestions: [String])] = [
        ("Hot (Above 85°F)", ["Light clothing", "Sun protection"]),
        ("Warm (70° - 85°F)", ["T-shirt, shorts", "Light clothing"]),
        ("Cool (50° - 70°F)", ["Light jacket", "Long sleeves"])
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return temperatureCategories.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temperatureCategories[section].suggestions.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return temperatureCategories[section].range
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TemperatureCategoryCell", for: indexPath)
        let suggestion = temperatureCategories[indexPath.section].suggestions[indexPath.row]
        cell.textLabel?.text = suggestion
        return cell
    }
}

