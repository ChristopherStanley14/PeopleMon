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
import MapKit

// Just a test object to excercise the network stack
class User : NetworkModel {
    
    
    var userId : String?
    var userName : String?
    var avatarBase64 : String?
    var longitude : Double?
    var latitude : Double?
    var radiusInMeters : Int?
    var caughtUserId : String?
    var created : String?
    var distance : Double?
    
    
    // Request Type
    enum RequestType {
        case nearby
        case checkIn
        case Catch
        case caught
        
        
    }
    var requestType = RequestType.nearby
    
    
    // empty constructor
    required init() {
    requestType = .caught
    }
    
    // create an object from JSON
    required init(json: JSON) throws {
        self.userId = try? json.getString(at: Constants.User.userId)
        self.userName = try? json.getString(at: Constants.User.userName)
        self.avatarBase64 = try? json.getString(at: Constants.User.avatarBase64)
        self.longitude = try? json.getDouble(at: Constants.User.longitude)
        self.latitude = try? json.getDouble(at: Constants.User.latitude)
        self.created = try? json.getString(at: Constants.User.created)
     
    }
    
    init(radiusInMeters: Int) {
        self.radiusInMeters = radiusInMeters
        self.requestType = .nearby
    }
    
    init(coordinate: CLLocationCoordinate2D) {
        self.requestType = .checkIn
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
    
    init(caughtUserId: String, radiusInMeters: Int) {
        self.caughtUserId = caughtUserId
        self.radiusInMeters = radiusInMeters
        self.requestType = .Catch
    }
    
    init(userID: String, radiusInMeters: Int) {
        self.userId = userID
        self.radiusInMeters = radiusInMeters
    }
    
    
    
    
    // Always return HTTP.GET
    func method() -> Alamofire.HTTPMethod {
        switch requestType {
        case .nearby, .caught:
            return .get
        default:
            return .post
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
        case .nearby:
            params[Constants.User.radiusInMeters] = radiusInMeters as AnyObject?
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
