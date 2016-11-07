//
//  UserStore.swift
//  EFAB
//
//  Created by Christopher Stanley on 11/2/16.
//  Copyright © 2016 Christopher Stanley. All rights reserved.
//

import Foundation

class UserStore {
    // singleton
    static let shared = UserStore()
    private init() {}
    
    func login(_ loginUser: User, completion:@escaping
        (_ success:Bool, _ error: String?) -> Void) {
        
        // Call web service to login
        WebServices.shared.authUser(loginUser) { (user, error) in
            if let user = user {
                WebServices.shared.setAuthToken(user.token, expiration: user.expiration)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    func register(_ registerUser: User, completion:@escaping
        (_ success:Bool, _ error: String?) -> Void) {
        
        // Call web service to login
        WebServices.shared.authUser(registerUser) { (user, error) in
            if let user = user {
                WebServices.shared.setAuthToken(user.token, expiration: user.expiration)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    func logout(_ completion:() -> ()) {
        WebServices.shared.clearUserAuthToken()
        completion()
    }
    
   
}
