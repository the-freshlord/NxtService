//
//  AppUtilities.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 4/9/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import Foundation
import CoreLocation

public func parseAddress(placeMark: CLPlacemark) -> String {
    var streetAddress = ""
    
    if let tempStreetAddress = placeMark.addressDictionary?[CLPLACEMARK_ADDRESSDICTIONARY_STREET] as? String {
        print(tempStreetAddress)
        streetAddress = tempStreetAddress
    } else {
        streetAddress = ""
        return streetAddress
    }
    
    if let tempCity = placeMark.addressDictionary?[CLPLACEMARK_ADDRESSDICTIONARY_CITY] as? String {
        print(tempCity)
        streetAddress = streetAddress + ", \(tempCity)"
    } else{
        streetAddress = ""
        return streetAddress
    }
    
    if let tempState = placeMark.addressDictionary?[CLPLACEMARK_ADDRESSDICTIONARY_STATE] as? String {
        print(tempState)
        streetAddress = streetAddress + ", \(tempState)"
    } else {
        streetAddress = ""
        return streetAddress
    }
    
    if let tempZip = placeMark.addressDictionary?[CLPLACEMARK_ADDRESSDICTIONARY_ZIP] as? String {
        print(tempZip)
        streetAddress = streetAddress + ", \(tempZip)"
    } else {
        streetAddress = ""
        return streetAddress
    }
    
    if let tempCountry = placeMark.addressDictionary?[CLPLACEMARK_ADDRESSDICTIONARY_COUNTRY] as? String {
        print(tempCountry)
        streetAddress = streetAddress + ", \(tempCountry)"
    } else {
        streetAddress = ""
        return streetAddress
    }
    
    print(streetAddress)
    return streetAddress
}