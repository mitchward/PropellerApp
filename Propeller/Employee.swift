//
//  Employee.swift
//  Propeller
//
//  Created by Mitchell Ward on 21/12/2016.
//  Copyright © 2016 Mitchell Ward. All rights reserved.
//

import Foundation

struct Employee {
    let id: Int16
    let name: String
    let email: String
    let position: String
    let isAway: Bool
    let avatar: URL
    
    init?(json: [String: AnyObject]) {
        guard let disabled = json["disabled"] as? Bool else {
            return nil
        }
        if disabled { return nil }
        
        guard let id = json["id"] as? Int16 else {
            return nil
        }
        self.id = id
        
        guard let name = json["name"] as? String else {
            return nil
        }
        self.name = name
        
        guard let email = json["email"] as? String else {
            return nil
        }
        self.email = email
        
        guard let position = json["position"] as? String else {
            return nil
        }
        self.position = position

        guard let isAway = json["holiday"] as? Bool else {
            return nil
        }
        self.isAway = isAway
       
        guard var avatar = json["image"] as? String else {
            return nil
        }
        if !avatar.hasSuffix(".jpg") {
            avatar = "http://proppages.dev/assets/img/profiles/none.jpg"
        }
        self.avatar = URL(string: avatar)!
    }
}
