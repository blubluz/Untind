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
    var answers : [Answer]
    var documentID : String?
    
    convenience init(with document: DocumentSnapshot) {
        self.init(with: document.data()!)
        documentID = document.documentID
    }
    
    init(with dictionary: JSONDictionary) {
        
        let authorDict = dictionary["author"] as! JSONDictionary
            
        author = User(with: authorDict)
        
        postDate = (dictionary["postDate"] as! Timestamp).dateValue()
        
        questionText = dictionary["questionText"] as! String
        
        let answersArray = dictionary["answers"] as! [JSONDictionary]
        answers = []
        for item in answersArray {
            answers.append(Answer(with: item))
        }
    }
    
    func jsonValue() -> [String : Any] {
        return [ "author" : author.jsonValue(),
                 "postDate" : postDate,
                 "questionText" : questionText,
                 "answers" : answers.map({ (answer) -> JSONDictionary in
                    return answer.questionAnswerjsonValue()
                 })
        ]
    }
    
    func addAnswer(answer: Answer, completion: @escaping (Error?) -> Void) {
        self.answers.append(answer)
        let db = Firestore.firestore()
        
        if let documentId = documentID {
            let questionDocument = db.collection("questions").document(documentId)

            questionDocument.getDocument { (snapshot, error) in
                let question = Question(with: snapshot!.data()!)
                if question.answers.contains(where: { (answer) -> Bool in
                    answer.author.username == User.loggedUser?.username
                }) {
                    print("User has already answered this question")
                    completion(AddAnswerError("User has already answered"))
                } else {
                    
                    db.collection("answers").addDocument(data: answer.jsonValue())
                    questionDocument.updateData(["answers" : FieldValue.arrayUnion([answer.questionAnswerjsonValue()])]) {
                        error in
                        if let error = error {
                            print("There was an error adding this answer!")
                            completion(error)
                        } else {
                            print("Succesfuly added answer")
                            completion(nil)
                        }
                    }
                }
            }
        } else {
            print("This questions does not have a Document ID")
        }
    }
}

struct AddAnswerError : LocalizedError {
    var errorDescription: String? { return mMsg }
    var failureReason: String? { return mMsg }
    var recoverySuggestion: String? { return "" }
    var helpAnchor: String? { return "" }
    
    private var mMsg : String
    
    init(_ description: String)
    {
        mMsg = description
    }
}
