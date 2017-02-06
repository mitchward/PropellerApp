//
//  FavouritesViewController.swift
//  Propeller
//
//  Created by Mitchell Ward on 09/01/2017.
//  Copyright © 2017 Mitchell Ward. All rights reserved.
//

import UIKit

class FavouritesViewController: UITableViewController {
    
    @IBOutlet weak var favouritesTable: UITableView!
    
    var employees: [Employee] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        EmployeeClient.sharedClient.getEmployees(onlyFavourites: true) { [weak self](employees) in
            self?.employees = employees
            DispatchQueue.main.async {
                self?.favouritesTable.reloadData()
            }
        }
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return employees.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell", for: indexPath) as! EmployeeTableViewCell
        
        let employee = employees[indexPath.row]
        cell.configure(employee: employee)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ViewEmployeeSegue", sender: employees[indexPath.row])
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let employee = self.employees[indexPath.row]
            EmployeeClient.sharedClient.removeFavourite(id: employee.id)
            
            employees.remove(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! EmployeeViewController
        destination.employee = sender as? Employee
    }
}
