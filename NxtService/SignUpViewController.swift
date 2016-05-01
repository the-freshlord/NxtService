//
//  SignUpViewController.swift
//  NxtService
//
//  Created by Emanuel Guerrero
//             Shaquella Dunanson
//             Santago Facuno
//             Jevin Francis
//             Marcus Guerrer
//             Stephen Green
//             Ryan Fernandez on 3/28/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit
import CoreLocation

class SignUpViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mainServiceLabel: UILabel!
    @IBOutlet weak var specialitiesLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var indicatorView: UIView!
    
    let locationTapGesture = UITapGestureRecognizer()
    let mainServiceTapGesture = UITapGestureRecognizer()
    let specialityTapGesture = UITapGestureRecognizer()
    
    var account: Account!
    var provider: Provider!
    var locationManager = CLLocationManager()
    var streetAddress: String!
    var mainService: String!
    var speciality: String!
    var accountCreated = false
    
    var googlePlacesAutoCompleteViewController: GooglePlacesAutocomplete!
    var mainServicePickerViewController: MainServicePickerViewController!
    var specialitiesPickerViewController: SpecialitiesPickerViewController!
    
    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTapGestureRecognizers()
        
        nameTextField.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if locationAuthorizationStatus() {
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        googlePlacesAutoCompleteViewController = GooglePlacesAutocomplete(apiKey: APIKeys.GOOGLE_API_KEY, placeType: .Address)
        googlePlacesAutoCompleteViewController.placeDelegate = self
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if accountCreated {
            stopSpinning(indicatorView, activityIndicatorView: activityIndicatorView)
            NSNotificationCenter.defaultCenter().postNotificationName(NSNotificationCenterPostNotificationNames.ACCOUNT_CREATED, object: nil)
        }
    }
    
    // MARK: - Events
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        nameTextField.resignFirstResponder()
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        leaveSignUpStoryBoard()
    }
    
    @IBAction func getStartedButtonTapped(sender: MaterialButton) {
        guard let name = nameTextField.text where name != "", let mainService = self.mainService where mainService != "",
            let specialities = self.speciality where specialities != "" else {
            showErrorAlert("All fields required", message: "All fields must be entered in order to sign up")
            return
        }
        
        if streetAddress != "" {
            
            // Start activity indicator animation
            startSpinning(indicatorView, activityIndicatorView: activityIndicatorView)
            
            // Create the account
            account.createAccount({ (accountCreated) in
                if accountCreated.boolValue == true {
                    self.provider = Provider(providerID: self.account.accountID!)
                    self.provider.address = self.streetAddress
                    self.provider.name = name
                    self.provider.mainService = mainService
                    self.provider.specialities = specialities
                    
                    self.provider.createProvider({ (providerCreated) in
                        if providerCreated.boolValue == true {
                            self.accountCreated = true
                            self.leaveSignUpStoryBoard()
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.stopSpinning(self.indicatorView, activityIndicatorView: self.activityIndicatorView)
                                self.showErrorAlert("Error creating account", message: "There was an unknown error when creating the account")
                            })
                        }
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.stopSpinning(self.indicatorView, activityIndicatorView: self.activityIndicatorView)
                        self.showErrorAlert("Error creating account", message: "There was an unknown error when creating the account")
                    })
                }
            })
        } else {
            showErrorAlert("Street address required", message: "An address of your service is need for clients looking for your service")
        }
    }
    
    // MARK: - Helper methods
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
    
    func setupTapGestureRecognizers() {
        locationTapGesture.addTarget(self, action: #selector(SignUpViewController.locationLabelTapped))
        mainServiceTapGesture.addTarget(self, action: #selector(SignUpViewController.mainServiceLabelTapped))
        specialityTapGesture.addTarget(self, action: #selector(SignUpViewController.specialityLabelTapped))
        
        locationTapGesture.numberOfTapsRequired = 1
        mainServiceTapGesture.numberOfTapsRequired = 1
        specialityTapGesture.numberOfTapsRequired = 1
        
        locationLabel.addGestureRecognizer(locationTapGesture)
        mainServiceLabel.addGestureRecognizer(mainServiceTapGesture)
        specialitiesLabel.addGestureRecognizer(specialityTapGesture)
        
        locationLabel.userInteractionEnabled = true
        mainServiceLabel.userInteractionEnabled = true
        specialitiesLabel.userInteractionEnabled = true
    }
    
    func locationLabelTapped() {
        presentViewController(googlePlacesAutoCompleteViewController, animated: true, completion: nil)
    }
    
    func mainServiceLabelTapped() {
        mainServicePickerViewController = MainServicePickerViewController()
        mainServicePickerViewController.delegate = self
        
        presentViewController(mainServicePickerViewController, animated: true, completion: nil)
    }
    
    func specialityLabelTapped() {
        guard let mainService = self.mainService where mainService != "" else {
            showErrorAlert("Main Service", message: "You need to select a main service first")
            return
        }
        
        presentViewController(specialitiesPickerViewController, animated: true, completion: nil)
    }
}
    
// MARK: - CLLocationManagerDelegate
extension SignUpViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        
        // Use reverse geocode to get the physical string address based on the latitude and longitude coordinates
        CLGeocoder().reverseGeocodeLocation(location) { (placeMarks: [CLPlacemark]?, error: NSError?) in
            if error != nil {
                
                // Go back to the main thread to display the alert view controller
                dispatch_async(dispatch_get_main_queue(), {
                    self.showErrorAlert("Error getting location", message: "Tap on your location to manually enter in your address")
                })
            } else {
                if placeMarks?.count > 0 {
                    guard let placeMark = (placeMarks?[0]) else { return }
                    
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
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
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
            self.googlePlacesAutoCompleteViewController.gpaViewController.searchBar.text = PlaceDetails.formattedAddress
            self.streetAddress = PlaceDetails.formattedAddress
        }
    }
    
    func placeViewClosed() {
        googlePlacesAutoCompleteViewController.gpaViewController.searchBar.text = ""
        googlePlacesAutoCompleteViewController.gpaViewController.searchBar(googlePlacesAutoCompleteViewController.gpaViewController.searchBar, textDidChange: "")

        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - MainServicePickerDelegate
extension SignUpViewController: MainServicePickerDelegate {
    func mainServiceSelected(mainService: String) {
        if self.mainService != mainService {
            self.speciality = nil
            self.specialitiesLabel.text = "Any specific type of service?"
        }
        
        self.mainService = mainService
        mainServiceLabel.text = mainService
        specialitiesPickerViewController = SpecialitiesPickerViewController(mainService: mainService)
        specialitiesPickerViewController.delegate = self
    }
}

// MARK: - SpecialitiesPickerDelegate
extension SignUpViewController: SpecialitiesPickerDelegate {
    func specialitySelected(speciality: String) {
        self.speciality = speciality
        specialitiesLabel.text = speciality
    }
}