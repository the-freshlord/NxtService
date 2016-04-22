//
//  Account.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 4/3/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import Foundation

class Account {
    private var _email: String!
    private var _password: String!
    private var _accountID: String?
    
    var email: String! {
        get {
            return _email
        }
        
        set {
            _email = newValue
        }
    }
    
    var password: String! {
        get {
            return _password
        }
        
        set {
            _password = newValue
        }
    }
    
    var accountID: String? {
        guard let tempAccountID = _accountID else { return nil }
        
        return tempAccountID
    }
    
    init(email: String, password: String, accountID: String?) {
        _email = email
        _password = password
        
        guard let tempAccountID = accountID as String? else {
            return
        }
        _accountID = tempAccountID
    }
    
    func createAccount(completion: (accountCreated: Bool) -> ()) {
        // Create the user's Firebase account
        DataService.dataService.REF_BASE.createUser(_email, password: _password) { (error: NSError!, result: [NSObject : AnyObject]!) in
            if error != nil {
                completion(accountCreated: false)
            } else {
                
                // Log the user in to get the accountID
                DataService.dataService.REF_BASE.authUser(self._email, password: self.password, withCompletionBlock: { error, result in
                    // Create user
                    let user: [String: String] = ["provider": result.provider, "email": self._email]
                    DataService.dataService.createFireBaseUser(result.uid, serviceProvider: user)
                    self._accountID = result.uid
                    completion(accountCreated: true)
                })
            }
        }
    }
    
    func updateEmail(newEmail: String, completion: (emailUpdated: Bool, errorMessage: String) -> ()) {
        // Update the user's email for using Firebase
        DataService.dataService.REF_BASE.changeEmailForUser(_email, password: _password, toNewEmail: newEmail) { (error: NSError!) in
            if error != nil {
                var errorMessage = ""
                
                switch error.code {
                case FirebaseErrorCodes.EMAIL_TAKEN:
                    errorMessage = "The email entered is already being used"
                case FirebaseErrorCodes.INVALID_EMAIL:
                    errorMessage = "The email entered is not valid"
                default:
                    errorMessage = "An unknwon error occured when updating your email"
                }
                
                completion(emailUpdated: false, errorMessage: errorMessage)
            } else {
                self._email = newEmail
                completion(emailUpdated: true, errorMessage: "")
            }
        }
    }
    
    func updatePassword(newPassword: String, completion: (passwordUpdated: Bool) -> ()) {
        // Update the user's password for using Firebase
        DataService.dataService.REF_BASE.changePasswordForUser(_email, fromOld: _password, toNew: newPassword) { (error: NSError!) in
            if error != nil {
                completion(passwordUpdated: false)
            } else {
                self._password = newPassword
                completion(passwordUpdated: true)
            }
        }
    }
    
    func deleteAccount() -> Int {
        return 0
    }
}