//
//  ProfileViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 21/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        UserDefaults.standard.set(nil, forKey: "loggedUser")
        self.parent?.dismiss(animated: true, completion: nil)
    }
    
    

}
