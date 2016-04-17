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
        let providerDictionary: Dictionary<String, String> = [FirebaseProviderKeys.NAME: _name,
                                                              FirebaseProviderKeys.ADDRESS: _address,
                                                              FirebaseProviderKeys.PHONENUMBER: _phoneNumber,
                                                              FirebaseProviderKeys.MAINSERVICE: _mainService,
                                                              FirebaseProviderKeys.SUBSERVICES: _specialities,
                                                              FirebaseProviderKeys.BIOGRAPHY: "",
                                                              FirebaseProviderKeys.PAYMENTINFO: "",
                                                              FirebaseProviderKeys.PROFILEPICURL: ""]
        
        DataService.dataService.REF_PROVIDERINFO.childByAppendingPath(_providerID).setValue(providerDictionary)
        completion(providerCreated: true)
    }
    
    func loadProvider() {
        let reference = DataService.dataService.REF_PROVIDERINFO
        
        reference.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            
            if let providersDictionary = snapshot.value as? Dictionary<String, AnyObject> {
                if let providerDictionary = providersDictionary[self._providerID!] as? Dictionary<String, AnyObject> {
                    print(providerDictionary)
                    
                    
                    if let name = providerDictionary[FirebaseProviderKeys.NAME] as? String {
                        self._name = name
                    }
                    
                    if let address = providerDictionary[FirebaseProviderKeys.ADDRESS] as? String {
                        self.address = address
                    }
                    
                    if let phoneNumber = providerDictionary[FirebaseProviderKeys.PHONENUMBER] as? String {
                        self.phoneNumber = phoneNumber
                    }
                    
                    if let profilePictureURL = providerDictionary[FirebaseProviderKeys.PROFILEPICURL] as? String {
                        self._profilePictureURL = profilePictureURL
                    }
                    
                    if let biography = providerDictionary[FirebaseProviderKeys.BIOGRAPHY] as? String {
                        self._biography = biography
                    }
                    
                    if let mainService = providerDictionary[FirebaseProviderKeys.MAINSERVICE] as? String {
                        self._mainService = mainService
                    }
                    
                    if let specialities = providerDictionary[FirebaseProviderKeys.SUBSERVICES] as? String {
                        self._specialities = specialities
                    }
                    
                    if let paymentInfo = providerDictionary[FirebaseProviderKeys.PAYMENTINFO] as? String {
                        self._paymentInfo = paymentInfo
                    }
                }
            }
        })
    }
    
    func updateProvider(completion: (providerUpdated: Bool) -> ()) {
        let providerDictionary: Dictionary<String, String> = [FirebaseProviderKeys.NAME: _name,
                                                              FirebaseProviderKeys.ADDRESS: _address,
                                                              FirebaseProviderKeys.PHONENUMBER: _phoneNumber,
                                                              FirebaseProviderKeys.MAINSERVICE: _mainService,
                                                              FirebaseProviderKeys.SUBSERVICES: _specialities,
                                                              FirebaseProviderKeys.BIOGRAPHY: _biography!,
                                                              FirebaseProviderKeys.PAYMENTINFO: _paymentInfo!,
                                                              FirebaseProviderKeys.PROFILEPICURL: _profilePictureURL!]
        
        // Use method setValue to delete the old dictionary and place new one in the Firebase reference
        DataService.dataService.REF_PROVIDERINFO.childByAppendingPath(_providerID).setValue(providerDictionary)
        completion(providerUpdated: true)
    }
}