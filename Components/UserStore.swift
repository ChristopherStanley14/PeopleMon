//
//  UserStore.swift
//  EFAB
//
//  Created by Christopher Stanley on 11/2/16.
//  Copyright © 2016 Christopher Stanley. All rights reserved.
//
import Foundation

protocol UserStoreDelegate: class {
    func userLoggedIn()
}

class UserStore {
    // singleton
    static let shared = UserStore()
    private init() {}
    
    var user: Account? {
        didSet {
            if let _ = user {
                delegate?.userLoggedIn()
            }
        }
    }
    weak var delegate: UserStoreDelegate?
    
    func login(_ loginUser: Account, completion:@escaping (_ success: Bool, _ error: String?) -> Void) {
        WebServices.shared.authUser(loginUser) { (user, error) -> () in
            if let user = user {
                WebServices.shared.setAuthToken(user.token, expiration: user.expiration)
                self.getUserInfo(infoUser: loginUser, completion: completion)
            } else {
                completion(false, error)
            }
        }
    }
    
    func register(_ registerUser: Account, completion:@escaping (_ success: Bool, _ error: String?) -> Void) {
        WebServices.shared.registerUser(registerUser) { (user, error) -> () in
            if let _ = user {
                registerUser.requestType = Account.RequestType.logIn
                self.login(registerUser, completion: { (success, error) in
                    completion(success, error)
                })
            } else {
                completion(false, error)
            }
        }
    }
    
    
    func getUserInfo(infoUser: Account, completion:@escaping (_ success: Bool, _ error: String?) -> Void) {
        infoUser.requestType = Account.RequestType.userInfo
        WebServices.shared.getObject(infoUser) { (user, error) in
            if let user = user {
                self.user = user
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
