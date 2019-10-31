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
    var id : String
    var author : Profile
    var postDate : Date
    var answerText : String
    var upvotes : Int
    var rating : CGFloat
    var question : Question?
    var myVote : Vote = .none
    
    
    convenience init(with document: DocumentSnapshot) {
        self.init(with: document.data()!)
        id = document.documentID
    }
    
    init(with json:JSONDictionary){
        id = ""
        author = Profile(with: json["author"] as! JSONDictionary)
        postDate = (json["postDate"] as! Timestamp).dateValue()
        answerText = json["answerText"] as! String
        upvotes = json["upvotes"] as! Int
        rating = json["rating"] as! CGFloat
        
        if let questionJson = json["question"] as? JSONDictionary {
            question = Question(with: questionJson)
        }
    }
    
    init(with author: Profile, postDate: Date, answerText: String, upvotes: Int, rating: CGFloat, question: Question) {
        self.id = ""
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
    
    func getVote() {
        guard let userId = UTUser.loggedUser?.userProfile?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        db.collection("votes").document("\(userId)_\(self.id)").getDocument { (snapshot, error) in
            
        }
    }
    
    func post(completion: @escaping (Error?) -> Void) {
          let db = Firestore.firestore()
          db.collection("answers").addDocument(data: jsonValue()) { (error) in
              completion(error)
          }
      }
    
    static func fetchAll(forUserId userId: String, completion: @escaping (Error?, [Answer]?) -> Void) {
        let db = Firestore.firestore()
        var answers = [Answer]()
        
        db.collectionGroup("answers").whereField(FieldPath(["author","uid"]), isEqualTo: userId).getDocuments { (snapshot, error) in
            if let err = error {
                print("Error getting answers: \(err)")
                completion(error,nil)
            } else {
                snapshot?.documents.forEach {
                    answers.append(Answer(with: $0))
                }
                completion(nil,answers)
            }
        }
    }
    
}

