//
//  User.swift
//  Untind
//
//  Created by Honceriu Mihai on 13/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit
import SwiftyJSON
import FirebaseAuth
import FirebaseFirestore

class UTUser: NSObject {
    let user : User
    var userProfile : Profile?
    
    init(user: User, profile: Profile?) {
        self.user = user
        self.userProfile = profile
    }
    
    static var loggedUser : UTUser? = {
        var profile : Profile?
            if let userProfileDict = UserDefaults.standard.value(forKey: "loggedUserProfile") as? JSONDictionary {
                profile = Profile(with: userProfileDict)
        }
        guard let currentUser = Auth.auth().currentUser else {
            return nil
        }
        
        return UTUser(user: currentUser, profile: profile)
    }()
    
    func getUserProfile(completion: @escaping (Bool, GetUserProfileError?) -> Void  = { _, _ in }) {
        guard let user = Auth.auth().currentUser else {
            completion(false, GetUserProfileError.userNotLoggedIn)
            return
        }
        
        let db = Firestore.firestore()
        let userProfileDocRef = db.collection("UserProfiles").document(user.uid)
        userProfileDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let dataDescription = document.data() {
                    let userProfile = Profile(with: dataDescription)
                    self.userProfile = userProfile
                    completion(true, nil)
                } else {
                    completion(false, .dataNotFound)
                }
                
            } else {
                completion(false, GetUserProfileError.userNotFound)
            }
        }
    }
    
    func saveUserProfile(locally: Bool){
        if locally == true {
            UserDefaults.standard.setValue(userProfile?.jsonValue(), forKey: "loggedUserProfile")
        } else {
            //Save user in Firestore
        }
    }
}

struct UserSettings {
    var ageRange : (Int,Int) = (18,24)
    var prefferedGender : Gender = .female
    init() {
        
    }
    
    init(with json: JSON) {
        ageRange = (json["ageRange"]["minAge"].int!, json["ageRange"]["maxAge"].int!)
        prefferedGender = Gender(rawValue: json["prefferedGender"].string!)!
    }
    
    func jsonValue() -> [String : Any] {
        return ["ageRange" : ["minAge" : ageRange.0,
                              "maxAge" : ageRange.1],
            "prefferedGender" : prefferedGender.rawValue]
    }
}

struct Profile {
    var avatarType : String = "avatar-1"
    var uuid : String = "NoUUID"
    var username : String = "NoUsername"
    var gender : Gender = .female
    var age : Int = 18
    var settings : UserSettings = UserSettings()
    
    init() {
        
    }
    
    init(with jsonDictionary: JSONDictionary, uuid: String? = nil) {
        avatarType = jsonDictionary["avatar_type"] as! String
        username = jsonDictionary["username"] as! String
        self.uuid = jsonDictionary["uuid"] as! String
        age = jsonDictionary["age"] as! Int
        gender = Gender(rawValue: jsonDictionary["gender"] as! String)!
        let settingsDict = jsonDictionary["settings"] as! JSONDictionary
        settings = UserSettings(with: JSON(settingsDict))
        
    }
    
    func jsonValue() -> JSONDictionary {
        return [ "avatar_type" : avatarType,
                 "username" : username,
                 "uuid" : uuid,
                 "age" : age,
                 "gender" : gender.rawValue,
                 "settings" : settings.jsonValue()
        ]
    }
}

enum Gender : String, Codable{
    case male
    case female
}
