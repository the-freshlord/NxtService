//
//  ServicesViewController.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 4/17/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit

class ServicesViewController: UIViewController {
    @IBOutlet weak var mainServiceTextField: UITextField!
    @IBOutlet weak var specialitiesTextField: UITextField!
    @IBOutlet weak var indicatorView: MaterialIndicatorView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: MaterialButton!
    @IBOutlet weak var backButton: UIButton!
    
    var provider: Provider!
    var servicesChanged = false

    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainServiceTextField.delegate = self
        specialitiesTextField.delegate = self
        
        mainServiceTextField.text = provider.mainService.capitalizedString
        specialitiesTextField.text = provider.specialities.capitalizedString
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
        if let mainService = mainServiceTextField.text where mainService != "", let specialities = specialitiesTextField.text where specialities != "" {
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
        } else {
            showErrorAlert("Fields needed", message: "All fields must be completed")
        }
    }
    
    // Helper methods
    func enableComponents() {
        mainServiceTextField.enabled = true
        specialitiesTextField.enabled = true
        saveButton.enabled = true
        backButton.enabled = true
    }
    
    func disableComponents() {
        mainServiceTextField.enabled = false
        specialitiesTextField.enabled = false
        saveButton.enabled = false
        backButton.enabled = false
    }
}

// MARK: - UITextFieldDelegate
extension ServicesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}