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
    private var _phoneNumber: String?
    private var _biography: String?
    private var _mainService: String!
    private var _specialities: String!
    private var _paymentInfo: String?
    private var _profileImage: Bool!
    
    var providerID: String? {
        guard let tempProviderID = _providerID else { return nil }
        
        return tempProviderID
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
    
    var phoneNumber: String? {
        get {
            guard let tempPhoneNumber = _phoneNumber else { return nil }
            
            return tempPhoneNumber
        }
        
        set {
            _phoneNumber = newValue
        }
    }
    
    var biography: String? {
        get {
            guard let tempBiography = _biography else { return nil }
            
            return tempBiography
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
            guard let tempPaymentInfo = _paymentInfo else { return nil }
            
            return tempPaymentInfo
        }
        
        set {
            _paymentInfo = newValue
        }
    }
    
    var profileImage: Bool {
        get {
            return _profileImage
        }
        
        set {
            _profileImage = newValue
        }
    }
    
    init(providerID: String) {
        _providerID = providerID
    }
    
    func createProvider(completion: (providerCreated: Bool) -> ()) {
        let providerDictionary: Dictionary<String, AnyObject> = [FirebaseProviderKeys.NAME: _name,
                                                                 FirebaseProviderKeys.ADDRESS: _address,
                                                                 FirebaseProviderKeys.PHONENUMBER: "",
                                                                 FirebaseProviderKeys.MAINSERVICE: _mainService,
                                                                 FirebaseProviderKeys.SUBSERVICES: _specialities,
                                                                 FirebaseProviderKeys.BIOGRAPHY: "",
                                                                 FirebaseProviderKeys.PAYMENTINFO: "",
                                                                 FirebaseProviderKeys.PROFILEIMAGE: false]
        
        DataService.dataService.REF_PROVIDERINFO.childByAppendingPath(_providerID).setValue(providerDictionary)
        completion(providerCreated: true)
    }
    
    func loadProvider(onCompletion: (providerLoaded: Bool) -> ()) {
        let reference = DataService.dataService.REF_PROVIDERINFO
        
        reference.observeEventType(.Value, withBlock: { snapshot in
            
            guard let providersDictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            guard let providerDictionary = providersDictionary[self._providerID!] as? Dictionary<String, AnyObject> else { return }
            
            guard let name = providerDictionary[FirebaseProviderKeys.NAME] as? String else { return }
            guard let address = providerDictionary[FirebaseProviderKeys.ADDRESS] as? String else { return }
            guard let phoneNumber = providerDictionary[FirebaseProviderKeys.PHONENUMBER] as? String else { return }
            guard let biography = providerDictionary[FirebaseProviderKeys.BIOGRAPHY] as? String else { return }
            guard let mainService = providerDictionary[FirebaseProviderKeys.MAINSERVICE] as? String else { return }
            guard let specialities = providerDictionary[FirebaseProviderKeys.SUBSERVICES] as? String else { return }
            guard let paymentInfo = providerDictionary[FirebaseProviderKeys.PAYMENTINFO] as? String else { return }
            guard let profileImage = providerDictionary[FirebaseProviderKeys.PROFILEIMAGE] as? Bool else { return }
            
            self._name = name
            self._address = address
            self._phoneNumber = phoneNumber
            self._biography = biography
            self._mainService = mainService
            self._specialities = specialities
            self._paymentInfo = paymentInfo
            self._profileImage = profileImage
            
            onCompletion(providerLoaded: true)
        })
    }
    
    func updateProvider(completion: (providerUpdated: Bool) -> ()) {
        let providerDictionary: Dictionary<String, AnyObject> = [FirebaseProviderKeys.NAME: _name,
                                                              FirebaseProviderKeys.ADDRESS: _address,
                                                              FirebaseProviderKeys.PHONENUMBER: _phoneNumber!,
                                                              FirebaseProviderKeys.MAINSERVICE: _mainService,
                                                              FirebaseProviderKeys.SUBSERVICES: _specialities,
                                                              FirebaseProviderKeys.BIOGRAPHY: _biography!,
                                                              FirebaseProviderKeys.PAYMENTINFO: _paymentInfo!,
                                                              FirebaseProviderKeys.PROFILEIMAGE: _profileImage]
        
        // Use method setValue to delete the old dictionary and place new one in the Firebase reference
        DataService.dataService.REF_PROVIDERINFO.childByAppendingPath(_providerID).setValue(providerDictionary)
        completion(providerUpdated: true)
    }
    
    func deleteProvider(completion: (providerDeleted: Bool) -> ()) {
        DataService.dataService.REF_PROVIDERINFO.childByAppendingPath(_providerID).removeValue()
        completion(providerDeleted: true)
    }
}