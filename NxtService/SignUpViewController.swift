//
//  SignUpViewController.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 3/28/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit
import CoreLocation

class SignUpViewController: UIViewController {
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mainServiceTextField: UITextField!
    @IBOutlet weak var specialitiesTextField: UITextField!
    
    var account: Account!
    var provider: Provider!
    var locationManager = CLLocationManager()
    var streetAddress: String!
    
    let googlePlacesAutoCompleteViewController = GooglePlacesAutocomplete(apiKey: GOOGLE_API_KEY, placeType: .Address)
    
    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if locationAuthorizationStatus() {
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        googlePlacesAutoCompleteViewController.placeDelegate = self
    }
    
    // MARK: - Events
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func locationTapped(sender: UITapGestureRecognizer) {
        presentViewController(googlePlacesAutoCompleteViewController, animated: true, completion: nil)
    }
    
    @IBAction func getStartedButtonTapped(sender: MaterialButton) {
        
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
}
    
// MARK: - CLLocationManagerDelegate
extension SignUpViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            
            // Use reverse geocode to get the physical string address based on the latitude and longitude coordinates
            CLGeocoder().reverseGeocodeLocation(location) { (placeMarks: [CLPlacemark]?, error: NSError?) in
                if error != nil {
                    print("Error in reverse goecoder: \(error?.localizedDescription)")
                    
                    // Go back to the main thread to display the alert view controller
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showErrorAlert("Error getting location", message: "Tap on your location to manually enter in your address")
                    })
                } else {
                    if placeMarks?.count > 0 {
                        if let placeMark = (placeMarks?[0]) {
                            print(placeMark.addressDictionary)
                            
                            self.streetAddress = parseAddress(placeMark)
                            manager.stopUpdatingLocation()
                            
                            //Check if the street address was parsed correctly
                            if self.streetAddress == "" {
                                
                                // Go back to the main thread to display the alert view controller
                                dispatch_async(dispatch_get_main_queue(), { 
                                    self.showErrorAlert("Error getting location", message: "Tap on your location to manually enter in your address")
                                })
                            }
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
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - GooglePlacesAutocompleteDelegate
extension SignUpViewController: GooglePlacesAutocompleteDelegate {
    func placeSelected(place: Place) {
        place.getDetails { (PlaceDetails) in
            print(PlaceDetails.formattedAddress)
            self.googlePlacesAutoCompleteViewController.gpaViewController.searchBar.text = PlaceDetails.formattedAddress
            self.streetAddress = PlaceDetails.formattedAddress
        }
    }
    
    func placeViewClosed() {
        googlePlacesAutoCompleteViewController.gpaViewController.searchBar.text = ""
        googlePlacesAutoCompleteViewController.gpaViewController.searchBar(googlePlacesAutoCompleteViewController.gpaViewController.searchBar, textDidChange: "")
        
        print("Exiting Autocomplete")
        print("Last Address: \(streetAddress)")
        dismissViewControllerAnimated(true, completion: nil)
    }
}