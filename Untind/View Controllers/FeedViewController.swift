//
//  FeedViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 28/07/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
class FeedViewController: UIViewController {
    
    @IBOutlet weak var swipeableCardViewContainer: SwipeableCardViewContainer!
    var questions : [Question] = []
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        let db = Firestore.firestore()
        
        db.collection("questions").getDocuments { (querySnapshot : QuerySnapshot?, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let json = document.data()
                    self.questions.append(Question(with: json))
                    self.swipeableCardViewContainer.dataSource = self
                }
            }
        }
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func keyboardWillAppear() {
        self.swipeableCardViewContainer.transform = CGAffineTransform(translationX: 0, y: -120)
    }
    
    @objc func keyboardWillDisappear() {
        self.swipeableCardViewContainer.transform = CGAffineTransform.identity
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


//MARK: - SwipeableCardViewDataSource
extension FeedViewController: SwipeableCardViewDataSource {
    func numberOfCards() -> Int {
        return questions.count
    }
    
    func card(forItemAtIndex index: Int) -> SwipeableCardViewCard {
        let cardView = SwipeableCardViewCard()
        cardView.question = questions[index]
        return cardView
    }
    
    func viewForEmptyCards() -> UIView? {
        return nil
    }
}
