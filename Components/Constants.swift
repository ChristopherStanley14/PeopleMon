//
//  Constants.swift
//  EFAB
//
//  Created by Christopher Stanley on 10/31/16.
//  Copyright © 2016 Christopher Stanley. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    // Step 7: Add keychain strings
    public static let keychainIdentifier = "PeoplemonKeychain"
    public static let authTokenExpireDate = "authTokenExpireDate"
    public static let authToken = "authToken"
    public static let apiKey = "iOSandroid301november2016"
    static let radiusInMeters = 100
    static let serverImageSize: CGFloat = 80
    static let avatarSize: CGFloat = 120
    static let pinImageSize: CGFloat = 16
    static let nearbyRadius: CGFloat = 400
    

    
    // Step 4: JSON Constants
    struct JSON {
        static let unknownError = "An Unknown Error Has Occurred"
        static let processingError = "There was an error processing the response"
    }
    
    
    struct Account {
        static let token = "access_token"
        static let expiration = ".expires"
        static let id = "Id"
        static let email = "Email"
        static let password = "password"
        static let hasRegistered = "HasRegistered"
        static let loginProvider = "LoginProvider"
        static let fullName = "FullName"
        static let avatarBase64 = "AvatarBase64"
        static let lastCheckInLongitude = "LastCheckInLongitude"
        static let lastCheckInLatitude = "LastCheckInLatitude"
        static let apiKey = "Apikey"
        static let grantType = "grant_type"
        static let userName = "userName"
    }
    
    struct User {
        static let userId = "UserId"
        static let userName = "UserName"
        static let longitude = "Longitude"
        static let latitude = "Latitude"
        static let avatarBase64 = "AvatarBase64"
        static let created = "Created"
        static let caughtUserId = "CaughtUserId"
        static let radiusInMeters = "radiusInMeters"
    }
    
//    enum Images : String {
//        case Avatar
//        
//        func image() -> UIImage {
//            return UIImage(named: self.rawValue)!
//        }
//    }
}
