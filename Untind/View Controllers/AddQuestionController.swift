//
//  AddQuestionController.swift
//  Untind
//
//  Created by Honceriu Mihai on 23/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class AddQuestionController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backgroundView.roundCorners(cornerRadius: 30, corners: [.topLeft,.topRight])
    }
    
    @IBAction func writeQuestionsTapped(_ sender: Any) {
        self.navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WriteQuestionViewController"), animated: true)
        
    }
}
