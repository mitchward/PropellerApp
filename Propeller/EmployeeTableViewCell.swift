//
//  EmployeeTableViewCell.swift
//  Propeller
//
//  Created by Mitchell Ward on 05/01/2017.
//  Copyright © 2017 Mitchell Ward. All rights reserved.
//

import UIKit
import Nuke

class EmployeeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func configure(employee: Employee) {
        nameLabel.text = employee.name
        
        Nuke.loadImage(with: employee.avatar, into: avatarImageView)
    }
}
