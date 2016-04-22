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
    
    guard let tempStreetAddress = placeMark.addressDictionary?[CLPlacemarkAddressDictionaryKeys.STREET] as? String else {
        return streetAddress
    }
    
    guard let tempCity = placeMark.addressDictionary?[CLPlacemarkAddressDictionaryKeys.CITY] as? String else {
        return streetAddress
    }
    
    guard let tempState = placeMark.addressDictionary?[CLPlacemarkAddressDictionaryKeys.STATE] as? String else {
        return streetAddress
    }
    
    guard let tempZip = placeMark.addressDictionary?[CLPlacemarkAddressDictionaryKeys.ZIP] as? String else {
        return streetAddress
    }
    
    guard let tempCountry = placeMark.addressDictionary?[CLPlacemarkAddressDictionaryKeys.COUNTRY] as? String else {
        return streetAddress
    }
    
    streetAddress = "\(tempStreetAddress), \(tempCity), \(tempState), \(tempZip), \(tempCountry)"
    
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