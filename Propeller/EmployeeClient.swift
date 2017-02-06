//
//  EmployeeClient.swift
//  Propeller
//
//  Created by Mitchell Ward on 21/12/2016.
//  Copyright © 2016 Mitchell Ward. All rights reserved.
//

import UIKit
import CoreData

class EmployeeClient {
    
    static let sharedClient = EmployeeClient();
    
    func addFavourite(id: Int16) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let favourite = Favourite(context: context)
        
        favourite.id = id
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
    }
    
    func removeFavourite(id: Int16) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        var favourites: [Favourite] = []
        
        do {
            favourites = try context.fetch(Favourite.fetchRequest())
            for favourite in favourites {
                if favourite.id == id {
                    context.delete(favourite)
                }
            }
        } catch {
            print(error)
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        
    }
    
    func getEmployees(onlyFavourites: Bool = false, completion: @escaping ([Employee]) -> ()) {

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        var employees: [Employee] = []
        var favourites: [Favourite] = []
        if onlyFavourites {
            do {
                favourites = try context.fetch(Favourite.fetchRequest())
                print(favourites)
                
            } catch {
                print("Fetching failed")
            }
        }
        
        get(request: clientURLRequest(path: "profiles/all")) { (success, object) in
            if let results = object as? [[String: AnyObject]] {
                for result in results {
                    if let employee = Employee(json: result) {
                        if onlyFavourites {
                            for favourite in favourites {
                                if favourite.id == employee.id {
                                    employees.append(employee)
                                }
                            }
                        } else {
                            employees.append(employee)
                        }
                    }
                }
            }
            
            completion(employees)
        }

    }
    
    private func get(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request: request, method: "GET", completion: completion)
    }
    
    private func clientURLRequest(path: String, params: Dictionary<String, AnyObject>? = nil) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: NSURL(string: "http://192.168.6.95:40003/"+path)! as URL)
        
        return request
    }
    
    private func dataTask(request: NSMutableURLRequest, method: String, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        request.httpMethod = method
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    completion(true, json as AnyObject?)
                } else {
                    completion(false, json as AnyObject?)
                }
            }
            }.resume()
    }
}
