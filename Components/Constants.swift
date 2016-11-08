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
    // Step 16: Add monthDayYear
    static let monthDayYear = "MM/dd/yyyy"
    
    // Step 7: Add keychain strings
    public static let keychainIdentifier = "PeoplemonKeychain"
    public static let authTokenExpireDate = "authTokenExpireDate"
    public static let authToken = "authToken"
    public static let apiKey = "iOSandroid301november2016"
    

    
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
        static let hasRegistered = "HasRegistered"
        static let loginProvider = "LoginProvider"
        static let fullName = "FullName"
        static let avatarBase64 = "AvatarBase64"
        static let lastCheckInLongitude = "LastCheckInLongitude"
        static let lastCheckInLatitude = "LastCheckInLatitude"
        static let lastCheckInDateTime = "LastCheckInDateTime"
        static let oldPassword = "OldPassword"
        static let newPassword = "NewPassword"
        static let confirmPassword = "ConfirmPassword"
        static let password = "Password"
        static let apiKey = "ApiKey"
        static let grantType = "grant_type"
    }
    
    struct User {
        static let userId = "UserId"
        static let userName = "UserName"
        static let avatarBase64 = "AvatarBase64"
        static let longitude = "Longitude"
        static let latitude = "Latitude"
        static let caughtUserId = "CaughtUserId"
        static let radiusInMeters = "RadiusInMeters"
        static let conversationId = "ConversationId"
        static let recipientId = "RecipientId"
        static let recipientName = "RecipientName"
        static let lastMessage = "LastMessage"
        static let messageCount = "MessageCount"
        static let senderId = "SenderId"
        static let senderName = "SenderName"
        static let recipientAvatarBase64 = "RecipientAvatarBase64"
        static let senderAvatarBase64 = "SenderAvatarBase64"
        static let pageSize = "PageSize"
        static let pageNumber = "PageNumber"
        static let id = "Id"
        static let message = "Message"
    }
    
    
//    // Step 9: BudgetUser Constants
//    struct BudgetUser {
//        static let id = "id"
//        static let email = "email"
//        static let username = "username"
//        static let password = "password"
//        static let token = "token"
//        static let expirationDate = "expiration"
//    }
//    
//    // Step 10: Category Constants
//    struct Category {
//        static let id = "id"
//        static let name = "name"
//        static let categoryInfo = "category_info"
//        static let startDate = "start_date"
//        static let endDate = "end_date"
//        static let user = "user"
//        static let amount = "amount"
//        
//        static let month = "month"
//        static let day = "day"
//        static let year = "year"
//    }
//    
//    // Step 11: Expense Constants
//    struct Expense {
//        static let id = "id"
//        static let amount = "amount"
//        static let category = "category"
//        static let date = "date"
//        static let note = "note"
//        static let categoryId = "categoryId"
//        static let categoryName = "categoryName"
//        
//       
//        
//        // Step 19: Add month/year
//        static let month = "month"
//        static let year = "year"
//    }
}

// MARK: - Colors
// Step 14: UIColor extension and
extension UIColor {
    public class func rgba(red: NSInteger, green: NSInteger, blue: NSInteger, alpha: Float = 1.0) -> UIColor {
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha))
    }
}

struct ColorPalette {
    static let PositiveColor = UIColor.rgba(red: 15, green: 181, blue: 46)
    static let NegativeColor = UIColor.rgba(red: 219, green: 31, blue: 31)
    static let BlueColor = UIColor.rgba(red: 12, green: 35, blue: 64)
    static let GoldColor = UIColor.rgba(red: 201, green: 151, blue: 0)
    static let calendarCellColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.1)
    static let calendarTodayColor = UIColor.rgba(red: 12, green: 35, blue: 64, alpha: 0.3)
    static let calendarBorderColor = UIColor.rgba(red: 12, green: 35, blue: 64, alpha: 0.8)
}
