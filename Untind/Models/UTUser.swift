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
    
    private static var _loggedUser: UTUser?
    
    static var loggedUser : UTUser?  {
        if _loggedUser != nil && Auth.auth().currentUser != nil {
            return _loggedUser
        } else {
            var profile : Profile?
            if let userProfileDict = UserDefaults.standard.value(forKey: "loggedUserProfile") as? JSONDictionary {
                profile = Profile(with: userProfileDict)
            }
            guard let currentUser = Auth.auth().currentUser else {
                _loggedUser = nil
                return nil
            }
            
            _loggedUser = UTUser(user: currentUser, profile: profile)
            return _loggedUser
        }
    }
    
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
                completion(false, GetUserProfileError.userProfileNotFound)
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
    enum RelationshipStatus {
        case canAskQuestion
        case waitingQuestionAnswer
        case canInviteOnADate
        case waitingDateAnswer
        case dateFailed
        case chatStarted
        case waitingDateResult
    }
    
    static let defaultUsername = "NoUsername"
    static let defaultAvatar = "avatar-1"
    static let defaultUuid = "NoUUID"
    static let defaultUid = "NoUID"
    static let defaultGender = Gender.female
    static let defaultAge = 17
    
    var avatarType : String = Profile.defaultAvatar
    var uuid : String = Profile.defaultUuid
    var uid : String = Profile.defaultUid
    var username : String = Profile.defaultUsername
    var gender : Gender = Profile.defaultGender
    var age : Int = Profile.defaultAge
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
        uid = jsonDictionary["uid"] as! String
    }
    
    func jsonValue() -> JSONDictionary {
        return [ "avatar_type" : avatarType,
                 "username" : username,
                 "uuid" : uuid,
                 "age" : age,
                 "gender" : gender.rawValue,
                 "settings" : settings.jsonValue(),
                 "uid" : uid
        ]
    }
    
//    func getRelationshipStatus(completion: @escaping (Error?) -> Void) -> RelationshipStatus {
//        let db = Firestore.firestore()
//        
//    }
}

enum Gender : String, Codable{
    case male
    case female
}
