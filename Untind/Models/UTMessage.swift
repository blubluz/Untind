//
//  Message.swift
//  Untind
//
//  Created by Honceriu Mihai on 18/11/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class UTMessage : NSObject {
    var id : String?
    var messageText : String
    var authorUid : String
    var postDate : Date
    var isWarningMessage : Bool = false
    
    convenience init(with document: DocumentSnapshot) {
        self.init(with: document.data()!)
        id = document.documentID
    }
    
    init(with json:JSONDictionary){
        authorUid = json["authorUid"] as! String
        postDate = (json["postDate"] as! Timestamp).dateValue()
        messageText = json["messageText"] as! String
    }
    
    init(message: String, authorUid: String, postDate: Date) {
        messageText = message
        self.authorUid = authorUid
        self.postDate = postDate
    }
    
    init(with author: Profile, postDate: Date, messageText: String) {
        self.id = ""
        self.authorUid = author.uid
        self.postDate = postDate
        self.messageText = messageText
    }
    
    func jsonValue() -> [String : Any] {
        let json = [
            "messageText" : messageText,
            "authorUid" : authorUid,
        "postDate" : postDate] as [String : Any]
        
        return json
    }
}
