//
//  LocationViewController.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 4/18/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    @IBOutlet weak var streetAddressLabel: UILabel!
    @IBOutlet weak var saveButton: MaterialButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var indicatorView: MaterialIndicatorView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    let streetAddressLabelTapGesture = UITapGestureRecognizer()
    
    var provider: Provider!
    var googlePlacesAutoCompleteViewController: GooglePlacesAutocomplete!
    var locationChanged = false

    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        streetAddressLabelTapGesture.addTarget(self, action: #selector(LocationViewController.presentGooglePlacesAutoComplete))
        streetAddressLabelTapGesture.numberOfTapsRequired = 1
        
        streetAddressLabel.addGestureRecognizer(streetAddressLabelTapGesture)
        streetAddressLabel.userInteractionEnabled = true
        streetAddressLabel.text = provider.address
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        googlePlacesAutoCompleteViewController = GooglePlacesAutocomplete(apiKey: APIKeys.GOOGLE_API_KEY, placeType: .Address)
        googlePlacesAutoCompleteViewController.placeDelegate = self
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        
        if locationChanged {
            NSNotificationCenter.defaultCenter().postNotificationName(NSNotificationCenterPostNotificationNames.LOCATION_UPDATED, object: nil, userInfo: [NSNotificationCenterUserInfoDictKeys.UPDATED_PROVIDER: provider])
        }
    }
    
    // MARK: - Events
    @IBAction func backButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(sender: MaterialButton) {
        guard let streetAddress = streetAddressLabel.text where streetAddress != "" else {
           showErrorAlert("Error updating location", message: "There was an unknown error when updating your location")
            return
        }
        
        disableComponents()
        
        // Start activity indicator animation
        startSpinning(indicatorView, activityIndicatorView: activityIndicatorView)
        
        // Update provider
        provider.address = streetAddress
        
        provider.updateProvider({ (providerUpdated) in
            if providerUpdated == true {
                self.locationChanged = true
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.stopSpinning(self.indicatorView, activityIndicatorView: self.activityIndicatorView)
                    self.enableComponents()
                    self.showErrorAlert("Location updated", message: "Your location has been updated")
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.stopSpinning(self.indicatorView, activityIndicatorView: self.activityIndicatorView)
                    self.enableComponents()
                    self.showErrorAlert("Error updating location", message: "There was an unknown error when updating your location")
                })
            }
        })
    }
    
    // Helper methods
    func presentGooglePlacesAutoComplete() {
        presentViewController(googlePlacesAutoCompleteViewController, animated: true, completion: nil)
    }
    
    func enableComponents() {
        streetAddressLabel.userInteractionEnabled = true
        saveButton.enabled = true
        backButton.enabled = true
    }
    
    func disableComponents() {
        streetAddressLabel.userInteractionEnabled = false
        saveButton.enabled = false
        backButton.enabled = false
    }
}

// MARK: - GooglePlacesAutocompleteDelegate
extension LocationViewController: GooglePlacesAutocompleteDelegate {
    func placeSelected(place: Place) {
        place.getDetails { (PlaceDetails) in
            print(PlaceDetails.formattedAddress)
            self.googlePlacesAutoCompleteViewController.gpaViewController.searchBar.text = PlaceDetails.formattedAddress
        }
    }
    
    func placeViewClosed() {
        guard let streetAddress = googlePlacesAutoCompleteViewController.gpaViewController.searchBar.text where streetAddress != "" else {
            return
        }
        
        streetAddressLabel.text = streetAddress
        
        googlePlacesAutoCompleteViewController.gpaViewController.searchBar.text = ""
        googlePlacesAutoCompleteViewController.gpaViewController.searchBar(googlePlacesAutoCompleteViewController.gpaViewController.searchBar, textDidChange: "")
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}