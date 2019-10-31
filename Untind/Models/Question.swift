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
    var id : String?
    var author : Profile
    var postDate : Date
    var questionText : String
    var answers : [Answer]?
    
    convenience init(with document: DocumentSnapshot) {
        self.init(with: document.data()!)
        id = document.documentID
    }
    
    init(with dictionary: JSONDictionary) {
        
        let authorDict = dictionary["author"] as! JSONDictionary
            
        author = Profile(with: authorDict)
        
        postDate = (dictionary["postDate"] as! Timestamp).dateValue()
        
        questionText = dictionary["questionText"] as! String
        
        id = dictionary["id"] as? String
        
    }
    
    init(author: Profile, postDate: Date, questionText: String) {
        self.author = author
        self.postDate = postDate
        self.questionText = questionText
    }
    
    func jsonValue() -> [String : Any] {
        var json = [ "author" : author.jsonValue(),
                 "postDate" : postDate,
                 "questionText" : questionText
            ] as [String : Any]
        
        if let id = self.id {
            json["id"] = id
        }
        
        return json
     
    }
    
    func fetchAnswers(completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        if self.answers == nil {
            self.answers = [Answer]()
        }
        if let id = id {
            db.collection("answers").whereField(FieldPath(["question","id"]), isEqualTo: id).getDocuments { (snapshot: QuerySnapshot?, error) in
                if let err = error {
                    print("Error getting answers: \(err)")
                    completion(error)
                } else {
                    snapshot!.documents.forEach {
                        let answer = Answer(with: $0)
                        if !(self.answers?.contains(where: { (localAnswer) -> Bool in
                            localAnswer.id == answer.id
                        }) ?? false) {
                            self.answers?.append(Answer(with: $0))
                        }
                    }
                    completion(nil)
                }
            }
        } else {
            completion(nil) //Should be error
            print("Oops. We have no documentId")
        }
    }
    
    func post(completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("questions").addDocument(data: jsonValue()) { (error) in
            completion(error)
        }
    }
    
    static func fetch(id: String, withAnswers: Bool = true, completion: @escaping (Error?, Question?) -> Void) {
        let db = Firestore.firestore()
        var question: Question?
        var localError: Error?
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.notify(queue: .main) {
            completion(localError,question)
        }
        
        dispatchGroup.enter()
        db.collection("questions").document(id).getDocument { (snapshot, error) in
            if let err = error {
                localError = err
                print("Oops. Error fetching question.")
                dispatchGroup.leave()
            } else {
                question = Question(with: snapshot!)
                if withAnswers {
                    dispatchGroup.enter()
                    question?.fetchAnswers(completion: { (error) in
                        if error != nil {
                            localError = error
                        }
                        dispatchGroup.leave()
                    })
                }
                dispatchGroup.leave()
            }
        }
    }
    
    static func fetchAll(forUserId userId: String, withAnswers: Bool = true, completion: @escaping (Error?, [Question]) -> Void) {
        let db = Firestore.firestore()
        var questions = [Question]()
        var localError : Error?
        let dispatchGroup = DispatchGroup()
        
        
        
        dispatchGroup.enter()
        dispatchGroup.notify(queue: .main) {
            completion(localError, questions)
        }
        
        db.collectionGroup("questions").whereField(FieldPath(["author", "uid"]), isEqualTo: userId).getDocuments { (snapshot : QuerySnapshot?, error) in
            if let err = error {
                localError = err
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    
                    let question = Question(with: document)
                    questions.append(question)
                    if withAnswers {
                        dispatchGroup.enter()
                        question.fetchAnswers { (error) in
                            if error != nil {
                                localError = error
                            }
                            dispatchGroup.leave()
                        }
                    }
                }
            }
            dispatchGroup.leave()
        }
        
        
    }
}


