//
//  WriteQuestionViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 23/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit
import Firebase

class WriteQuestionViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        let db = Firestore.firestore()
        
        
        db.collection("questions").addDocument(data: [
            "answers" : [],
            "author" : User.loggedUser!.jsonValue(),
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
    
}
