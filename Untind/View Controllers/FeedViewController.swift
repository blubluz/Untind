//
//  FeedViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 28/07/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    @IBOutlet weak var topViewBar: UIView!
    @IBOutlet weak var bottomViewBar: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topViewBar.roundCorners(cornerRadius: 40, corners: [.bottomLeft,.bottomRight])
        bottomViewBar.roundCorners(cornerRadius: 40, corners: [.topLeft,.topRight])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.layer.cornerRadius = 20
        bottomView.layer.cornerRadius = 20
        
        // set the shadow properties
        topView.layer.shadowColor = UIColor.black.cgColor
        topView.layer.shadowOffset = CGSize(width: 8, height: 15)
        topView.layer.shadowOpacity = 0.33
        topView.layer.shadowRadius = 14
        
        // set the shadow properties
        bottomView.layer.shadowColor = UIColor.black.cgColor
        bottomView.layer.shadowOffset = CGSize(width: 6, height: 6)
        bottomView.layer.shadowOpacity = 0.2
        bottomView.layer.shadowRadius = 4.0
        
    }
    

}
