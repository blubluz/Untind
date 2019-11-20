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

class Message : NSObject {
    var id : String
    var messageText : String
    var author : Profile
    var postDate : Date
    
    convenience init(with document: DocumentSnapshot) {
          self.init(with: document.data()!)
          id = document.documentID
      }
      
      init(with json:JSONDictionary){
          id = ""
          author = Profile(with: json["author"] as! JSONDictionary)
          postDate = (json["postDate"] as! Timestamp).dateValue()
          messageText = json["messageText"] as! String
      }
      
      init(with author: Profile, postDate: Date, messageText: String) {
          self.id = ""
          self.author = author
          self.postDate = postDate
          self.messageText = messageText
      }
    
}
