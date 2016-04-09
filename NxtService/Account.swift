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
        return _accountID
    }
    
    init(email: String, password: String, accountID: String?) {
        _email = email
        _password = password
        
        if let tempAccountID = accountID {
            _accountID = tempAccountID
        }
    }
    
    func createAccount(completion: (accountCreated: Bool) -> ()) {
        // Create the user's Firebase account
        DataService.dataService.REF_BASE.createUser(_email, password: _password) { (error: NSError!, result: [NSObject : AnyObject]!) in
            if error != nil {
                print(error.debugDescription)
                completion(accountCreated: false)
            } else {
                
                // Log the user in to get the accountID
                DataService.dataService.REF_BASE.authUser(self._email, password: self.password, withCompletionBlock: { error, result in
                    // Create user
                    let user: [String: String] = ["provider": result.provider, "email": self._email]
                    DataService.dataService.createFireBaseUser(result.uid, serviceProvider: user)
                    completion(accountCreated: true)
                })
            }
        }
    }
    
    func deleteAccount() -> Int {
        return 0
    }
}