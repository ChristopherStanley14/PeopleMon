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
class User : NetworkModel {
    /*
     "username": "string",
     "password": "string",
     "email": "string"
     "token": "string",
     "expiration": "2016-11-01T20:58:52.318Z"
     */
    
    var userId : String?
    var userName : String?
    var avatarBase64 : String?
    var longitude : Double?
    var latitude : Double?
    var radiusInMeters : Int?
    var caughtUserId : String?
    
    
    // Request Type
    enum RequestType {
        case nearby
        case checkIn
        case Catch
        case caught
        
        
    }
    var requestType = RequestType.nearby
    
    
    // empty constructor
    required init() {}
    
    // create an object from JSON
    required init(json: JSON) throws {
        userId = try? json.getString(at: Constants.User.userId)
        userName = try? json.getString(at: Constants.User.userName)
        avatarBase64 = try? json.getString(at: Constants.User.avatarBase64)
        longitude = try? json.getDouble(at: Constants.User.longitude)
        latitude = try? json.getDouble(at: Constants.User.latitude)
        radiusInMeters = try? json.getInt(at: Constants.User.radiusInMeters)
     
    }
    
    init(userId: String, userName: String, longitude: Double, latitude: Double) {
        self.userId = userId
        self.userName = userName
        self.longitude = longitude
        self.latitude = latitude
        requestType = .nearby
    }
    
    init(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
        requestType = .checkIn
    }
    
    init(caughtUserId: String, radiusInMeters: Int) {
        self.caughtUserId = caughtUserId
        self.radiusInMeters = radiusInMeters
        requestType = .Catch
    }
    
    init(userId: String, userName: String) {
        self.userId = userId
        self.userName = userName
        requestType = .caught
    }
    
    
    
    
    // Always return HTTP.GET
    func method() -> Alamofire.HTTPMethod {
        switch requestType {
        case .checkIn:
            return .post
        case .Catch:
            return .post
        // Step 17: add default
        default:
            return .get
        }
    }
    
    // A sample path to a single post
    func path() -> String {
        switch requestType {
        case .nearby:
            return "/v1/User/Nearby"
        case .checkIn:
            return "/v1/User/CheckIn"
        case .Catch:
            return "/v1/User/Catch"
        case .caught:
            return "/v1/User/Caught"
        }
    }
    
    // Demo object isn't being posted to a server, so just return nil
    func toDictionary() -> [String: AnyObject]? {
        
        var params: [String: AnyObject] = [:]
        
        switch requestType {
        case .checkIn:
            params[Constants.User.longitude] = longitude as AnyObject?
            params[Constants.User.latitude] = latitude as AnyObject?
        case .Catch:
            params[Constants.User.caughtUserId] = caughtUserId as AnyObject?
            params[Constants.User.radiusInMeters] = radiusInMeters as AnyObject?
        default:
            break
        }
        
        return params
    }
    
}
