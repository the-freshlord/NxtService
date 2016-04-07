//
//  SignUpViewController.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 3/28/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit
import CoreLocation

class SignUpViewController: UIViewController, CLLocationManagerDelegate {
    var account: Account!
    var provider: Provider!
    var locationManager = CLLocationManager()
    var streetAddress: String?
    var city: String?
    var state: String?
    var zip: String?
    
    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if locationAuthorizationStatus() {
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - Location manager
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            // Use reverse geocode to get the physical string address based on the latitude and longitude coordinates
            CLGeocoder().reverseGeocodeLocation(location) { (placeMarks: [CLPlacemark]?, error: NSError?) in
                if error != nil {
                    print("Error in reverse goecoder: \(error?.localizedDescription)")
                    self.showErrorAlert("Error getting location", message: "Tap on your location to manually enter in your address")
                } else {
                    if placeMarks?.count > 0 {
                        if let placeMark = (placeMarks?[0]) {
                            print(placeMark.addressDictionary)
                            self.parseAddress(placeMark)
                        }
                    }
                }
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error getting location: \(error.localizedDescription)")
        showErrorAlert("Error getting location", message: "Tap on your location to manually enter in your address")
    }
    
    // MARK: - Events
    @IBAction func backButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Helper methods
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func locationAuthorizationStatus() -> Bool {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            return true
        } else {
            locationManager.requestWhenInUseAuthorization()
            
            if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
                return true
            } else {
                return false
            }
        }
    }
    
    func parseAddress(placeMark: CLPlacemark) {
        if let tempStreetAddress = placeMark.addressDictionary?[CLPLACEMARK_ADDRESSDICTIONARY_STREET] as? String {
            streetAddress = tempStreetAddress
            print(streetAddress)
        }
        if let tempCity = placeMark.addressDictionary?[CLPLACEMARK_ADDRESSDICTIONARY_CITY] as? String {
            city = tempCity
            print(city)
        }
        if let tempState = placeMark.addressDictionary?[CLPLACEMARK_ADDRESSDICTIONARY_STATE] as? String {
            state = tempState
            print(state)
        }
        if let tempZip = placeMark.addressDictionary?[CLPLACEMARK_ADDRESSDICTIONARY_ZIP] as? String {
            zip = tempZip
            print(zip)
        }
    }
}
