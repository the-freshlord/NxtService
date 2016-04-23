//
//  SearchViewController.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 4/22/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mainServiceLabel: UILabel!
    @IBOutlet weak var specialitiesLabel: UILabel!
    
    let locationTapGesture = UITapGestureRecognizer()
    let mainServiceTapGesture = UITapGestureRecognizer()
    let specialityTapGesture = UITapGestureRecognizer()
    
    var streetAddress = ""
    var mainService = ""
    var speciality = ""
    var locationManager = CLLocationManager()
    var googlePlacesAutoCompleteViewController: GooglePlacesAutocomplete!
    var mainServicePickerViewController: MainServicePickerViewController!
    var specialitiesPickerViewController: SpecialitiesPickerViewController!

    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTapGestureRecognizers()
        
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
    
    // MARK: - Events
    @IBAction func backButtonTapped(sender: MaterialButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func searchButtonTapped(sender: MaterialButton) {
    }
    
    // Helper methods
    func setupTapGestureRecognizers() {
        locationTapGesture.addTarget(self, action: #selector(SearchViewController.locationLabelTapped))
        mainServiceTapGesture.addTarget(self, action: #selector(SearchViewController.mainServiceLabelTapped))
        specialityTapGesture.addTarget(self, action: #selector(SearchViewController.specialityLabelTapped))
        
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
        if mainService == "" {
            showErrorAlert("Main Service", message: "You need to select a main service first")
        } else {
          presentViewController(specialitiesPickerViewController, animated: true, completion: nil)  
        }
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
extension SearchViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        
        // Use reverse geocode to get the physical string address based on the latitude and longitude coordinates
        CLGeocoder().reverseGeocodeLocation(location) { (placeMarks: [CLPlacemark]?, error: NSError?) in
            if error != nil {
                
                // Go back to the main thread to display the alert view controller
                dispatch_async(dispatch_get_main_queue(), {
                    self.showErrorAlert("Error getting location", message: "Tap on your location to manually enter in your address")
                    return
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
                            return
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

// MARK: - GooglePlacesAutocompleteDelegate
extension SearchViewController: GooglePlacesAutocompleteDelegate {
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
extension SearchViewController: MainServicePickerDelegate {
    func mainServiceSelected(mainService: String) {
        self.mainService = mainService
        specialitiesPickerViewController = SpecialitiesPickerViewController(mainService: mainService)
        specialitiesPickerViewController.delegate = self
    }
}

// MARK: - SpecialitiesPickerDelegate
extension SearchViewController: SpecialitiesPickerDelegate {
    func specialitySelected(speciality: String) {
        self.speciality = speciality
    }
}