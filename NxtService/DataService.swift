//
//  DataService.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 4/4/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = "https://nxtservice.firebaseio.com"

class DataService {
    static let dataService = DataService()
    
    private var _REF_BASE = Firebase(url: "\(URL_BASE)")
    private var _REF_ACCOUNT = Firebase(url: "\(URL_BASE)/account")
    private var _REF_PROVIDERINFO = Firebase(url: "\(URL_BASE)/providerinfo")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
    var REF_ACCOUNT: Firebase {
        return _REF_ACCOUNT
    }
    
    var REF_PROVIDERINFO: Firebase {
        return _REF_PROVIDERINFO
    }
    
    func createFireBaseUser(accountID: String, serviceProvider: Dictionary<String, String>) {
        REF_ACCOUNT.childByAppendingPath(accountID).setValue(serviceProvider)
    }
}