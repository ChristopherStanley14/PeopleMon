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
    var created : String?
    var caughtUserId : String?
    var radiusInMeters : Int?
    var conversationId : Int?
    var recipientId : String?
    var recipientName : String?
    var lastMessage : String?
    var messageCount : Int?
    var senderId : String?
    var senderName : String?
    var recipientAvatarBase64 : String?
    var senderAvatarBase64 : String?
    var auth : String?
    var pageSize : Int?
    var pageNumber : Int?
    var id : Int?
    var message : String?
    
    // Request Type
    enum RequestType {
        case nearby
        case checkIn
        case Catch
        case caught
        case conversations
        case getConversation
        case postConversation
        
        
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
        created = try? json.getString(at: Constants.User.created)
        caughtUserId = try? json.getString(at: Constants.User.caughtUserId)
        radiusInMeters = try? json.getInt(at: Constants.User.radiusInMeters)
        conversationId = try? json.getInt(at: Constants.User.conversationId)
        recipientId = try? json.getString(at: Constants.User.recipientId)
        recipientName = try? json.getString(at: Constants.User.recipientName)
        lastMessage = try? json.getString(at: Constants.User.lastMessage)
        messageCount = try? json.getInt(at: Constants.User.messageCount)
        senderId = try? json.getString(at: Constants.User.senderId)
        senderName = try? json.getString(at: Constants.User.senderName)
        recipientAvatarBase64 = try? json.getString(at: Constants.User.recipientAvatarBase64)
        senderAvatarBase64 = try? json.getString(at: Constants.User.senderAvatarBase64)
        pageSize = try? json.getInt(at: Constants.User.pageSize)
        pageNumber = try? json.getInt(at: Constants.User.pageNumber)
        id = try? json.getInt(at: Constants.User.id)
        message = try? json.getString(at: Constants.User.message)

    }
    
    init(radiusInMeters: Int, auth: String) {
        self.radiusInMeters = radiusInMeters
        self.auth = auth
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
    
    init(auth: String) {
        self.auth = auth
        requestType = .caught
    }
    
    init(pageSize: Int, pageNumber: Int, auth: String) {
        self.pageSize = pageSize
        self.pageNumber = pageNumber
        self.auth = auth
        requestType = .conversations
    }
    
    init(id: Int, pageSize: Int, pageNumber: Int, auth: String) {
        self.id = id
        self.pageSize = pageSize
        self.pageNumber = pageNumber
        self.auth = auth
        requestType = .getConversation
    }
    
    init(recipientId: String, message: String) {
        self.recipientId = recipientId
        self.message = message
        requestType = .postConversation
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
        case .conversations:
            return "/v1/User/Conversations"
        case .getConversation:
            return "/v1/User/Conversation"
        case .postConversation:
            return "/v1/User/Conversation"
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
