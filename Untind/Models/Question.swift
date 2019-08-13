//
//  Question.swift
//  Untind
//
//  Created by Honceriu Mihai on 13/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit
import FirebaseFirestore

class Question: NSObject {
    var author : User
    var postDate : Date
    var questionText : String
    
    init(with dictionary: JSONDictionary) {
        author = User(with: dictionary["author"] as! JSONDictionary)
        
        postDate = (dictionary["postDate"] as! Timestamp).dateValue()
        
        questionText = dictionary["questionText"] as! String
    }
}
