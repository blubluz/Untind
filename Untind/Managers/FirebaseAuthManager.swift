//
//  FirebaseAuthManager.swift
//  Untind
//
//  Created by Honceriu Mihai on 03/09/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class FirebaseAuthManager {
    static func login(credential: AuthCredential, completionBlock: @escaping (_ error: Error?) -> Void) {
        Auth.auth().signIn(with: credential, completion: { (firebaseUser, error) in
            print(firebaseUser)
            completionBlock(error)
        })
    }
}
