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
    
    // TODO: - Implement create and delete account
    init(email: String, password: String, accountID: String?) {
        _email = email
        _password = password
        
        if let tempAccountID = accountID {
            _accountID = tempAccountID
        }
    }
    
    func createAccount() -> Int {
        return 0
    }
    
    func deleteAccount() -> Int {
        return 0
    }
}