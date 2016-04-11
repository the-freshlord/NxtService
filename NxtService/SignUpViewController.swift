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
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var indicatorView: UIView!
    
    var account: Account!
    var provider: Provider!
    var locationManager = CLLocationManager()
    var streetAddress: String!
    var accountCreated = false
    
    var googlePlacesAutoCompleteViewController: GooglePlacesAutocomplete!
    
    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberTextField.delegate = self
        nameTextField.delegate = self
        mainServiceTextField.delegate = self
        specialitiesTextField.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if locationAuthorizationStatus() {
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        googlePlacesAutoCompleteViewController = GooglePlacesAutocomplete(apiKey: GOOGLE_API_KEY, placeType: .Address)
        googlePlacesAutoCompleteViewController.placeDelegate = self
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if accountCreated {
            stopSpinning()
            NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_NAME_ACCOUNT_CREATED, object: nil)
        }
    }
    
    // MARK: - Events
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        
        phoneNumberTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        mainServiceTextField.resignFirstResponder()
        specialitiesTextField.resignFirstResponder()
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        leaveSignUpStoryBoard()
    }
    
    @IBAction func locationTapped(sender: UITapGestureRecognizer) {
        presentViewController(googlePlacesAutoCompleteViewController, animated: true, completion: nil)
    }
    
    @IBAction func getStartedButtonTapped(sender: MaterialButton) {
        if let phoneNumber = phoneNumberTextField.text where phoneNumber != "", let name = nameTextField.text where name != "", let mainService = mainServiceTextField.text where mainService != "", let specialities = specialitiesTextField.text where specialities != "" {
            
            if streetAddress != "" {
                
                // Start activity indicator animation
                startSpinning()
                
                // Create the account
                account.createAccount({ (accountCreated) in
                    if accountCreated.boolValue == true {
                        self.provider = Provider(providerID: self.account.accountID!)
                        self.provider.address = self.streetAddress
                        self.provider.phoneNumber = phoneNumber
                        self.provider.name = name
                        self.provider.mainService = mainService.uppercaseString
                        self.provider.specialities = specialities.uppercaseString
                        
                        self.provider.createProvider({ (providerCreated) in
                            if providerCreated.boolValue == true {
                                self.accountCreated = true
                                self.leaveSignUpStoryBoard()
                            } else {
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.stopSpinning()
                                    self.showErrorAlert("Error creating account", message: "There was an unknown error when creating the account")
                                })
                            }
                        })
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.stopSpinning()
                            self.showErrorAlert("Error creating account", message: "There was an unknown error when creating the account")
                        })
                    }
                })
            } else {
               showErrorAlert("Street address required", message: "An address of your service is need for clients looking for your service")
            }
            
        } else {
            showErrorAlert("All fields required", message: "All fields must be entered in order to sign up")
        }
    }
    
    // MARK: - Helper methods
    func showErrorAlert(title: String, message: String) {
        // Check if an alert controller is already being presented
        if self.presentedViewController == nil {
            createNewAlertViewController(title, message: message)
        } else {
            // The alert controller is already presented or there is another view controller being presented
            let thePresentedViewController: UIViewController? = self.presentedViewController as UIViewController?
            
            if thePresentedViewController != nil {
                
                // Check if the presented controller is an alert view controller
                if let presentedAlertViewController: UIAlertController = thePresentedViewController as? UIAlertController {
                    
                    // Do nothing since the alert controller is already on screen
                    print(presentedAlertViewController)
                } else {
                    // Another view controller presented, so use thePresentedViewController
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                    let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                    alert.addAction(action)
                    thePresentedViewController?.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func createNewAlertViewController(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
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
    
    func leaveSignUpStoryBoard() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func startSpinning() {
        indicatorView.hidden = false
        activityIndicatorView.startAnimating()
    }
    
    func stopSpinning() {
        indicatorView.hidden = true
        activityIndicatorView.stopAnimating()
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
                            self.locationManager.stopUpdatingLocation()
                            
                            // Check if the street address was parsed correctly
                            if self.streetAddress.isEmpty || self.streetAddress == "" {
                                
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