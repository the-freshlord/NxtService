//
//  SearchViewController.swift
//  NxtService
//
//  Created by Emanuel Guerrero
//             Shaquella Dunanson
//             Santago Facuno
//             Jevin Francis
//             Marcus Guerrer
//             Stephen Green
//             Ryan Fernandez on 4/22/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mainServiceLabel: UILabel!
    @IBOutlet weak var specialitiesLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var indicatorView: UIView!
    
    let locationTapGesture = UITapGestureRecognizer()
    let mainServiceTapGesture = UITapGestureRecognizer()
    let specialityTapGesture = UITapGestureRecognizer()
    
    var streetAddress: String!
    var mainService: String!
    var speciality: String!
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
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        stopSpinning(indicatorView, activityIndicatorView: activityIndicatorView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifiers.SEARCH_RESULTS {
            guard let resultsViewController = segue.destinationViewController as? ResultsViewController else { return }
            guard let senderDictionary = sender as? Dictionary<String, AnyObject> else { return }
            guard let providerList = senderDictionary["sortedProviderList"] as? ProviderList<Provider,Double,UIImage> else { return }
            guard let userLocation = senderDictionary["userLocation"] as? String else { return }
            
            resultsViewController.providerList = providerList
            resultsViewController.userLocation = userLocation
        }
    }
    
    // MARK: - Events
    @IBAction func backButtonTapped(sender: MaterialButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func searchButtonTapped(sender: MaterialButton) {
        guard let streetAddress = self.streetAddress where streetAddress != "", let mainService = self.mainService where mainService != "", let speciality = self.speciality where speciality != "" else {
            showErrorAlert("All fields required", message: "All fields must be entered in order to search")
            return
        }
        
        // Start activity indicator animation
        startSpinning(indicatorView, activityIndicatorView: activityIndicatorView)
        
        // Get sorted provider list
        DataService.dataService.loadProviders(streetAddress, mainService: mainService, speciality: speciality) { (providerList) in
            let sortedProviderList = ProviderList<Provider,Double,UIImage>()
            // Check if any providers were found
            if providerList.count != 0 {
                
                // Get the distance
                for provider in providerList {
                    calculateDistance(streetAddress, providerLocation: provider.address) { (distance) in
                        
                        if provider.profileImage == true {
                            DataService.dataService.loadProfileImage(provider.providerID!, onCompletion: { (decodedImage) in
                                sortedProviderList.insertProvider(provider, distance: distance, image: decodedImage)
                                
                                if sortedProviderList.count == providerList.count {
                                    let senderDictionary = ["sortedProviderList": sortedProviderList, "userLocation": streetAddress]
                                    self.performSegueWithIdentifier(SegueIdentifiers.SEARCH_RESULTS, sender: senderDictionary)
                                }
                            })
                        } else {
                            sortedProviderList.insertProvider(provider, distance: distance, image: UIImage(named: "defaultimage")!)
                            
                            if sortedProviderList.count == providerList.count {
                                let senderDictionary = ["sortedProviderList": sortedProviderList, "userLocation": streetAddress]
                                self.performSegueWithIdentifier(SegueIdentifiers.SEARCH_RESULTS, sender: senderDictionary)
                            }
                        }
                    }
                }
            } else {
                // Send empty list
                let senderDictionary = ["sortedProviderList": sortedProviderList, "userLocation": streetAddress]
                self.performSegueWithIdentifier(SegueIdentifiers.SEARCH_RESULTS, sender: senderDictionary)
            }
        }
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
        guard let mainService = self.mainService where mainService != "" else {
            showErrorAlert("Main Service", message: "You need to select a main service first")
            return
        }
        
        presentViewController(specialitiesPickerViewController, animated: true, completion: nil)
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
                
                // Display the alert view controller
                self.showErrorAlert("Error getting location", message: "Tap on your location to manually enter in your address")
            } else {
                if placeMarks?.count > 0 {
                    guard let placeMark = (placeMarks?[0]) else { return }
                    
                    self.streetAddress = parseAddress(placeMark)
                    manager.stopUpdatingLocation()
                    self.locationManager.stopUpdatingLocation()
                    
                    // Check if the street address was parsed correctly
                    if self.streetAddress.isEmpty || self.streetAddress == "" {
                        
                        // Display the alert view controller
                        self.showErrorAlert("Error getting location", message: "Tap on your location to manually enter in your address")
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
extension SearchViewController: SpecialitiesPickerDelegate {
    func specialitySelected(speciality: String) {
        self.speciality = speciality
        specialitiesLabel.text = speciality
    }
}