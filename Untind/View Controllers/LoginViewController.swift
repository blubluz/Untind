//
//  LoginViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 28/07/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var genderSelector: UISegmentedControl!
    
    
    let avatars = ["avatar-1", "avatar-2"]
    var selectedAvatar = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.image = UIImage(named: avatars[selectedAvatar])
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func createUserTapped(_ sender: Any) {
        if usernameTextField.text?.count == 0 {
            errorLabel.text = "No username selected"
            return
        }
        if usernameTextField.text?.contains(" ") ?? false {
            errorLabel.text = "No spaces allowed"
            return
        }
        
        let db = Firestore.firestore()
        
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            let userData =  [
                    "uuid" : uuid,
                    "avatar_type" : avatars[selectedAvatar],
                    "username" : usernameTextField.text!,
                    "settings" : [
                        "ageRange" : [
                            "minAge" : 20,
                            "maxAge" : 30
                        ],
                        "prefferedGender" : genderSelector.titleForSegment(at: genderSelector.selectedSegmentIndex)!.lowercased(),
                    ]
                ] as [String : Any]
            
            
            SVProgressHUD.show()
            db.collection("users").document(uuid).setData(
                userData, completion: {
                    (error) in
                    SVProgressHUD.dismiss()
                    if error != nil {
                        self.errorLabel.text = error?.localizedDescription
                    } else {
                        print("Succesfully created/updated user")
                        UserDefaults.standard.setValue(userData, forKey: "loggedUser")
                        let tabBarVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController")
                        
                        let parent = self.parent
                        self.dismiss(animated: false, completion: {
                            parent?.present(tabBarVc, animated: true, completion: nil)
                        })
                    }
            })
        } else {
            errorLabel.text = "No UUID available. Simulator?"
        }
        
        
    }
    @IBAction func loginWithFacebookTapped(_ sender: Any) {
        
    }
    @IBAction func loginAnonymously(_ sender: Any) {
        
    }
    
    @IBAction func nextAvatarTapped(_ sender: Any) {
        if selectedAvatar + 1 == avatars.count {
            selectedAvatar = 0
        } else {
            selectedAvatar += 1
        }
        
        profileImageView.image = UIImage(named: avatars[selectedAvatar])
    }
    @IBAction func previousAvatarTapped(_ sender: Any) {
        if selectedAvatar - 1 == -1 {
            selectedAvatar = avatars.count-1
        } else {
            selectedAvatar -= 1
        }
        
        profileImageView.image = UIImage(named: avatars[selectedAvatar])
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
