//
//  WriteQuestionViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 23/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit
import Firebase
import IHKeyboardAvoiding

class WriteQuestionViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        KeyboardAvoiding.avoidingView = self.textView
        
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
    
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        textView.resignFirstResponder()
    }
    
}
