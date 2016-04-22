//
//  AppUtilities.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 4/9/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

public func parseAddress(placeMark: CLPlacemark) -> String {
    var streetAddress = ""
    
    if let tempStreetAddress = placeMark.addressDictionary?[CLPlacemarkAddressDictionaryKeys.STREET] as? String {
        print(tempStreetAddress)
        streetAddress = tempStreetAddress
    } else {
        streetAddress = ""
        return streetAddress
    }
    
    if let tempCity = placeMark.addressDictionary?[CLPlacemarkAddressDictionaryKeys.CITY] as? String {
        print(tempCity)
        streetAddress = streetAddress + ", \(tempCity)"
    } else{
        streetAddress = ""
        return streetAddress
    }
    
    if let tempState = placeMark.addressDictionary?[CLPlacemarkAddressDictionaryKeys.STATE] as? String {
        print(tempState)
        streetAddress = streetAddress + ", \(tempState)"
    } else {
        streetAddress = ""
        return streetAddress
    }
    
    if let tempZip = placeMark.addressDictionary?[CLPlacemarkAddressDictionaryKeys.ZIP] as? String {
        print(tempZip)
        streetAddress = streetAddress + ", \(tempZip)"
    } else {
        streetAddress = ""
        return streetAddress
    }
    
    if let tempCountry = placeMark.addressDictionary?[CLPlacemarkAddressDictionaryKeys.COUNTRY] as? String {
        print(tempCountry)
        streetAddress = streetAddress + ", \(tempCountry)"
    } else {
        streetAddress = ""
        return streetAddress
    }
    
    print(streetAddress)
    return streetAddress
}

public func fixImageOrientation(image: UIImage) -> UIImage {
    if image.imageOrientation == UIImageOrientation.Up {
        return image
    }
    
    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
    let rect = CGRect(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height)
    image.drawInRect(rect)
    
    let normalImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return normalImage
}