//
//  DirectoryViewController.swift
//  Propeller
//
//  Created by Mitchell Ward on 21/12/2016.
//  Copyright © 2016 Mitchell Ward. All rights reserved.
//

import UIKit
import CoreData

class DirectoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var employees: [Employee] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        EmployeeClient.sharedClient.getEmployees {[weak self](employees) in
            self?.employees = employees
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell", for: indexPath) as! EmployeeTableViewCell
        
        let employee = employees[indexPath.row]
        cell.configure(employee: employee)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ViewEmployeeSegue", sender: employees[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! EmployeeViewController
        
        destination.employee = sender as? Employee
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let favouriteAction = UITableViewRowAction(style: .normal, title: "Add to Favourites") { (action: UITableViewRowAction!, indexPath: IndexPath) -> Void in
        
            let employee = self.employees[indexPath.row]
            EmployeeClient.sharedClient.addFavourite(id: employee.id)
            
            tableView.setEditing(false, animated: true)
            
        }
        
        favouriteAction.backgroundColor = UIColor.blue
        
        return [favouriteAction]
    }
    
}
