//
//  Errors.swift
//  Untind
//
//  Created by Honceriu Mihai on 03/09/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import Foundation
import UIKit

//Bad. Should be improved later.


struct GenericError : LocalizedError {
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

struct InviteOnDateError : LocalizedError {
    var errorDescription: String? { return mMsg }
    var failureReason: String? { return mMsg }
    private var mMsg : String
     init(_ description: String)
       {
           mMsg = description
       }
}

enum AcceptDateError : Error {
    case missingUser
}

enum GetUserProfileError : Error {
    case userNotLoggedIn
    case userProfileNotFound
    case dataNotFound
}

extension GetUserProfileError : LocalizedError {
    var errorDescription: String? {
        switch self {
        case .dataNotFound:
            return "Data not found"
        case .userProfileNotFound:
            return "User profile not found"
        case .userNotLoggedIn:
            return "User is not logged in"
        }
    }
}

