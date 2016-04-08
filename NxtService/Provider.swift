//
//  Provider.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 4/3/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import Foundation

class Provider {
    private var _accountID: String?
    private var _providerID: String!
    private var _name: String!
    private var _address: String!
    private var _phoneNumber: Int!
    private var _profilePictureURL: String?
    private var _biography: String?
    private var _mainService: String!
    private var _specialities: String!
    private var _paymentInfo: String?
    
    var accountID: String? {
        if let tempAccountID = _accountID {
            return tempAccountID
        } else {
            return nil
        }
    }
    
    var providerID: String {
        return _providerID
    }
    
    var name: String {
        get {
            return _name
        }
        
        set {
            _name = newValue
        }
    }
    
    var address: String {
        get {
            return _address
        }
        
        set {
            _address = newValue
        }
    }
    
    var phoneNumber: Int {
        get {
            return _phoneNumber
        }
        
        set {
            _phoneNumber = newValue
        }
    }
    
    var profilePictureURL: String? {
        get {
            if let tempProfilePictureURL = _profilePictureURL {
                return tempProfilePictureURL
            } else {
                return nil
            }
        }
        
        set {
            _profilePictureURL = newValue
        }
    }
    
    var biography: String? {
        get {
            if let tempBiography = _biography {
                return tempBiography
            } else {
                return nil
            }
        }
        
        set {
            _biography = newValue
        }
    }
    
    var mainService: String {
        get {
            return _mainService
        }
        
        set {
            _mainService = newValue
        }
    }
    
    var specialities: String {
        get {
            return _specialities
        }
        
        set {
            _specialities = newValue
        }
    }
    
    var paymentInfo: String? {
        get {
            if let tempPaymentInfo = _paymentInfo {
                return tempPaymentInfo
            } else {
                return nil
            }
        }
        
        set {
            _paymentInfo = newValue
        }
    }
    
    init(accountID: String?, providerID: String) {
        if let tempAccountID = accountID {
            _accountID = tempAccountID
        }
        
        _providerID = providerID
    }
}