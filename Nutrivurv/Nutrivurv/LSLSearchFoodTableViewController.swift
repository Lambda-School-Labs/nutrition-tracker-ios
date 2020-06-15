//
//  LSLSearchFoodTableViewController.swift
//  Nutrivurv
//
//  Created by Michael Stoffer on 4/20/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class LSLSearchFoodTableViewController: UITableViewController {
    
    @IBOutlet weak var foodSearchBar: UISearchBar!
    
    let searchController = LSLSearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.foodSearchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.foodSearchBar.searchTextField.text = ""
        self.tableView.reloadData()
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.foods.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath)

        cell.textLabel?.text = self.searchController.foods[indexPath.row].food.label.capitalized

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FoodDetail" {
            guard let indexPath = self.tableView.indexPathForSelectedRow,
                let fdVC = segue.destination as? LSLFoodDetailViewController else { return }
            
            let foodItem = self.searchController.foods[indexPath.row]
            fdVC.searchController = self.searchController
            fdVC.foodItem = foodItem
        } else if segue.identifier == "ShowBarcodeScanner" {
            guard let barcodeScanVC = segue.destination as? LSLBarcodeSearchViewController else {
                print("Couldn't load barcode scanner")
                return
            }
            self.searchController.foods = []
            barcodeScanVC.delegate = self
            barcodeScanVC.searchController = self.searchController
        }
    }
    
    
    // MARK: - Alert Controllers
    
    private func createAndDisplayAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension LSLSearchFoodTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = self.foodSearchBar.text else { return }
        
        self.foodSearchBar.endEditing(true)
        
        // Perform search for food item
        self.searchController.searchForFoodItemWithKeyword(searchTerm: searchTerm) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension LSLSearchFoodTableViewController: BarcodeSearchDelegate {
    func gotResultForFoodFromUPC() {
        self.tableView.reloadData()
    }
}

extension LSLSearchFoodTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


protocol BarcodeSearchDelegate {
    func gotResultForFoodFromUPC()
}
