//
//  Provider.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 4/3/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import Foundation

class Provider {
    private var _providerID: String?
    private var _name: String!
    private var _address: String!
    private var _phoneNumber: String!
    private var _profilePictureURL: String?
    private var _biography: String?
    private var _mainService: String!
    private var _specialities: String!
    private var _paymentInfo: String?
    
    var providerID: String? {
        if let tempProviderID = _providerID {
            return tempProviderID
        } else {
            return nil
        }
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
    
    var phoneNumber: String {
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
    
    init(providerID: String) {
        _providerID = providerID
    }
    
    func createProvider(completion: (providerCreated: Bool) -> ()) {
        let providerDictionary: Dictionary<String, String> = [FIREBASE_PROVIDER_NAME: _name,
                                                              FIREBASE_PROVIDER_ADDRESS: _address,
                                                              FIREBASE_PROVIDER_PHONENUMBER: _phoneNumber,
                                                              FIREBASE_PROVIDER_MAINSERVICE: _mainService,
                                                              FIREBASE_PROVIDER_SUBSERVICES: _specialities,
                                                              FIREBASE_PROVIDER_BIOGRAPHY: "",
                                                              FIREBASE_PROVIDER_PAYMENTINFO: "",
                                                              FIREBASE_PROVIDER_PROFILEPICURL: ""]
        
        DataService.dataService.REF_PROVIDERINFO.childByAppendingPath(_providerID).setValue(providerDictionary)
        completion(providerCreated: true)
    }
}