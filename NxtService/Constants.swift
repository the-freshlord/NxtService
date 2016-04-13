//
//  Constants.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 3/28/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import Foundation
import UIKit

// Material Design
struct MaterialDesign {
    static let SHADOW_COLOR: CGFloat = 157.0 / 255.0
}

// Firebase Provider keys
struct FirebaseProviderKeys {
    static let NAME = "name"
    static let ADDRESS = "address"
    static let PHONENUMBER = "phonenumber"
    static let MAINSERVICE = "mainservice"
    static let SUBSERVICES = "subservices"
    static let BIOGRAPHY = "biography"
    static let PAYMENTINFO = "paymentinfo"
    static let PROFILEPICURL = "profilepicurl"
}

// Firebase error codes
struct FirebaseErrorCodes {
    static let ACCOUNT_NONEXIST = -8
    static let INVALID_EMAIL = -5
    static let TOO_MANY_REQUESTS = -9999
}

// Segue Identifiers
struct SegueIdentifiers {
    static let SIGNUP = "gotosignupview"
    static let PROFILE_MENU = "gotoprofilemenu"
    static let PROFILE_BASIC_INFO = "gotobasicinfo"
    static let PROFILE_CREDENTIALS = "gotocredentials"
    static let PROFILE_SERVICES = "gotoservices"
    static let PROFILE_LOCATION = "gotolocation"
}

// CLPlacemark Keys
struct CLPlacemarkAddressDictionaryKeys {
    static let STREET = "Street"
    static let CITY = "City"
    static let STATE = "State"
    static let ZIP = "ZIP"
    static let COUNTRY = "Country"
}

// API keys
struct APIKeys {
    static let GOOGLE_API_KEY = "AIzaSyC1qD5oGbQ1UbrJgrc17W02m2NCzIIg98c"
}

// NSNotificationCenter post notification names
struct NSNotificationCenterPostNotificationNames {
    static let ACCOUNT_CREATED = "accountCreated"
}

// NSNotificationCenter user info dictionary keys
struct NSNotificationCenterUserInfoDictKeys {
    static let ACCOUNTID = "accountID"
    static let EMAIL = "email"
    static let PASSWORD = "password"
}