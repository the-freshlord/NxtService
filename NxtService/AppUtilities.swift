//
//  AppUtilities.swift
//  NxtService
//
//  Created by Emanuel Guerrero
//             Shaquella Dunanson
//             Santago Facuno
//             Jevin Francis
//             Marcus Guerrer
//             Stephen Green
//             Ryan Fernandez on 4/9/16.
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

public func calculateDistance(userLocation: String, providerLocation: String, onCompletion: (distance: Int) -> ()) {
    // Get coordinates for user's location
    getCLLocation(userLocation) { (cLLocation) in
        let userCLLocation = cLLocation
        
        // Get coordinates for provider's location
        getCLLocation(providerLocation) { (cLLocation) in
            let providerCLLocation = cLLocation
            
            // Calculate distance
            let distanceMeters = userCLLocation.distanceFromLocation(providerCLLocation)
            
            // Convert distanceMeters to miles
            let distanceMiles = Int(distanceMeters * 0.00062137)
            
            onCompletion(distance: distanceMiles)
        }
    }
}

private func getCLLocation(streetAddress: String, completion: (cLLocation: CLLocation) -> ()) {
    CLGeocoder().geocodeAddressString(streetAddress) { (placemarks: [CLPlacemark]?, error: NSError?) in
        
        if error != nil {
            print(error.debugDescription)
            return
        }
        
        guard let marks = placemarks where marks.count > 0 else { return }
        guard let location = marks[0].location else { return }
        
        let tempCLLocation = location
        completion(cLLocation: tempCLLocation)
    }
}