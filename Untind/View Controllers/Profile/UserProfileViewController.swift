//
//  UserProfileViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 11/10/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func instantiate() -> UserProfileViewController {
        return UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
    }
}
