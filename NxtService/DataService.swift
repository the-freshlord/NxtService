//
//  DataService.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 4/4/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import Foundation
import Firebase
import UIKit

let URL_BASE = "https://nxtservice.firebaseio.com"

class DataService {
    static let dataService = DataService()
    
    private var _REF_BASE = Firebase(url: "\(URL_BASE)")
    private var _REF_ACCOUNT = Firebase(url: "\(URL_BASE)/account")
    private var _REF_PROVIDERINFO = Firebase(url: "\(URL_BASE)/providerinfo")
    private var _REF_PROFILEIMAGE = Firebase(url: "\(URL_BASE)/profileimage")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
    var REF_ACCOUNT: Firebase {
        return _REF_ACCOUNT
    }
    
    var REF_PROVIDERINFO: Firebase {
        return _REF_PROVIDERINFO
    }
    
    var REF_PROFILEIMAGE: Firebase {
        return _REF_PROFILEIMAGE
    }
    
    func createFireBaseUser(accountID: String, serviceProvider: Dictionary<String, String>) {
        _REF_ACCOUNT.childByAppendingPath(accountID).setValue(serviceProvider)
    }
    
    func deleteFireBaseUser(accountID: String) {
        _REF_ACCOUNT.childByAppendingPath(accountID).removeValue()
    }
    
    func addProfileImage(providerID: String, image: UIImage) {
        // Make an NSData PNG representation of the image
        let imageData: NSData = UIImagePNGRepresentation(image)!
        
        // Use base64StringFromData, the image can be converted to a string
        let base64String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
        let imageString = ["imagestring": base64String]
        
        _REF_PROFILEIMAGE.childByAppendingPath(providerID).setValue(imageString)
    }
    
    func loadProfileImage(providerID: String, onCompletion: (decodedImage: UIImage) -> ()) {
        self._REF_PROFILEIMAGE.observeEventType(.Value, withBlock: { snapshot in
            
            guard let profileImageDictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            guard let providerImageDictionary = profileImageDictionary[providerID] as? Dictionary<String, AnyObject> else { return }
            guard let base64String = providerImageDictionary[FirebaseProviderKeys.IMAGEBASE64] as? String else { return }
            
            let decodedData = NSData(base64EncodedString: base64String, options:NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
            let decodedImage = UIImage(data: decodedData!)!
            onCompletion(decodedImage: decodedImage)
        })
    }
    
    func deleteProfileImage(providerID: String, onCompletion: (imageDeleted: Bool) -> ()) {
        _REF_PROFILEIMAGE.childByAppendingPath(providerID).removeValue()
        onCompletion(imageDeleted: true)
    }
    
    func loadProviders(streetAddress: String, mainService: String, speciality: String, onCompletion: (providerList: [Provider]) -> ()) {
        // Load the providers based on the main service and sub service
        self._REF_PROVIDERINFO.observeSingleEventOfType(.Value, withBlock: { snapshot in
            guard let snapshots = snapshot.children.allObjects as? [FDataSnapshot] else { return }
            
            var providerList = [Provider]()
            
            // Traverse through the list
            for snapshot in snapshots {
                guard let providerDictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                
                if mainService == providerDictionary[FirebaseProviderKeys.MAINSERVICE] as? String && speciality == providerDictionary[FirebaseProviderKeys.SUBSERVICES] as? String {
                    
                    let provider = Provider(providerID: snapshot.key)
                    
                    guard let name = providerDictionary[FirebaseProviderKeys.NAME] as? String else { return }
                    guard let address = providerDictionary[FirebaseProviderKeys.ADDRESS] as? String else { return }
                    guard let phoneNumber = providerDictionary[FirebaseProviderKeys.PHONENUMBER] as? String else { return }
                    guard let biography = providerDictionary[FirebaseProviderKeys.BIOGRAPHY] as? String else { return }
                    guard let mainService = providerDictionary[FirebaseProviderKeys.MAINSERVICE] as? String else { return }
                    guard let specialities = providerDictionary[FirebaseProviderKeys.SUBSERVICES] as? String else { return }
                    guard let paymentInfo = providerDictionary[FirebaseProviderKeys.PAYMENTINFO] as? String else { return }
                    guard let profileImage = providerDictionary[FirebaseProviderKeys.PROFILEIMAGE] as? Bool else { return }
                    
                    provider.name = name
                    provider.address = address
                    provider.phoneNumber = phoneNumber
                    provider.biography = biography
                    provider.mainService = mainService
                    provider.specialities = specialities
                    provider.paymentInfo = paymentInfo
                    provider.profileImage = profileImage
                    
                    // Insert Provider object into provider list
                    providerList.append(provider)
                }
            }
            
            onCompletion(providerList: providerList)
        })
    }
}