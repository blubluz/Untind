//
//  Answer.swift
//  Untind
//
//  Created by Honceriu Mihai on 13/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit
import FirebaseFirestore

class Answer: NSObject {
    var author : User
    var postDate : Date
    var answerText : String
    var upvotes : Int
    var rating : CGFloat
    var question : Question?
    
    init(with json:JSONDictionary){
        author = User(with: json["author"] as! JSONDictionary)
        postDate = (json["postDate"] as! Timestamp).dateValue()
        answerText = json["answerText"] as! String
        upvotes = json["upvotes"] as! Int
        rating = json["rating"] as! CGFloat
        
        if let questionJson = json["question"] as? JSONDictionary {
            question = Question(with: questionJson)
        }
    }
    
    init(with author: User, postDate: Date, answerText: String, upvotes: Int, rating: CGFloat, question: Question) {
        self.author = author
        self.postDate = postDate
        self.answerText = answerText
        self.upvotes = upvotes
        self.rating = rating
        self.question = question
    }
    
    func jsonValue() -> [String : Any] {
        var json : [String : Any] = [
            "author" : author.jsonValue(),
            "postDate" : postDate,
            "answerText" : answerText,
            "upvotes" : upvotes,
            "rating" : rating
        ]
        
        if let question = question {
            json["question"] = question.jsonValue()
        }
        
        return json
    }
    
    func questionAnswerjsonValue() -> [String : Any] {
        return [
            "author" : author.jsonValue(),
            "postDate" : postDate,
            "answerText" : answerText,
            "upvotes" : upvotes,
            "rating" : rating
        ]
    }
}

