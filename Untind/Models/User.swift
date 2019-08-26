//
//  User.swift
//  Untind
//
//  Created by Honceriu Mihai on 13/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit
import SwiftyJSON

class User: NSObject {
    var avatarType : String
    var uuid : String
    var username : String
    var settings : UserSettings
    
    init(with jsonDictionary: JSONDictionary, uuid: String? = nil) {
        avatarType = jsonDictionary["avatar_type"] as! String
        username = jsonDictionary["username"] as! String
        self.uuid = jsonDictionary["uuid"] as! String
        
        let settingsDict = jsonDictionary["settings"] as! JSONDictionary
        settings = UserSettings(with: JSON(settingsDict))
       
    }
    
    func jsonValue() -> [String : Any] {
        return [ "avatar_type" : avatarType,
                 "username" : username,
                 "uuid" : uuid,
                 "settings" : settings.jsonValue()
         ]
    }
    
    static var loggedUser : User? {
        if let loggedInUserDict = UserDefaults.standard.dictionary(forKey: "loggedUser") {
            return User(with: loggedInUserDict)
        } else {
            return nil
        }
    }
}

struct UserSettings {
    var ageRange : (Int,Int)
    var prefferedGender : Gender
    
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

enum Gender : String, Codable{
    case male
    case female
}
