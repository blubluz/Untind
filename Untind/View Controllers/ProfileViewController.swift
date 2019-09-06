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
        //Go to tab bar controller
        let onboardingNav = UIStoryboard.main.instantiateViewController(withIdentifier: "OnobardingNavigationController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = onboardingNav
    }
    
    

}
