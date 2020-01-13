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
    var answersCount : Int = 0
    var answers : [Answer]?
    var respondent : Profile?
    
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
        
        if let respondentDict = dictionary["respondent"] as? JSONDictionary {
            respondent = Profile(with: respondentDict)
        }
        if let answersCount = dictionary["answersCount"] as? Int {
               self.answersCount = answersCount
        }
    }
    
    init(author: Profile, postDate: Date, questionText: String) {
        self.author = author
        self.postDate = postDate
        self.questionText = questionText
    }
    
    func jsonValue() -> [String : Any] {
        var json = [ "author" : author.jsonValue(),
                 "postDate" : postDate,
                 "questionText" : questionText,
                 "answersCount" : answersCount
             ] as [String : Any]
        
        if let respondent = self.respondent {
            json["respondent"] = respondent.jsonValue()
        }
        
        if let id = self.id {
            json["id"] = id
        }
        
        return json
     
    }
    
    func fetchAnswers(completion: @escaping (Error?) -> Void) {
        if self.answers == nil {
            self.answers = [Answer]()
        }
        if let id = id {
            Answer.fetchAll(forQuestionId: id, userId: nil) { (error, answers) in
                if let error = error {
                    print("Error getting answers: \(error)")
                    completion(error)
                } else if let localAnswers = answers {
                    self.answers = localAnswers
                    completion(nil)
                }
            }
        } else {
            completion(nil) //Should be error
            print("Oops. We have no documentId")
        }
    }
    
    func post(toProfile: Profile? = nil, completion: @escaping (Error?) -> Void) {
        self.respondent = toProfile
        let db = Firestore.firestore()
        db.collection("questions").addDocument(data: jsonValue()) { (error) in
//            if error == nil && self.respondent != nil {
//                let dateDocument = db.collection("dates").document(self.author.uid.combineUniquelyWith(string: UTUser.loggedUser!.userProfile!.uid))
//                      
//                      dateDocument.getDocument { (snapshot, error) in
//                          if error != nil {
//                          } else {
//                              if let data = snapshot?.data() {
//                                  let date = UntindDate(with: data)
//                                  date.privateQuestion = self
//                                  if date.invitee == nil {
//                                      date.invitee = UTUser.loggedUser?.userProfile
//                                  } else if date.invited == nil {
//                                      date.invited = UTUser.loggedUser?.userProfile
//                                  }
//                                  
//                                  dateDocument.setData(date.jsonValue()) {
//                                      (error) in
//                                  }
//                              } else {
//                                  let date = UntindDate()
//                                  date.privateQuestion = self
//                                  date.invited = UTUser.loggedUser!.userProfile!
//                                  
//                                  dateDocument.setData(date.jsonValue()) {
//                                      (error) in
//                                  }
//                              }
//                          }
//                      }
//            }
            completion(error)
        }
    }
    
    static func fetch(fromUserId fromId: String, toUserId toId: String, completion: @escaping (Error?, Question?) -> Void) {
           let db = Firestore.firestore()
             var question: Question?
             var localError: Error?
             let dispatchGroup = DispatchGroup()
             
             dispatchGroup.enter()
             dispatchGroup.enter()
             dispatchGroup.notify(queue: .main) {
                 completion(localError,question)
             }
        
        db.collectionGroup("questions").whereField(FieldPath(["author", "uid"]), isEqualTo: toId).whereField(FieldPath(["respondent", "uid"]), isEqualTo: fromId).getDocuments { (snapshot : QuerySnapshot?, error) in
              if let err = error {
                  localError = err
                  print("Error getting question: \(err)")
              } else {
                  if let document = snapshot?.documents.last {
                      question = Question(with: document)
                      dispatchGroup.enter()
                      question?.fetchAnswers { (error) in
                          if error != nil {
                              localError = error
                          }
                          dispatchGroup.leave()
                      }
                  }
              }
              dispatchGroup.leave()
          }
        
        db.collectionGroup("questions").whereField(FieldPath(["respondent", "uid"]), isEqualTo: toId).whereField(FieldPath(["author", "uid"]), isEqualTo: fromId).getDocuments { (snapshot : QuerySnapshot?, error) in
            if let err = error {
                localError = err
                print("Error getting questions: \(err)")
            } else {
                if let document = snapshot?.documents.last {
                    question = Question(with: document)
                    dispatchGroup.enter()
                    question?.fetchAnswers { (error) in
                        if error != nil {
                            localError = error
                        }
                        dispatchGroup.leave()
                    }
                }
            }
            dispatchGroup.leave()
        }
    }
    
    static func fetch(id: String, withAnswers: Bool = true, completion: @escaping (Error?, Question?) -> Void) {
        let db = Firestore.firestore()
        var question: Question?
        var localError: Error?
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        dispatchGroup.notify(queue: .main) {
            completion(localError,question)
        }
        
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


