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
    private(set) var myVote : Vote = .novote
    
    
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
    
    func getVote(completion: @escaping() -> Void) {
        guard let userId = UTUser.loggedUser?.userProfile?.uid else {
            completion()
            return
        }
        let db = Firestore.firestore()
        db.collection("votes").document("\(userId)_\(self.id)").getDocument { (snapshot, error) in
            if snapshot?.data() == nil {
                self.myVote = .novote
            } else {
                self.myVote = Vote.from(json: snapshot?.data())
            }
            completion()
        }
    }
    
    func vote(newVote: Vote, completion: @escaping() -> Void) {
        var votesDifference : Int = 1
        
        if myVote == newVote {
            myVote = .novote
            if newVote == .upvote {
                votesDifference = -1
            }
        } else {
            if myVote == newVote.opposite {
                if myVote == .upvote {
                    votesDifference = -2
                } else {
                    votesDifference = 2
                }
            } else {
                if newVote == .downvote {
                    votesDifference = -1
                }
            }
            myVote = newVote
        }
        
        let upvoteFieldValue = FieldValue.increment(Int64(votesDifference))
        
        upvotes = upvotes + votesDifference
        
        let db = Firestore.firestore()
        guard let userId = UTUser.loggedUser?.userProfile?.uid else {
            completion()
            return
        }
        
        if myVote == .novote {
            db.collection("votes").document("\(userId)_\(self.id)").delete { (error) in
                
                let answerRef = db.collection("answers").document(self.id)
                answerRef.updateData(["upvotes" : upvoteFieldValue])
                
                completion()
            }
            return
        } else {
            db.collection("votes").document("\(userId)_\(self.id)").setData([
                "userId" : userId,
                "answerId" : self.id,
                "value" : myVote.rawValue,
                "questionId" : self.question?.id ?? ""]) { (error) in
                    if let error = error {
                        print("Error trying to vote: \(error.localizedDescription)")
                    }
                    
                    
                    let answerRef = db.collection("answers").document(self.id)
                    answerRef.updateData(["upvotes" : upvoteFieldValue])
                    
                    completion()
            }
        }
    }
    
    func post(completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let dispatchGroup = DispatchGroup()
        var localError : Error?
        
        dispatchGroup.enter()
        dispatchGroup.enter()
        dispatchGroup.notify(queue: .main) {
            completion(localError)
        }
        
        let docRef = db.collection("answers").addDocument(data: jsonValue()) { (error) in
            localError = error
            dispatchGroup.leave()
            if let questionId = self.question?.id {
                db.collection("questions").document("\(questionId)").updateData(["answersCount" : FieldValue.increment(Int64(1))])
            }
        }
        self.id = docRef.documentID
        
        guard let questionAuthorId = question?.author.uid else {
            dispatchGroup.leave()
            return
        }
        
        let dateDocument = db.collection("dates").document(questionAuthorId.combineUniquelyWith(string: UTUser.loggedUser!.userProfile!.uid))
        
        dateDocument.getDocument { (snapshot, error) in
            if error != nil {
                localError = error
                dispatchGroup.leave()
            } else {
                if let data = snapshot?.data() {
                    let date = UTDate(with: data)
                    if date.invitee == nil {
                        date.invitee = self.question!.author
                    } else if date.invited == nil {
                        date.invited = self.question!.author
                    }
                    
                    dateDocument.setData(date.jsonValue()) {
                        (error) in
                        localError = error
                        dispatchGroup.leave()
                    }
                } else {
                    let date = UTDate()
                    date.invited = self.question!.author
                    
                    dateDocument.setData(date.jsonValue()) {
                        (error) in
                        localError = error
                        dispatchGroup.leave()
                    }
                }
            }
        }
    }
    
    static func fetchAll(forQuestionId questionId: String?, userId: String?, completion: @escaping(Error?, [Answer]?) -> Void) {
        let db = Firestore.firestore()
        var answers = [Answer]()
        let dispatchGroup = DispatchGroup()
        var localError: Error?
        
        
        dispatchGroup.enter()
        dispatchGroup.notify(queue: .main) {
            completion(localError,answers)
        }
        
        
        var query = db.collectionGroup("answers").order(by: "postDate", descending: true)
        if let questionId = questionId {
            query = query.whereField(FieldPath(["question","id"]), isEqualTo: questionId)
        } else
            if let userId = userId {
                query = query.whereField(FieldPath(["author","uid"]), isEqualTo: userId)
            } else {
                dispatchGroup.leave()
                return
        }
        
        query.getDocuments { (snapshot, error) in
            if let err = error {
                print("Error getting answers: \(err)")
                localError = err
                dispatchGroup.leave()
            } else {
                snapshot?.documents.forEach {
                    let answer = Answer(with: $0)
                    dispatchGroup.enter()
                    answer.getVote {
                        dispatchGroup.leave()   
                    }
                    answers.append(answer)
                }
                dispatchGroup.leave()
            }
        }
    }
    
}

