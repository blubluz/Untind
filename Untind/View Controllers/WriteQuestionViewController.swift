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
        let db = Firestore.firestore()
        
        
        db.collection("questions").addDocument(data: [
            "answers" : [],
            "author" : UTUser.loggedUser!.userProfile?.jsonValue(),
            "postDate" : Date(),
            "questionText" : textView.text ?? "No qusetion text"], completion: { error in
                if error != nil {
                    self.textView.text = "There was an error \(error!.localizedDescription)"
                } else {
                    self.textView.text = "Question succesfuly posted!"
                }
        })
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        textView.resignFirstResponder()
    }
    
}
