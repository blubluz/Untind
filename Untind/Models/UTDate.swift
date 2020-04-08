//
//  Date.swift
//  Untind
//
//  Created by Mihai Honceriu on 06/12/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum DateResult : Double {
    case rejected = -1
    case noAnswer = 0
    case accepted = 1
}


class UTDate: NSObject {
    enum RelationshipStatus {
        case canAskQuestion
        case waitingQuestionAnswer
        case shouldAnswerQuestion
        case canRequestDate
        case shouldAnswerDateRequest
        case waitingDateAnswer
        case dateScheduled
        case dateFailed
        case dateStarted
        case chatStarted
        case shouldGiveDateResult
        case waitingDateResult
        case dateRequestExpired
        case youRejected
        case heRejected
        case unknown
        
        enum InteractionState {
            case interactive
            case nonInteractive
        }
        
        var interactionState : InteractionState  {
            let interactiveStatuses : [RelationshipStatus] = [.canAskQuestion,.canRequestDate,.shouldGiveDateResult, .waitingQuestionAnswer, .shouldAnswerQuestion,.shouldAnswerDateRequest, .chatStarted]
            
            if interactiveStatuses.contains(self) {
                return .interactive
            } else {
                return .nonInteractive
            }
        }
        
        var buttonText : String? {
            switch self {
            case .canAskQuestion:
                return "Ask a question"
            case .canRequestDate:
                return "Send a date request"
            case .shouldAnswerDateRequest:
                return "Answer date request"
            case .shouldAnswerQuestion:
                return "Answer private question"
            case .dateStarted:
                fallthrough
            case .chatStarted:
                return "Send Message"
            case .heRejected, .youRejected, .dateFailed:
                return "Date Failed"
            case .dateScheduled:
                return "Date scheduled"
            case .waitingQuestionAnswer:
                return "Waiting for answer"
            case .waitingDateResult:
                return "Waiting for date result"
            case .waitingDateAnswer:
                return "Waiting for date answer"
            case .dateRequestExpired:
                return "Date Request Expired"
            default:
                return nil
            }
        }
        
        
    }
    
    var id : String?
    var invited : Profile?
    var invitee : Profile?
    var dateTime : Date?
    var isAccepted : Bool = false
    var invitedResult : DateResult = .noAnswer
    var inviteeResult : DateResult = .noAnswer
    var latestMessages : [UTMessage] = []
    var privateQuestion : Post?
    var chatRoom : UTChatRoom?
    
    var isRejected : Bool {
               return invitedResult == .some(.rejected) || inviteeResult == .some(.rejected)
           }
    var isRejectedByMe : Bool {
        if invitee?.uid.isMyId ?? false {
            if inviteeResult == .rejected {
                return true
            }
        } else if invited?.uid.isMyId ?? false {
            if invitedResult == .rejected {
                return true
            }
        }
        return false
    }
    
    var myRelationshipStatus : RelationshipStatus {
        guard let myId = UTUser.loggedUser?.userProfile?.uid else {
            return .unknown
        }
        
        if invited?.uid != myId && invitee?.uid != myId {
            if privateQuestion != nil {
                if privateQuestion?.author.uid == UTUser.loggedUser?.userProfile?.uid {
                    return .waitingQuestionAnswer
                } else {
                    return .shouldAnswerQuestion
                }
            } else {
                return .canAskQuestion
            }
        } else {
            var me : Profile?
            var him : Profile?
            if invited?.uid == myId {
                me = invited
                him = invitee
            } else {
                me = invitee
                him = invited
            }
            if him == nil {
                return .canRequestDate
            } else {
                if let dateScheduledTime = dateTime {
                    if isRejected == true {
                        if isRejectedByMe {
                            return .youRejected
                        } else {
                            return .heRejected
                        }
                    } else
                    if isAccepted == false {
                        if dateScheduledTime < Date() {
                            return .dateRequestExpired
                        } else
                            if me?.uid == invited?.uid {
                                return .shouldAnswerDateRequest
                            } else {
                                return .waitingDateAnswer
                        }
                    } else {
                        if Date().timeIntervalSince(dateScheduledTime) >= 0 && Date().timeIntervalSince(dateScheduledTime) <= Constants.dateDuration {
                            return .dateStarted
                        } else if Date().timeIntervalSince(dateScheduledTime) >= Constants.dateDuration {
                            if me?.uid == invited?.uid {
                                if invitedResult == .noAnswer {
                                    return .shouldGiveDateResult
                                } else {
                                    if invitedResult == .rejected {
                                        return .youRejected
                                    } else if inviteeResult != .noAnswer {
                                        if inviteeResult == .rejected {
                                            return .heRejected
                                        } else {
                                            return .chatStarted
                                        }
                                    } else {
                                        return .waitingDateResult
                                    }
                                }
                            } else {
                                if inviteeResult == .noAnswer {
                                    return .shouldGiveDateResult
                                } else {
                                    if inviteeResult == .rejected {
                                        return .youRejected
                                    } else if invitedResult != .noAnswer {
                                        if invitedResult == .rejected {
                                            return .heRejected
                                        } else {
                                            return .chatStarted
                                        }
                                    } else {
                                        return .waitingDateResult
                                    }
                                }
                            }
                        } else {
                            return .dateScheduled
                        }
                    }
                } else {
                    return .canRequestDate
                }
            }
        }
    }
    
    func fetchChatRoom(force: Bool = true, completion: @escaping (Error?, UTChatRoom?) -> Void) {
        if (chatRoom != nil) && force == false {
            completion(nil, chatRoom)
            return
        }
        
        UTChatRoom.fetch(forDate: self) { (error, chatRoom) in
            self.chatRoom = chatRoom
            completion(error,chatRoom)
        }
    }
    
    static func fetch(forUserId userId: String, withChatRooms: Bool = true, completion: @escaping (Error?, [UTDate]) -> Void) {
        let db = Firestore.firestore()
        var dates : [UTDate] = []
        var localError : Error?
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        dispatchGroup.enter()
        dispatchGroup.notify(queue: .main) {
            
            guard dates.count > 0 && withChatRooms == true else {
                completion(localError, dates)
                return
            }
            

            let dispatchGroup2 = DispatchGroup()
            
            for date in dates {
                dispatchGroup2.enter()
                UTChatRoom.fetch(forDate: date) { (error, chatroom) in
                    if chatroom != nil {
                        date.chatRoom = chatroom
                        date.chatRoom?.startLoadingMessages(numberOfMessages: 10, delegate: nil, completion: { (error, success) in
                            date.chatRoom?.stopLoadingMessages()
                            dispatchGroup2.leave()
                        })
                    } else {
                        dispatchGroup2.leave()
                    }
                }
            }
            
            dispatchGroup2.notify(queue: .main) {
                completion(localError, dates)
            }
            
        }
        
        db.collectionGroup("dates").whereField(FieldPath(["invited","uid"]), isEqualTo: userId).getDocuments { (snapshot : QuerySnapshot?, error) in
            if let err = error {
                localError = err
                print("Error getting dates: \(err)")
            } else {
                if let documents = snapshot?.documents {
                    for document in documents {
                        let date = UTDate(with: document)
                        dates.append(date)
                    }
                }
            }
            dispatchGroup.leave()
        }
        
        db.collectionGroup("dates").whereField(FieldPath(["invitee","uid"]), isEqualTo: userId).getDocuments { (snapshot : QuerySnapshot?, error) in
            if let err = error {
                localError = err
                print("Error getting dates: \(err)")
            } else {
                if let documents = snapshot?.documents {
                    for document in documents {
                        let date = UTDate(with: document)
                        dates.append(date)
                    }
                }
            }
            dispatchGroup.leave()
        }
    }
    
    func accept(answer: Bool, completion: @escaping (Error?, UTDate?) -> Void) {
        guard let invited = self.invited, let invitee = self.invitee else {
            completion(AcceptDateError.missingUser, nil)
            return
        }
        self.isAccepted = true
        if answer == false {
            self.invitedResult = .rejected
        }
        
        let db = Firestore.firestore()
        db.collection("dates").document(invited.uid.combineUniquelyWith(string: invitee.uid)).setData(jsonValue()) { (error) in
            if error != nil {
                self.isAccepted = false
                self.invitedResult = .noAnswer
                completion(error,nil)
            } else {
                completion(nil,self)
            }
        }
    }
    
    func giveResult(_ result: DateResult, completion: @escaping (Error?, UTDate?) -> Void ) {
        guard let invited = self.invited, let invitee = self.invitee else {
            completion(AcceptDateError.missingUser, nil)
            return
        }
        
        let db = Firestore.firestore()
        if invited.uid.isMyId {
            invitedResult = result
            db.collection("dates").document(invited.uid.combineUniquelyWith(string: invitee.uid)).updateData(["invitedResult" : result.rawValue]) { (error) in
                if error == nil {
                    self.invitedResult = result
                }
                completion(error, self)
            }
        } else {
            db.collection("dates").document(invited.uid.combineUniquelyWith(string: invitee.uid)).updateData(["inviteeResult" : result.rawValue]) { (error) in
                if error == nil {
                    self.inviteeResult = result
                }
                completion(error, self)
            }
        }
        
        
    }
    
    override init() {
        super.init()
    }
    
    convenience init(with document: DocumentSnapshot) {
        self.init(with: document.data()!)
        id = document.documentID
    }
    
    init(with jsonDictionary: JSONDictionary) {
        if let invitedDict = jsonDictionary["invited"] as? JSONDictionary {
            invited = Profile(with: invitedDict)
        }
        
        if let inviteeDict = jsonDictionary["invitee"] as? JSONDictionary {
            invitee = Profile(with: inviteeDict)
        }
        
        if let dateTimestamp = jsonDictionary["dateTime"] as? Timestamp {
            dateTime = dateTimestamp.dateValue()
        }
        
        if let invited = invited, let invitee = invitee {
            id = invited.uid.combineUniquelyWith(string: invitee.uid)
        }
        
        isAccepted = jsonDictionary["isAccepted"] as! Bool
        invitedResult = DateResult(rawValue: jsonDictionary["invitedResult"] as! Double) ?? .noAnswer
        inviteeResult = DateResult(rawValue: jsonDictionary["inviteeResult"] as! Double) ?? .noAnswer
    }
    
    func jsonValue() -> [String:Any] {
        var json : [String: Any]  = [:]
        if let invited = self.invited {
            json["invited"] = invited.jsonValue()
        }
        
        if let invitee = self.invitee {
            json["invitee"] = invitee.jsonValue()
        }
        
        if let dateTime = self.dateTime {
            json["dateTime"] = dateTime
        }
        
        if let question = self.privateQuestion {
            json["privateQuestion"] = question.jsonValue()
        }
        
        json["isAccepted"] = isAccepted
        json["invitedResult"] = invitedResult.rawValue
        json["inviteeResult"] = inviteeResult.rawValue
        
        return json
    }
}
