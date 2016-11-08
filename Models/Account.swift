//
//  User.swift
//  EFAB
//
//  Created by TEKYAdmin on 11/2/16.
//  Copyright © 2016 EFA. All rights reserved.
//
//
//  Test.swift
//  EFAB
//
//  Created by Terrence Kunstek on 10/31/16.
//  Copyright © 2016 EFA. All rights reserved.
//

import Foundation
import Alamofire
import Freddy

// Just a test object to excercise the network stack
class Account : NetworkModel {
    /*
     "username": "string",
     "password": "string",
     "email": "string"
     "token": "string",
     "expiration": "2016-11-01T20:58:52.318Z"
     */
    
    var id : String?
    var token : String?
    var expiration : String?
    var hasRegistered : Bool?
    var loginProvider : String?
    var email : String?
    var fullName : String?
    var avatarBase64 : String?
    var apiKey : String?
    var password : String?
    var lastCheckedInLongitude : Double?
    var lastCheckedInLatitude : Double?
    
    
    
    // Request Type
    enum RequestType {
        case register
        case logIn
        case logOut
        case userInfo
        case updateUserInfo
        
        
    }
   
    var requestType = RequestType.register
    
    
    // empty constructor
    required init() {}
    
    // create an object from JSON
    required init(json: JSON) throws {
        id = try? json.getString(at: Constants.Account.id)
        token = try? json.getString(at: Constants.Account.token)
        expiration = try? json.getString(at: Constants.Account.expiration)
        hasRegistered = try? json.getBool(at: Constants.Account.hasRegistered)
        loginProvider = try? json.getString(at: Constants.Account.loginProvider)
        email = try? json.getString(at: Constants.Account.email)
        avatarBase64 = try? json.getString(at: Constants.Account.avatarBase64)
        apiKey = try? json.getString(at: Constants.Account.apiKey)
        password = try? json.getString(at: Constants.Account.password)
        lastCheckedInLatitude = try? json.getDouble(at: Constants.Account.lastCheckInLatitude)
        lastCheckedInLongitude = try? json.getDouble(at: Constants.Account.lastCheckInLongitude)
        fullName = try? json.getString(at: Constants.Account.fullName)

    }
    
    init(email: String, password: String, fullName: String) {
        self.email = email
        self.password = password
        self.fullName = fullName
        self.apiKey = Constants.apiKey
        requestType = .register
    }
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
        requestType = .logIn
    }
    
    init(fullName: String, avatarBase64: String) {
        self.fullName = fullName
        self.avatarBase64 = avatarBase64
        requestType = .updateUserInfo
    }
    
   
    
    // Always return HTTP.GET
    func method() -> Alamofire.HTTPMethod {
        switch requestType {
        case .updateUserInfo:
            return .post
        // Step 17: add default
        default:
            return .get
        }
    }
    
    // A sample path to a single post
    func path() -> String {
        switch requestType {
        case .logIn:
            return "/token"
        case .register:
            return "/api/Account/Register"
        case .logOut:
            return "/api/Account/Logout"
        case .updateUserInfo, .userInfo:
            return "/api/Account/UserInfo"
        }
    }
    
    // Demo object isn't being posted to a server, so just return nil
    func toDictionary() -> [String: AnyObject]? {
        
        var params: [String: AnyObject] = [:]
        
        switch requestType {
        case .register:
            params[Constants.Account.email] = email as AnyObject?
            params[Constants.Account.password] = password as AnyObject?
            params[Constants.Account.fullName] = fullName as AnyObject?
            params[Constants.Account.apiKey] = apiKey as AnyObject?
        case .logIn:
            params[Constants.Account.email] = email as AnyObject?
            params[Constants.Account.password] = password as AnyObject?
            params[Constants.Account.grantType] = Constants.Account.password as AnyObject?
        case .updateUserInfo:
            params[Constants.Account.fullName] = fullName as AnyObject?
            params[Constants.Account.avatarBase64] = avatarBase64 as AnyObject?
        default:
            break
        }
        
        return params
    }
}
    

