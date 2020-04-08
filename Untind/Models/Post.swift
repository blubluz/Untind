//
//  Question.swift
//  Untind
//
//  Created by Honceriu Mihai on 13/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit
import FirebaseFirestore

class Post: NSObject {
    var id : String?
    var author : Profile
    var postDate : Date
    
    /**
        Post expiration date
    */
    var postExpirationDate : Date
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
        postExpirationDate = (dictionary["postExpirationDate"] as! Timestamp).dateValue()
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
        self.postExpirationDate = postDate.addingTimeInterval(86400)
    }
    
    func jsonValue() -> [String : Any] {
        var json = [ "author" : author.jsonValue(),
                 "postDate" : postDate,
                 "questionText" : questionText,
                 "answersCount" : answersCount,
                 "postExpirationDate" : postExpirationDate
             ] as [String : Any]
        
        if let respondent = self.respondent {
            json["respondent"] = respondent.jsonValue()
        }
        
        if let id = self.id {
            json["id"] = id
        }
        
        return json
     
    }
    
   //MARK: - Networking
    
    //MARK:  Posting
    func post(toProfile: Profile? = nil, completion: @escaping (Error?) -> Void) {
        self.respondent = toProfile
        let db = Firestore.firestore()
        db.collection("questions").addDocument(data: jsonValue()) { (error) in
            if error == nil && self.respondent != nil {
                let dateDocument = db.collection("dates").document(self.respondent!.uid.combineUniquelyWith(string: UTUser.loggedUser!.userProfile!.uid))
                      
                      dateDocument.getDocument { (snapshot, error) in
                          if error != nil {
                          } else {
                              if let data = snapshot?.data() {
                                  let date = UTDate(with: data)
                                  date.privateQuestion = self
                                  if date.invitee == nil {
                                      date.invitee = UTUser.loggedUser?.userProfile
                                  } else if date.invited == nil {
                                      date.invited = UTUser.loggedUser?.userProfile
                                  }
                                  
                                  dateDocument.setData(date.jsonValue()) {
                                      (error) in
                                  }
                              } else {
                                  let date = UTDate()
                                  date.privateQuestion = self
                                  date.invited = UTUser.loggedUser!.userProfile!
                                  
                                  dateDocument.setData(date.jsonValue()) {
                                      (error) in
                                  }
                              }
                          }
                      }
            }
            completion(error)
        }
    }
    
    //MARK: - Fetching
    static func fetchPublicPosts(limit: Int, lastSnapshot: DocumentSnapshot?, completion: @escaping (Error?, [Post], DocumentSnapshot?) -> Void) {
        let db = Firestore.firestore()
        var query = db.collection("questions").whereField("postExpirationDate", isGreaterThan: Date()).limit(to: limit)
        if let lastSnapshot = lastSnapshot {
            query = query.start(afterDocument: lastSnapshot)
        }
        var posts = [Post]()
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                 print("Error getting documents: \(error)")
                completion(error, [], nil)
            } else {
                guard let newLastSnapshot = snapshot!.documents.last else {
                    completion(nil,[],nil)
                    return
                }
                
                for document in snapshot!.documents {
                    
                    
                    let post = Post(with: document)
                    guard !post.author.uid.isMyId else {
                        continue
                    }
                    posts.append(post)
                }
                
                completion(nil,posts,newLastSnapshot)
            }
        }
    }
    
    static func fetch(fromUserId fromId: String, toUserId toId: String, completion: @escaping (Error?, Post?) -> Void) {
           let db = Firestore.firestore()
             var question: Post?
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
                      question = Post(with: document)
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
                    question = Post(with: document)
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
    
    static func fetch(with id: String, withAnswers: Bool = true, completion: @escaping (Error?, Post?) -> Void) {
        let db = Firestore.firestore()
        var question: Post?
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
                question = Post(with: snapshot!)
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
    
    static func fetchAll(forUserId userId: String, withAnswers: Bool = true, completion: @escaping (Error?, [Post]) -> Void) {
        let db = Firestore.firestore()
        var questions = [Post]()
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
                    
                    let question = Post(with: document)
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
}


