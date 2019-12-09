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
class UntindDate: NSObject {
    enum RelationshipStatus {
        case canAskQuestion
        case waitingQuestionAnswer
        case canRequestDate
        case shouldAnswerDateRequest
        case waitingDateAnswer
        case dateScheduled
        case dateFailed
        case dateStarted
        case chatStarted
        case shouldGiveDateResult
        case waitingDateResult
        case youRejected
        case heRejected
        case unknown
        
        enum InteractionState {
            case interactive
            case nonInteractive
        }
        
        var interactionState : InteractionState  {
            let interactiveStatuses : [RelationshipStatus] = [.canAskQuestion,.canRequestDate,.shouldGiveDateResult]
            
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
            case .dateStarted:
                fallthrough
            case .chatStarted:
                return "See chat"
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
            default:
                return nil
            }
        }
        
        
    }

    var invited : Profile?
    var invitee : Profile?
    var dateTime : Date?
    var isAccepted : Bool = false
    var invitedResult : DateResult = .noAnswer
    var inviteeResult : DateResult = .noAnswer
    var latestMessages : [UTMessage] = []
    
    var myRelationshipStatus : RelationshipStatus {
        guard let myId = UTUser.loggedUser?.userProfile?.uid else {
            return .unknown
        }
        
        if invited?.uid != myId && invitee?.uid != myId {
            return .canAskQuestion
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
                    if isAccepted == false {
                        if me?.uid == invited?.uid {
                            return .shouldAnswerDateRequest
                        } else {
                            return .waitingDateAnswer
                        }
                    } else {
                        if Date().timeIntervalSince(dateScheduledTime) > 0 && Date().timeIntervalSince(dateScheduledTime) < 900 {
                            return .chatStarted
                        } else if Date().timeIntervalSince(dateScheduledTime) >= 900 {
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
    
    override init() {
        super.init()
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
        
        json["isAccepted"] = isAccepted
        json["invitedResult"] = invitedResult.rawValue
        json["inviteeResult"] = inviteeResult.rawValue
        
        return json
    }
}
