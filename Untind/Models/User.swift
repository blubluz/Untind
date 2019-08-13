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
    var id : String
    var username : String
    
    init(with json: JSONDictionary) {
        avatarType = json["avatar_type"] as! String
        id = json["document_id"] as! String
        username = json["username"] as! String
    }
}
