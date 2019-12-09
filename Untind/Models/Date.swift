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
        case canInviteOnADate
        case waitingDateAnswer
        case dateFailed
        case chatStarted
        case waitingDateResult
        case unknown
    }

    var invited : Profile?
    var invitee : Profile?
    var dateTime : Date?
    var isAccepted : Bool = false
    var invitedResult : DateResult = .noAnswer
    var inviteeResult : DateResult = .noAnswer
    
    var myRelationshipStatus : RelationshipStatus {
        guard let myId = UTUser.loggedUser?.userProfile?.uid else {
            return .unknown
        }
        
        if let invited = invited 
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
