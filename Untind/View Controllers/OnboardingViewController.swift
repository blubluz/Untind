//
//  ViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 27/07/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var howItWorksButton: UIButton!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureLayout()
    }
    
    func configureLayout() {
        loginView.layer.cornerRadius = 40.0
        loginView.layer.shadowColor = UIColor(red: 17, green: 12, blue: 47, alpha: 0.36).cgColor
        loginView.layer.shadowRadius = 79
        loginView.layer.shadowOpacity = 1
        
        var shadowFrame: CGRect = loginView.layer.bounds
        shadowFrame.origin.y += 30
        let shadowPath: CGPath = UIBezierPath(rect: shadowFrame).cgPath
        
        
        loginView.layer.shadowPath = shadowPath
        
        //Configure "How it works" button
        howItWorksButton.layer.borderColor = UIColor.flatOrange.cgColor
        howItWorksButton.layer.borderWidth = 2
        howItWorksButton.layer.cornerRadius = 20.0
    }
}

