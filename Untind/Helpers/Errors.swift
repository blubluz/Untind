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

enum GetUserProfileError : Error {
    case userNotLoggedIn
    case userProfileNotFound
    case dataNotFound
}


