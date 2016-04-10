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
let SHADOW_COLOR: CGFloat = 157.0 / 255.0

// Firebase Keys
let KEY_ACCOUNTID = "uid"

// Firebase Provider keys
let FIREBASE_PROVIDER_NAME = "name"
let FIREBASE_PROVIDER_ADDRESS = "address"
let FIREBASE_PROVIDER_PHONENUMBER = "phonenumber"
let FIREBASE_PROVIDER_MAINSERVICE = "mainservice"
let FIREBASE_PROVIDER_SUBSERVICES = "subservices"
let FIREBASE_PROVIDER_BIOGRAPHY = "biography"
let FIREBASE_PROVIDER_PAYMENTINFO = "paymentinfo"
let FIREBASE_PROVIDER_PROFILEPICURL = "profilepicurl"

// Firebase error codes
let STATUS_ACCOUNT_NONEXIST = -8
let STATUS_INVALID_EMAIL = -5

// Segue Identifiers
let SEGUE_SIGNUP = "gotosignupview"
let SEGUE_PROFILE_MENU = "gotoprofilemenu"

// CLPlacemark Keys
let CLPLACEMARK_ADDRESSDICTIONARY_STREET = "Street"
let CLPLACEMARK_ADDRESSDICTIONARY_CITY = "City"
let CLPLACEMARK_ADDRESSDICTIONARY_STATE = "State"
let CLPLACEMARK_ADDRESSDICTIONARY_ZIP = "ZIP"
let CLPLACEMARK_ADDRESSDICTIONARY_COUNTRY = "Country"

// Google Places API key
let GOOGLE_API_KEY = "AIzaSyC1qD5oGbQ1UbrJgrc17W02m2NCzIIg98c"

// NSNotificationCenter post notification names
let NOTIFICATION_NAME_ACCOUNT_CREATED = "accountCreated"

// NSNotificationCenter user info dictionary keys
let NOTIFICATION_USERINFO_ACCOUNTID = "accountID"
let NOTIFICATION_USERINFO_EMAIL = "email"
let NOTIFICATION_USERINFO_PASSWORD = "password"