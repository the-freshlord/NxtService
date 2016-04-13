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
                    
                    // Just testing to see if parsing worked correctly
                    // Will change to create safe checking
                    self._name = providerDictionary[FirebaseProviderKeys.NAME] as! String
                    self._address = providerDictionary[FirebaseProviderKeys.ADDRESS] as! String
                    self._phoneNumber = providerDictionary[FirebaseProviderKeys.PHONENUMBER] as! String
                    self._profilePictureURL = providerDictionary[FirebaseProviderKeys.PROFILEPICURL] as? String
                    self._biography = providerDictionary[FirebaseProviderKeys.BIOGRAPHY] as? String
                    self._mainService = providerDictionary[FirebaseProviderKeys.MAINSERVICE] as! String
                    self._specialities = providerDictionary[FirebaseProviderKeys.SUBSERVICES] as! String
                    self.paymentInfo = providerDictionary[FirebaseProviderKeys.PAYMENTINFO] as? String
                }
            }
        })
    }
}