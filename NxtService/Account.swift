//
//  Account.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 4/3/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import Foundation

class Account {
    private var _username: String!
    private var _password: String!
    private var _accountID: Int!
    
    var username: String! {
        get {
            return _username
        }
        
        set {
            _username = newValue
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
    
    var accountID: Int! {
        return _accountID
    }
    
    init(email: String, password: String) {
    }
    
    func createAccount() -> Int {
        return 0
    }
    
    func deleteAccount() -> Int {
        return 0
    }
}