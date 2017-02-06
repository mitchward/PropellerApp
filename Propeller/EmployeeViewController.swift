//
//  EmployeeViewController.swift
//  Propeller
//
//  Created by Mitchell Ward on 09/01/2017.
//  Copyright © 2017 Mitchell Ward. All rights reserved.
//

import UIKit
import Nuke

class EmployeeViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var employee: Employee?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = employee?.name
        Nuke.loadImage(with: (employee?.avatar)!, into: avatarImageView)
    }
}
