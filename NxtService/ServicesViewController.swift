//
//  ServicesViewController.swift
//  NxtService
//
//  Created by Emanuel Guerrero
//             Shaquella Dunanson
//             Santago Facuno
//             Jevin Francis
//             Marcus Guerrer
//             Stephen Green
//             Ryan Fernandez on 4/17/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit

class ServicesViewController: UIViewController {
    @IBOutlet weak var mainServiceLabel: UILabel!
    @IBOutlet weak var specialitiesLabel: UILabel!
    @IBOutlet weak var indicatorView: MaterialIndicatorView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: MaterialButton!
    @IBOutlet weak var backButton: UIButton!
    
    let mainServiceTapGesture = UITapGestureRecognizer()
    let specialityTapGesture = UITapGestureRecognizer()
    
    var provider: Provider!
    var servicesChanged = false
    var mainService: String!
    var speciality: String!
    
    var mainServicePickerViewController: MainServicePickerViewController!
    var specialitiesPickerViewController: SpecialitiesPickerViewController!


    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTapGestureRecognizers()
        
        mainServiceLabel.text = provider.mainService.capitalizedString
        specialitiesLabel.text = provider.specialities.capitalizedString
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if servicesChanged {
            NSNotificationCenter.defaultCenter().postNotificationName(NSNotificationCenterPostNotificationNames.SERVICES_UPDATED, object: nil, userInfo: [NSNotificationCenterUserInfoDictKeys.UPDATED_PROVIDER: provider])
        }
    }
    
    // MARK: - Events
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(sender: MaterialButton) {
        guard let mainService = self.mainService where mainService != "", let specialities = self.speciality where specialities != "" else {
            showErrorAlert("Fields needed", message: "All fields must be completed")
            return
        }
        
        
        
        disableComponents()
        
        // Start activity indicator animation
        startSpinning(indicatorView, activityIndicatorView: activityIndicatorView)
        
        // Update the provider
        provider.mainService = mainService
        provider.specialities = specialities
        
        provider.updateProvider({ (providerUpdated) in
            if providerUpdated == true {
                self.servicesChanged = true
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.stopSpinning(self.indicatorView, activityIndicatorView: self.activityIndicatorView)
                    self.enableComponents()
                    self.showErrorAlert("Services updated", message: "Your offered services have been updated")
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.stopSpinning(self.indicatorView, activityIndicatorView: self.activityIndicatorView)
                    self.enableComponents()
                    self.showErrorAlert("Error updating services", message: "There was an unknown error when updating your offered services")
                })
            }
        })
    }
    
    // Helper methods
    func enableComponents() {
        mainServiceLabel.enabled = true
        specialitiesLabel.enabled = true
        saveButton.enabled = true
        backButton.enabled = true
    }
    
    func disableComponents() {
        mainServiceLabel.enabled = false
        specialitiesLabel.enabled = false
        saveButton.enabled = false
        backButton.enabled = false
    }
    
    func setupTapGestureRecognizers() {
        mainServiceTapGesture.addTarget(self, action: #selector(ServicesViewController.mainServiceLabelTapped))
        specialityTapGesture.addTarget(self, action: #selector(ServicesViewController.specialityLabelTapped))
        
        mainServiceTapGesture.numberOfTapsRequired = 1
        specialityTapGesture.numberOfTapsRequired = 1
        
        mainServiceLabel.addGestureRecognizer(mainServiceTapGesture)
        specialitiesLabel.addGestureRecognizer(specialityTapGesture)
        
        mainServiceLabel.userInteractionEnabled = true
        specialitiesLabel.userInteractionEnabled = true
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

// MARK: - UITextFieldDelegate
extension ServicesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - MainServicePickerDelegate
extension ServicesViewController: MainServicePickerDelegate {
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
extension ServicesViewController: SpecialitiesPickerDelegate {
    func specialitySelected(speciality: String) {
        self.speciality = speciality
        specialitiesLabel.text = speciality
    }
}