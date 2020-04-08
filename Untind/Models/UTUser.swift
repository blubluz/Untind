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
    
   static func deleteUserProfile(locally: Bool) {
        if locally == true {
            UserDefaults.standard.setValue(nil, forKey: "loggedUserProfile")
            UserDefaults.standard.synchronize()
        }
    }
}

struct UserSettings {
    
    var ageRange : (Int,Int) = (18,24)
    var prefferedGender : Gender = .female
    init() {
        
    }
    
    init(with json: JSON) {
        ageRange = (json["ageRange"]["minAge"   ].int!, json["ageRange"]["maxAge"].int!)
        prefferedGender = Gender(rawValue: json["prefferedGender"].string!)!
    }
    
    func jsonValue() -> [String : Any] {
        return ["ageRange" : ["minAge" : ageRange.0,
                              "maxAge" : ageRange.1],
            "prefferedGender" : prefferedGender.rawValue]
    }
}

struct Profile {
    
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
    
    func getDate(completion: @escaping (Error?, UTDate?) -> Void) {
        let db = Firestore.firestore()
        db.collection("dates").document(uid.combineUniquelyWith(string: UTUser.loggedUser!.userProfile!.uid)).getDocument { (snapshot, error) in
            if let error = error {
                completion(error, nil)
            } else {
                var date : UTDate = UTDate()
                if let data = snapshot?.data() {
                    date = UTDate(with: data)
                }

                if date.myRelationshipStatus == .canAskQuestion {
                    Post.fetch(fromUserId: UTUser.loggedUser?.userProfile?.uid ?? "", toUserId: self.uid) { (error, question) in
                        if question != nil {
                            date.privateQuestion = question
                            completion(error, date)
                        } else {
                            completion(error,UTDate())
                        }
                    }
                } else {
                    completion(error,date)
                }
                
            }
        }
    }
    
    func inviteOnDate(date: Date, completion: @escaping(Error?,Bool, UTDate?) -> Void) {
        guard date > Date().addingTimeInterval(599) else {
            completion(InviteOnDateError("Please select a date that is further away in time."), false, nil)
            return
        }
        
        let db = Firestore.firestore()
        let dateDocument = db.collection("dates").document(self.uid.combineUniquelyWith(string: UTUser.loggedUser!.userProfile!.uid))
        
        dateDocument.getDocument { (snapshot, error) in
            if error != nil {
                completion(error,false,nil)
            } else {
                if let snapshot = snapshot, snapshot.data() != nil {
                    let utDate = UTDate(with: snapshot)
                    utDate.invited = self
                    utDate.invitee = UTUser.loggedUser?.userProfile
                    utDate.dateTime = date
                    utDate.privateQuestion = nil
                    dateDocument.setData(utDate.jsonValue()) {
                        (error) in
                        if error != nil {
                            completion(error, false,nil)
                        } else {
                            completion(nil,true,utDate)
                        }
                    }
                } else {
                    let utDate = UTDate()
                    utDate.invited = self
                    utDate.invitee = UTUser.loggedUser?.userProfile
                    utDate.dateTime = date
                    
                    dateDocument.setData(utDate.jsonValue()) {
                        (error) in
                        if error != nil {
                            completion(error, false,nil)
                        } else {
                            completion(nil,true,utDate)
                        }
                    }
                }
            }
        }
    }
}

enum Gender : String, Codable{
    case male
    case female
    case both
    
    var shortGender : String {
        switch self {
        case .male:
            return "M"
        case .female:
            return "F"
        case .both:
            return "M/F"
        }
    }
}
